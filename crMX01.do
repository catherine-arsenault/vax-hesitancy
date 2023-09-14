* Divers of vaccine uptake in Italy
* June 8, 2023 Catherine Arsenault
clear all 
global user "/Users/catherine.arsenault/Dropbox"
global data "SPH Kruk Active Projects/Vaccine hesitancy/Final data"
global analysis "SPH Kruk Active Projects/Vaccine hesitancy/Analyses/Vax hesitancy USA"

import spss using "$user/$data/HSPH Health Systems Survey_Final us Italy Mexico Weighted Data_2.1.23_confidential.sav", clear 

	rename *, lower
	rename bident_country country
	keep if country==2 // Mexico only

	
	*VACCINE ATTITUDES AND UPTAKE
		* 3 vaccine confidence questions
		recode q1_21_a (1/2=1) (3/5=0) (999=.), gen(important)
		recode q1_21_b (1/2=1) (3/5=0) (999=.), gen(safe)
		recode q1_21_c (1/2=1) (3/5=0) (999=.), gen(effective)
		* Covid at least 3 doses
		recode q1_17 (1/3=0) (4/5=1) (999=.), gen(covid3plus)
		
		* LCA Model 1  VCI, COVID3
		gsem (important safe effective covid3  <- ), logit lclass(C 2)
		estimates store twoclass
		
		gsem (important safe effective covid3 <- ), logit lclass(C 3) 
		estimates store threeclass  // won't converge
		
		gsem (important safe effective covid3  <- ), logit lclass(C 2)
		estat lcprob
		estat lcmean 
		