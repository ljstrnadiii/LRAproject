# LRAproject
Final Project for Linear Regression Analysis: considers temperature reconstruction model based on proxy data

## R Files:
-'Model.R': performs data summary, considers collinearity, and model selection
-'Diagnostics.R': performs model diagnostics and compares two models: with and without time variable when extrapolating.

## Data:
- The data includes variables:
  1. tree ring proxy information: wusa, jasper, tornetrask, urals, mongolia, tasman
  2. ice core proxy information: westgreeen
  3. sea shell proxy information: chesapeake
  4. time: year

## Brief Summary:
We build the model on the last 145 years of data with measured temperatures. There is proxy information back to 1000 a.d.. The model selection process builds a significantly better model when including 'year', however, it does a terrible job at extrapolating or looking anything like Jones 2004 reconstruction. Considering model selection again without year leads to a significantly weaker model in that it has a MSE 50% larger than the final and has an R-squares of .4 instead of .6, but it id nearly identical to the Jones 2004 reconstruction.. The takeaway from the paper is that the model selection process lends itself to different results depending on the intent of the model: extrapolation or not. This project highlights the importance of assessing the underlying structure of a model. 
