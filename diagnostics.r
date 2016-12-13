# this script looks at the model diagnostics for the final model chosen using the model seleciton process in the model.r file and compares extrapolation

library(faraway)
library(car)
library(xtable)

load("globwarm.rda")

# there is onyl 145 years of nhtemp data
historical = tail(globwarm, n=145)

final = lm(nhtemp~ wusa + westgreen + chesapeake+year , data = historical) 


# constant variance
png("constantvar.png")
plot(fitted(final), residuals(final), xlab="fitted", ylab="residuals")
abline(h=0)
dev.off()


# check the normality assumption
png("normalassum.png")
qqnorm(residuals(final))
dev.off()
print(shapiro.test(residuals(final)))


# check for large leverage points
hatv = hatvalues(final)
png("leverage.png")
halfnorm(hatv, labs = 1856:2000, ylab = "leverages")
dev.off()

# check for outliers
print(outlierTest(final))


# Check for influential points
cook = cooks.distance(final)

png("influential.png")
halfnorm(cook, 3, labs=1856:2000, ylab="cook's distances")
dev.off()

#------> compare with these three influential removed
#remove potential and loop through to find differences in coeffs for each 
c = c(1855,1855,1855)-c(1878,1998,1875)
print(coef(final))
for(i in c){
  final1 = lm(nhtemp~wusa+westgreen+chesapeake+year, data = historical[i,])
  print(i)
  print(xtable(as.matrix((coef(final)-coef(final1))/coef(final))))
}
# the largest difference in coefficient is a decrease of 20% for 1875. 1875 seems
#   to be the most influential. 


# Assess the structure of the model
png("crplot.png")
par(mfrow=c(2,2))

crPlot(final, variable = "wusa", main = "component + residual")
crPlot(final, variable = "westgreen", main = "component + residual")
crPlot(final, variable = "chesapeake", main = "component + residual")
crPlot(final, variable = "year", main = "component + residual")
dev.off()

# Assess the serial correlation:
png("serial.png")

plot( historical$year,residuals(final), xlab="year", ylab="residuals")
dev.off()


# prediction on years before measurements

png("test.png")

newx = globwarm[,c(2,4,5,10)]
prd = predict(final, newdata=newx, interval="prediction",type="response")
plot((prd[,1]), type="l" ,xlab="year", ylab="temp change")

lines( (prd[,2]), col="red", lty=2)
lines( (prd[,3]), col="red", lty=2)
abline(v=855)
dev.off()

notime = lm(nhtemp~ wusa + jasper + chesapeake + tornetrask + urals + tasman,
            historical)


# predict without time.
png("minustime.png")
newx = globwarm[,c(2,3,5,6,7,9)]
prd = predict(notime, newdata = newx, interval="prediction", type="response")
plot(prd[,1], type="l", ylim=c(-1,1),xlab="year", ylab="temp change")
lines(prd[,2], col="red", lty=2)
lines(prd[,3], col="red", lty=2)

abline(v=855)
dev.off()


#print mse 
print(mean(final$residuals^2))
print(mean(notime$residuals^2))


