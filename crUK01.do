* Divers of vaccine uptake in the UK
* June 8, 2023 Catherine Arsenault
clear all 
global user "/Users/catherine.arsenault/Dropbox"
global data "SPH Kruk Active Projects/Vaccine hesitancy/Final data"
global analysis "SPH Kruk Active Projects/Vaccine hesitancy/Analyses/Vax hesitancy USA"

import spss using "$user/$data/HSPH Health Systems Survey_UK Final_04142023.sav", clear 

notes drop _all
rename *, lower

	*VACCINE ATTITUDES AND UPTAKE
		* 3 vaccine confidence questions
		recode q1_21_a (1/2=1) (3/5=0) (999=.), gen(important)
		recode q1_21_b (1/2=1) (3/5=0) (999=.), gen(safe)
		recode q1_21_c (1/2=1) (3/5=0) (999=.), gen(effective)
		* Covid at least 3 doses
		recode q1_17 (1/3=0) (4/5=1) (999=.), gen(covid3plus)
		* Flu (only recommended for at risk ppl)
		*recode q2_25 (2=0) (999=.), gen(flu)
		* Any child 1-18
		recode numofchildren (1/7=1) (999=.), gen(child18)
		* Child vaccines
		recode  q2_28 (0/1=0) (2/5=1) (999=.) , gen(childcovid2)
		recode  q2_27 (2=0) (999=.), gen(mmr)
		recode  q2_26 (2=0) (999=.), gen(hpv)
	
	* DEMOGRAPHICS
		gen income = q4_14
		recode income (999=.)
save "$user/$analysis/Data for analysis/UKvaxhesitancy.dta", replace

* LCA Model 1  VCI, COVID3
		gsem (important safe effective covid3  <- ), logit lclass(C 2)
		estimates store twoclass
		
		gsem (important safe effective covid3 <- ), logit lclass(C 3) 
		estimates store threeclass  // wont converge

		gsem (important safe effective covid3plu <- ), logit lclass(C 2)
		estat lcprob
		estat lcmean 
	* Predict the probability of belonging to each class
			predict cpost*, classposteriorpr 
			egen max = rowmax(cpost*)
			generate predclass = 1 if cpost1==max
			replace predclass = 2 if cpost2==max
			replace predclass = 3 if cpost3==max
			lab def predclass 1"Hesitant" 2"Complacent" 3"Confident"
			lab val pred pred
	* Multinomial logit regression for class membership	
			mlogit predclass low_income nocollege i.agecat i.raceeth ///
				   i.political has_GP i.visits, baseoutcome(3)
