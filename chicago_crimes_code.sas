proc import datafile='s:\My SAS Files\9.4\crimes_month_num.csv' out=dataout dbms=csv replace;
  getnames=yes;
run;

data dataout;
set dataout;

/* I determined that there were missing values in location_description so will delete these records */
if cmiss(of location_description) then delete;

violent=1;
if primary_type in ('DECEPTIVE PRACTICE', 
					'OTHER OFFENSE', 
					'BURGLARY', 
					'CRIMINAL DAMAGE', 
					'CRIMINAL TRESPASS',
					'GAMBLING',
					'INTERFERENCE WITH PU',
					'LIQUOR LAW VIOLATION',
					'MOTOR VEHICLE THEFT',
					'NARCOTICS',
					'NON-CRIMINAL',
					'NON - CRIMINAL',
					'NON-CRIMINAL (SUBJEC',
					'OBSCENITY',
					'OTHER NARCOTICS VIOLA',
					'OTHER OFFENSE',
					'PROSTITUTION',
					'PUBLIC INDECENCY',
					'PUBLIC PEACE VIOLATI',
					'THEFT') 
then violent=0;

arrest_bin=1;
if arrest='false' then arrest_bin=0;

outside=0;
if location_description in ('AIRPORT EXTERIOR - NON-SECURE',
							'ALLEY',
							'CAR WASH',
							'CTA BUS STOP',
							'CTA PLATFORM',
							'DRIVEWAY - RESIDENTIAL',
							'GAS STATION',
							'PARK PROPERTY',
							'PARKING LOT/GARAGE(NON.RESID.)',
							'SCHOOL, PUBLIC, GROUNDS',
							'SIDEWALK',
							'STREET',
							'VACANT LOT',
							'VACANT LOT/LAND') 
then outside=1;

warm = date;

* Frequency table of the Y variable;
proc freq data=dataout;
tables violent;
run;

* Split data into training and testing;
proc surveyselect data=dataout out=train seed=783452 samprate=0.75 outall;
run;

data train;
set train;
if selected then train_y=violent;
run;

proc print data=train(obs=20);
run;

* fit full model on all variables using training data;
proc logistic data=train;
model violent(event='1') = warm outside arrest_bin warm*outside warm*arrest_bin outside*arrest_bin / stb;
run;

* select features using model selection Forward;
proc logistic data=train;
model violent(event='1') = warm outside arrest_bin warm*outside warm*arrest_bin outside*arrest_bin / selection=forward;
run;

* select features using model selection Backward;
proc logistic data=train;
model violent(event='1') = warm outside arrest_bin warm*outside warm*arrest_bin outside*arrest_bin / selection=backward;
run;

* select features using model selection Stepwise;
proc logistic data=train;
model violent(event='1') = warm outside arrest_bin warm*outside warm*arrest_bin outside*arrest_bin / selection=stepwise;
run;

* Final model - corrb provides the logistic regression model statement;
ods graphics on;
proc logistic data=train;
*model violent(event='1') = warm outside arrest_bin warm*outside warm*arrest_bin outside*arrest_bin / influence iplots corrb stb;
model violent(event='1') = warm outside arrest_bin warm*outside warm*arrest_bin outside*arrest_bin / stb;
run;
ods graphics off;

* build predictors from the model;
proc logistic data=train;
model train_y(event='1') = warm outside arrest_bin warm*outside warm*arrest_bin outside*arrest_bin / ctable pprob=(0.1 to 0.6 by 0.05);
output out=pred(where=(train_y=.)) p=phat lower=lcl upper=ucl predprobs=(individual);
run;

* compute predicted Y in testing set for pred_prob > 0.35 as determined above;
data probs;
set pred;
pred_y=0;
threshold=0.35; *calculated from the classification matrix;
if phat>threshold then pred_y=1;
run;

* compute classification matrix;
proc freq data=probs;
tables violent*pred_y / norow nocol nopercent;
run;

* odds ratio for each attribute;
data new;
input warm outside arrest_bin;
datalines;
1 1 1
;
data pred;
set new train;
run;

proc logistic data=pred;
model train_y(event='1') = warm outside arrest_bin warm*outside warm*arrest_bin outside*arrest_bin / ctable pprob=(0.1 to 0.6 by 0.05);
output out=pred p=phat lower=lcl upper=ucl predprobs=(individual);
run;

proc print data=pred(obs=20);
run;
