# Practical Machine Learning Assignment
*by Alvaro Diaz Falconi, August 2020*

## Synopsis

Using devices such as Jawbone Up, Nike FuelBand, and Fitbit it is now possible to collect a large amount of data about personal activity relatively inexpensively. They were asked to perform barbell lifts correctly and incorrectly in 5 different ways. More information is available from the website here: http://groupware.les.inf.puc-rio.br/har (see the section on the Weight Lifting Exercise Dataset). 

The goal of your project is to predict the manner in which they did the exercise. This is the "classe" variable in the training set. You may use any of the other variables to predict with. You should create a report describing how you built your model, how you used cross validation, what you think the expected out of sample error is, and why you made the choices you did. You will also use your prediction model to predict 20 different test cases. 

Six young health participants were asked to perform one set of 10 repetitions of the Unilateral Dumbbell Biceps Curl in five different fashions:

Class A: Exactly according to the specification
Class B: Throwing the elbows to the front
Class C: Lifting the dumbbell only halfway
Class D: Lowering the dumbbell only halfway
Class E: Throwing the hips to the front

## Data Processing

Download and load the testing and training data


```r
train <- read.csv("pml-training.csv")
test  <- read.csv("pml-testing.csv")
```

Separate the training data into two parts, one to build the model and the other to validate it, 


```r
library(caret)
trainNdx <- createDataPartition(train$classe, p=0.8, list=FALSE)
Train <- train[ trainNdx, ]
Valid <- train[-trainNdx, ]
```

Clean the data excluding near zero variance features


```r
nzv <- nearZeroVar(Train)
Train <- Train[, -nzv]
```

Also exclude columns with missing values


```r
NL <- sapply(Train, function(x) {
    sum(!(is.na(x) | x == ""))})
NC <- names(NL[NL < 0.6 * length(Train$classe)])
ND <- c("X", "user_name", "raw_timestamp_part_1", 
        "raw_timestamp_part_2", "cvtd_timestamp", 
        "new_window", "num_window")
Train <- Train[, !names(Train) %in% c(ND, NC)]
```

## Modelling

Use Random Forest to build a model 


```r
library(randomForest);
rfModel <- randomForest(classe ~ ., Train, importance=TRUE, ntrees=10)
```

# Testing

Using the predict function can elaborate a cross-tabulation of observed and predicted classes with associated statistics


```r
pTrain <- predict(rfModel, Train)
print(confusionMatrix(pTrain, Train$classe))
```

```
## Confusion Matrix and Statistics
## 
##           Reference
## Prediction    A    B    C    D    E
##          A 4464    0    0    0    0
##          B    0 3038    0    0    0
##          C    0    0 2738    0    0
##          D    0    0    0 2573    0
##          E    0    0    0    0 2886
## 
## Overall Statistics
##                                 
##                Accuracy : 1     
##                  95% CI : (1, 1)
##     No Information Rate : 0.284 
##     P-Value [Acc > NIR] : <2e-16
##                                 
##                   Kappa : 1     
##  Mcnemar's Test P-Value : NA    
## 
## Statistics by Class:
## 
##                      Class: A Class: B Class: C Class: D Class: E
## Sensitivity             1.000    1.000    1.000    1.000    1.000
## Specificity             1.000    1.000    1.000    1.000    1.000
## Pos Pred Value          1.000    1.000    1.000    1.000    1.000
## Neg Pred Value          1.000    1.000    1.000    1.000    1.000
## Prevalence              0.284    0.194    0.174    0.164    0.184
## Detection Rate          0.284    0.194    0.174    0.164    0.184
## Detection Prevalence    0.284    0.194    0.174    0.164    0.184
## Balanced Accuracy       1.000    1.000    1.000    1.000    1.000
```

According with the documentation of the package, the model aprove the test.  (See "Building predictive models in R using the caret package"", Journal of Statistical Software, http://www.jstatsoft.org/v28/i05/)

## Validating

Now test the model against the validation set


```r
pValid <- predict(rfModel, Valid)
print(confusionMatrix(pValid, Valid$classe))
```

```
## Confusion Matrix and Statistics
## 
##           Reference
## Prediction    A    B    C    D    E
##          A 1114    3    0    0    0
##          B    1  755    0    0    0
##          C    0    1  684    7    0
##          D    0    0    0  635    2
##          E    1    0    0    1  719
## 
## Overall Statistics
##                                         
##                Accuracy : 0.996         
##                  95% CI : (0.993, 0.998)
##     No Information Rate : 0.284         
##     P-Value [Acc > NIR] : <2e-16        
##                                         
##                   Kappa : 0.995         
##  Mcnemar's Test P-Value : NA            
## 
## Statistics by Class:
## 
##                      Class: A Class: B Class: C Class: D Class: E
## Sensitivity             0.998    0.995    1.000    0.988    0.997
## Specificity             0.999    1.000    0.998    0.999    0.999
## Pos Pred Value          0.997    0.999    0.988    0.997    0.997
## Neg Pred Value          0.999    0.999    1.000    0.998    0.999
## Prevalence              0.284    0.193    0.174    0.164    0.184
## Detection Rate          0.284    0.192    0.174    0.162    0.183
## Detection Prevalence    0.285    0.193    0.176    0.162    0.184
## Balanced Accuracy       0.999    0.997    0.999    0.993    0.998
```

## Conclusions

Based on preious results now we can use the Random Forest model to predict the results over the original test set.


```r
pTest <- predict(rfModel, test)
pTest
```

```
##  1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 17 18 19 20 
##  B  A  B  A  A  E  D  B  A  A  B  C  B  A  E  E  A  B  B  B 
## Levels: A B C D E
```

## Appendix

Files for the submission part.


```r
pml_write_files = function(x) {
    for (i in 1:length(x)) {
        FN = paste0("problem_id_", i, ".txt")
        write.table(x[i], file=FN, quote=FALSE, 
                    row.names=FALSE, col.names=FALSE)
    }
}
```

Write the files


```r
pml_write_files(as.vector(pTest))
```


