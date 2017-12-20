# Analysis of Chicago Violent Crime with Respect to Warm or Cold Months of the Year


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

I created a `warm` variable on the premise that months 4, 5, 6, 7, 8, 9 are warm months in Chicago.  If the `date` variable had one of these month numbers, `warm = 1` otherwise `warm = 0`. I did this data transformation using Python ([crimes_dataset_preprocessing.py](https://github.com/alexkelley/chicago-crime-analysis/blob/master/crimes_dataset_preprocessing.py)). 

I converted the true or false text values of `arrest` to 1 or 0 to create the `arrest_bin` variable.

Finally I converted `location_description` values to `outside = 1` if the location was exposed to the weather; `outside = 0` if not.  I found some missing values for location_description so decided to exclude these records before converting to binary variable. 

I created interactive variables: warm*outside, warm*arrest_bin and outside*arrest_bin.

Total sample size (6,468,080) divided by the number of predictors (6) = 1,078,013 so we have enough samples.


