# This script assesses collinearity, data summary, and model selectin process
# Dataset: Globwarm located at
#       https://www.ncdc.noaa.gov/paleo/pubs/jones2004/jones2004.html

library(xtable)
library(car)
library(faraway)
library(perturb)
library(leaps)

load("globwarm.rda")

historical = tail(globwarm, n=145)

#full model
lm1 = lm(nhtemp~., globwarm)
print(vif(lm1))
print(xtable(as.matrix(vif(lm1))))

# VIF suggests to remove mongolia
lmnew = lm(nhtemp~.-mongolia, globwarm)

# check the variance decomposition
dec = colldiag(lmnew, scale=FALSE, add.intercept=FALSE)
print(dec)
# condindx high but no pair of high proportions
print(xtable(dec$pi))

############# Model Selection using best subset and stepwise
# best subset 
p=2:9
b = regsubsets(nhtemp~.-mongolia, historical)
rs = summary(b)
print(rs$which)
print(summary(lmnew))

# AIC best selection
aic <- rs$bic + p *(2-log(nrow(historical)))
png("aic.png")
plot(aic~p,ylab="AIC")
dev.off()

#BIC best selection
bic <- rs$bic
png("bic.png")
plot(bic~p, ylab="BIC")
dev.off()

#cp best selection
cp = rs$cp
png("cp.png")
plot(cp~p, ylab=expression(paste(C[p],"statistic")))
abline(0,1)
dev.off()

# adjr best subset
adjr = rs$adjr
png("adjr.png")
plot(adjr~p, ylab=expression({R^2}[a]))
dev.off()

#stepwise selection with AIC
step = step(lmnew, direction="both")
print(summary(step))

#conclusion: use  wusa + westgreen + chesapeake + year

#assessment of multicollinerity of final model
final  = lm(nhtemp  ~wusa + westgreen + chesapeake + year, data = historical)

# plot the differences in coefficients:
#   add 10% of sd of noise to check sensitivity of coeffs
lmpert = lm(nhtemp + .1*sd(historical$nhtemp)*rnorm(nrow(historical))~
            wusa + westgreen + chesapeake + year, data = historical)
print(xtable(as.matrix((coef(final)-coef(lmpert))/coef(final))))


# anova for 5 or 4 predictors 
lm2 = lm(nhtemp~ wusa + westgreen + chesapeake + year,historical)
print(anova(step, lm2))



