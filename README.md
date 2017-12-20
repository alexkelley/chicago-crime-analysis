# Analysis of Chicago Violent Crime with Respect to Warm or Cold Months of the Year


I built this analysis around the reported crimes data provided by the city of Chicago in the Chicago Data Portal ([Chicago Crimes Data](https://data.cityofchicago.org/Public-Safety/Crimes-2001-to-present/ijzp-q8t2)).  The dataset is a collection of reported incidents of crime from 2001 to the present.  The police department anonymized the records to protect the privacy of citizens.  The data has 22 fields that describe a crime's date, location, type and arrest status.

My goal was to use the Chicago crimes data to determine if the weather influences criminal behavior to be of a more violent nature.  From a survey of the available fields in the dataset, I selected the following as potentially relevant features to use in my analysis:
* date
* location_description
* arrest
* fbi_code
* primary_type
* description

I determined that the method to answer my question would be a logistic regression model because the response variable that I want (violent crime committed or not) is binary.  The dataset has over 6 million rows so I had a sufficient number of observations for a good model.


