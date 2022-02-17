#Load R packages
library(RWeka)       # Weka
library(party)       # A computational toolbox for recursive partitioning
library(partykit)    # A toolkit with infrastructure for representing, summarizing, and visualizing tree-structured regression and classification models.

# Helper packages
library(dplyr)       # for data wrangling
library(ggplot2)     # for awesome plotting

# Modeling packages
library(rpart)       # direct engine for decision tree application
library(caret)       # meta engine for decision tree application
library(AmesHousing) # dataset

# Model interpretability packages
library(rpart.plot)  # for plotting decision trees
library(vip)         # for feature importance
library(pdp)         # for feature effects

options(warn=-1)
library(e1071)
library(rsample)  # data splitting
library(caret)    # implementing with caret
library(naivebayes) # naive bayes package

require(caret)
require(e1071)
require(rpart)
require(dplyr)
require(stringr)
require(randomForest)
library(rsample)
library(arules)
library(arulesViz)