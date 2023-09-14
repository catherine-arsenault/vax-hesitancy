* Divers of vaccine uptake in the USA
* May 9, 2023 Catherine Arsenault
clear all 
global user "/Users/catherine.arsenault/Dropbox"
global data "SPH Kruk Active Projects/Vaccine hesitancy/Final data"
global analysis "SPH Kruk Active Projects/Vaccine hesitancy/Analyses/Vax hesitancy USA"

import spss using "$user/$data/HSPH Health Systems Survey_Final us Italy Mexico Weighted Data_2.1.23_confidential.sav", clear 

	rename *, lower
	rename bident_country country
	keep if country==1 // USA only
	drop *mx*
	drop *it*
	
	*VACCINE ATTITUDES AND UPTAKE
		* 3 vaccine confidence questions
		recode q1_21_a (1/2=1) (3/5=0) (999=.), gen(important)
		recode q1_21_b (1/2=1) (3/5=0) (999=.), gen(safe)
		recode q1_21_c (1/2=1) (3/5=0) (999=.), gen(effective)
		* Covid at least 3 doses
		recode q1_17 (1/3=0) (4/5=1) (999=.), gen(covid3plus)
		* Flu
		recode q2_25 (2=0) (999=.), gen(flu)
		* Any child 1-18
		recode numofchildren (1/7=1) (999=.), gen(child18)
		* Child vaccines
		recode  q2_28 (0/1=0) (2/5=1) (999=.) , gen(childcovid2)
		recode  q2_27 (2=0) (999=.), gen(mmr)
		recode  q2_26 (2=0) (999=.), gen(hpv)
		* vaccine plans
		recode q1_18 (2/3=0) (999=.), gen (plan_covid)
		* trust in science and cdc
		recode  q2_30_a (1/2=1) (3/4=0) (998/999=.), gen(trust_science)
		recode  q2_30_b (1/2=1) (3/4=0) (998/999=.), gen(trust_cdc)
		* Access
		recode  q2_29 (1/2=1) (3/4=0) (998/999=.), gen(access)
		* Risk
		recode q2_31 (2=0) (998/999=.), gen(risk_covid)
		* Gov management pandemic
		recode q4_10 (1/2=1) (3/5=0) (998/999=.), gen(mgmt_covid)
		
	*COVARIATES
		* Demographic
		recode q1_1  (999=.), gen(age)
		recode age (18/30=1) (31/49=2) (50/69=3) (70/100=4), gen(agecat)
		gen low_income= q4_14us
		recode low_income (1/3=1) (4/5=0) (999=.)
		gen nocollege = q1_11us
		recode nocollege (1/4=1) (5/6=0) (999=.)
			*Race ethnicity 
		gen raceethnicity = 1 if q1_6a==1
		replace raceethnicity = 2 if q1_6b_5==1 & q1_6a!=1
		replace raceethnicity = 3 if q1_6b_1==1 & q1_6a!=1
		replace raceethnicity = 4 if  q1_6b_2==1 & q1_6a!=1
		replace raceethnicity = 5 if raceethnicity==.
			* Political affiliation
		gen political = q4_13us
		replace political = 1 if political == 4 & partylean==1
		replace political = 2 if political == 4 & partylean==2
		replace political = 3 if political == 4 & partylean==3
		recode political (4=.)
			* State groups
		gen stategroupus= q1_3us
		recode stategroupus (1 4 10 15 18 19 20 25 26 27 32 34 36 37 41 43 49 = 1) ///
							(2 5 6 7 8 9 12 21 22 24 30 31 33 40 45 47 48 = 3) ///
							(3 11 13 14 16 17 23 28 29 35 38 39 42 44 46 50 51 =2) 
		* Health care variables
		 recode q2_1 (2=0) (999=.), gen(has_GP)
		 gen visits = q2_6_1
		 recode visits (1/4=1) (5/9=2) (10/60=3) (100/999=.)
		 lab def visits 0 "No visit" 1"1-4" 2"5-9" 3"10 or more" 
		 lab val visits visits
		 replace visits = 0 if q2_7==1
		 replace visits = 1 if q2_7==2
		 replace visits = 2 if q2_7==3
		 replace visits = 3 if q2_7==4
	
		
		lab def vc 1"Strongly or somewhat agree" 0"Strongly or somewhat disagree, neither"
		lab val important vc 
		lab val safe vc
		lab val effective vc	
		lab def plan 1"Plans to receive all doses" 0"Doesn't plan to receive all doses or unsure"
		lab val plan plan 
		lab def trust 1"Trust a lot or some" 0"Trust Not at all or not much"
		lab val trust* trust 
		lab def access 1"Very or somewhat easy to access" 0 "Somewhat or very difficult to access" 
		lab val access access 
		lab def risk 1"Yes" 0"No" 
		lab val risk risk 
		lab def mgmt 1"Excellent or v.good" 0"Good, fair, poor"
		lab val mgmt mgmt
		lab var age "Age in years"
		lab def political 1 "Republican" 2"Democrat" 3 "Independent"
		lab val political political
		lab def raceethnicity 1"Hispanic" 2 "White NH" 3 "Black NH" 4 "Asian NH" 5 "Other" 
		lab val raceethnicity raceethnicity
		lab def stategroupus 1"Poorest" 2"Middle" 3 "Richest"
		lab val stategroupus stategroupus
	save "$user/$analysis/Data for analysis/USvaxhesitancy.dta", replace

	
	/* Vaccine confidence
		recode q1_21_a (1=4) (2=3) (3=2) (4=1) (5=0) (999=.), gen(important)
		recode q1_21_b (1=4) (2=3) (3=2) (4=1) (5=0) (999=.), gen(safe)
		recode q1_21_c (1=4) (2=3) (3=2) (4=1) (5=0) (999=.), gen(effective)
		lab def vc 0"Strongly disagree" 1"Somewhat disagree" 2"Neither agree nor disagree" ///
				   3"Somewhat agree" 4"Strongly agree"
		lab val important vc
		lab val safe vc
		lab val effective vc
	
		egen vc_score = rowtotal(important safe effective)
	
	* Vaccine uptake
		recode q1_17 (1=0) (2=1) (3=2) (4=3) (5=4) (999=.), gen(covid_doses)
		lab def doses 0"0 dose" 1"1 dose" 2"2 doses" 3 "3 doses" 4 "4 or more"
		lab val covid_doses doses
		recode q2_25 (2=0) (999=.), gen(flu)
		recode q2_28 (1=0) (2=1) (3=2) (4=3) (5=4) (999=.), gen(child_covid)
		lab val child_covid doses
		
		
keep country weight important safe effective covid_doses flu child_covid mmr
	
	