# Analysis of Chicago Violent Crime with Respect to Warm or Cold Months of the Year

November 6, 2017

## Overview

I built this analysis around the reported crimes data provided by the city of Chicago in the Chicago Data Portal ([Chicago Crimes Data](https://data.cityofchicago.org/Public-Safety/Crimes-2001-to-present/ijzp-q8t2)).  The dataset is a collection of reported incidents of crime from 2001 to the present.  The police department anonymized the records to protect the privacy of citizens.  The data has 22 fields that describe a crime's date, location, type and arrest status.

My goal was to use the Chicago crimes data to determine if the weather influences criminal behavior to be of a more violent nature.  From a survey of the available fields in the dataset, I selected the following as potentially relevant features to use in my analysis:
* `date`
* `location_description`
* `arrest`
* `fbi_code`
* `primary_type`
* `description`

I determined that the method to answer my question would be a logistic regression model because the response variable that I want (violent crime committed or not) is binary.  The dataset has over 6 million rows so I had a sufficient number of observations for a good model.

I began by creating my Y-variable `violent` by classifying all the `primary_type` (crimes) values as either violent or not.

I created a `warm` variable on the premise that months 4, 5, 6, 7, 8, 9 are warm months in Chicago.  If the `date` variable had one of these month numbers, `warm = 1` otherwise `warm = 0`. I did this data transformation using Python ([crimes\_dataset\_preprocessing.py](https://github.com/alexkelley/chicago-crime-analysis/blob/master/crimes_dataset_preprocessing.py)). 

I converted the true or false text values of `arrest` to 1 or 0 to create the `arrest_bin` variable.

Finally I converted `location_description` values to `outside = 1` if the location was exposed to the weather; `outside = 0` if not.  I found some missing values for location_description so decided to exclude these records before converting to binary variable. 

I also created interactive variables to determine if the data had any relationships among the variables:
* `warm*outside`
* `warm*arrest_bin`
* `outside*arrest_bin`

Total sample size (6,468,080) divided by the number of predictors (6) = 1,078,013 so I had sufficent samples to proceed with building a model.

## Final model

[SAS code](https://github.com/alexkelley/chicago-crime-analysis/blob/master/chicago_crimes_code.sas)

log(p&#770;/(1-p&#770;)) = -0.7958 - 0.0144 `warm` + 0.8177 `outside` + 0.3587 `arrest_bin` + 0.1475 `warm*outside` + 0.0556 `warm*arrest_bin` - 1.5889 `outside*arrest_bin`

Where:
* `warm = 1` (warm month);  `warm = 0` (cold month)
* `outside = 1` (crime occurred in a location sheltered from the weather); `outside = 0` (crime occurred in the elements)
* `arrest_bin = 1` (an arrest occurred with the crime); `arrest_bin = 0` (an arrest did not occur with the crime) 

## Model Statistics

<table>
<tr><td>AIC</td><td>6,391,755.0</td></tr>
<tr><td>SC</td><td>6,391,768.4</td></tr>
<tr><td>LR</td><td>214,013.197</td></tr>
<tr><td>Pr>ChiSq</td><td>< 0.0001</td></tr>
</table>

The AIC and SC values are high and the associated p-value is very low which all indicate that the model is a good fit to the data.

In analysing the Beta coefficients, H<sub>0</sub>: p<sub>j</sub>=0 and H<sub>a</sub>:p<sub>j</sub><>0.  To analyze goodness-of-fit, I looked to the Likelihood Ratio Test.  From the chart, we see that the LR of 214,013.197 is high and that the p-value of < 0.0001 for LR is almost zero so we can reject the null hypothesis that all parameters in the the model are equal to zero.

### Classification Matrix

<table>
<tr><th>Condition</th><th>Count</th></tr>
<tr><td>True Positive</td><td>320,710</td></tr>
<tr><td>True Negative</td><td>350,665</td></tr>
<tr><td>False Positive</td><td>668,419</td></tr>
<tr><td>False Negative</td><td>276,872</td></tr>
</table>

<table>
<tr><th>Performance</th><th>%</th></tr>
<tr><td>Sensitivity</td><td>33.93</td></tr>
<tr><td>Accuracy</td><td>61.18</td></tr>
<tr><td>Precision</td><td>47.77</td></tr>
<tr><td>F-measure</td><td>39.68</td></tr>
</table>

In evaluating the predictive performance of my model, I found rather low sensitivity and precision values despite an accuracy level above 50%.  My conclusion is that this model is not a good one for predicting if a crime will be violent or not.

## Predictive Value of the Model

95% Confidence Interval for variables:

* `warm = 1`: The odds of a crime being violent increases by 36.03% (35.91%, 36.14%) in the warm months.

* `arrest_bin = 1`: The odds of a crime being violent increases by 48.09% (47.88%, 48.31%) if an arrest is made.

* `outside = 1`: The odds of a crime being violent increases by 65.78% (65.58%, 65.99%) if the crime location is outside.

## Conclusions

The month of the year, location and whether an arrest was made all appear to determine in some degree whether a crime will be of a violent nature or not.  The specific models that I tested do not appear to be a strong predictor of violent crime however.
I used the internet article by [Mowafak Allaham and Ryan Marx](http://www.chicagotribune.com/news/data/ct-crime-heat-analysis-htmlstory.html) written this summer to guide the methodology in my analysis.  This study found correlation between the occurrence rate of certain crimes with the atmospheric temperature.   I did not use a temperature by day dataset as in this study; I classified a date as either a warm period or not using a binary variable.

## Limitations of My Analysis

* Data could have been misclassified during the transformation process.
* My assignment of certain `location_description` values to `outside = 1` or `outside = 0` could have been flawed.
* My assignment of `primary_type` values to `violent` could have flawed logic.
* The data is updated daily so results would change depending on when the analysis is run.  I downloaded the dataset on November 6, 2017.

## Possible Future Direction

* Join data from other sources like weather data to make more accurate predictions about temperature with respect to crime rates.
* Utilize the FBI codes and join other sources to have a clear and consistent definition of a violent crime.



