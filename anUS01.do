
* LCA Model 1  VCI, COVID3, FLU
	use "$user/$analysis/Data for analysis/USvaxhesitancy.dta", clear 
		gsem (important safe effective covid3 flu <- ), logit lclass(C 2)
		estimates store twoclass
		
		gsem (important safe effective covid3plus flu <- ), logit lclass(C 3)
		estimates store threeclass
		
		gsem (important safe effective covid3 flu <- ), logit lclass(C 4)
		estimates store fourclass // wont converge

		estimates stats twoclass threeclass 

		gsem (important safe effective covid3plus flu <- ), logit lclass(C 3)
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
				   i.political ib(3).stategroupus has_GP i.visits, baseoutcome(3)
						 
********************************************************************************				
* LCA Model 2  VCI, COVID3, FLU, CHILD COVID2
	use "$user/$analysis/Data for analysis/USvaxhesitancy.dta", clear 
	keep if childcovid2!=. 
	
	gsem (important safe effective covid3 flu childcovid2 <- ), logit lclass(C 2)
	estimates store twoclass
	gsem (important safe effective covid3 flu childcovid2 <- ), logit lclass(C 3)
	estimates store threeclass
	gsem (important safe effective covid3 flu childcovid2 <- ), logit lclass(C 4)
	estimates store fourclass
	gsem (important safe effective covid3 flu childcovid2 <- ), logit lclass(C 5)
	estimates store fiveclass // won't converge 
	
	estimates stats twoclass threeclass fourclass 
	
	gsem (important safe effective covid3 flu childcovid2 <- ), logit lclass(C 3)
	estat lcprob 
	estat lcmean 

********************************************************************************
* LCA Model 3  VCI, COVID3, FLU, CHILD COVID2, CHILD MMR
	use "$user/$analysis/Data for analysis/USvaxhesitancy.dta", clear 
	keep if mmr!=. 
	
	gsem (important safe effective covid3 flu childcovid2 mmr <- ), logit lclass(C 2)
	estimates store twoclass
	gsem (important safe effective covid3 flu childcovid2 mmr <- ), logit lclass(C 3)
	estimates store threeclass
	gsem (important safe effective covid3 flu childcovid2 mmr <- ), logit lclass(C 4)
	estimates store fourclass // won't converge 
	gsem (important safe effective covid3 flu childcovid2 mmr <- ), logit lclass(C 5)
	estimates store fiveclass // won't converge 
	gsem (important safe effective covid3 flu childcovid2 mmr <- ), logit lclass(C 6)
	estimates store sixclass // won't converge 
	
	estimates stats twoclass threeclass 
	gsem (important safe effective covid3 flu childcovid2 mmr <- ), logit lclass(C 3)
	estat lcprob 
	estat lcmean 
********************************************************************************
* LCA Model 4  VCI, COVID3, FLU, CHILD COVID2, CHILD HPV
use "$user/$analysis/Data for analysis/USvaxhesitancy.dta", clear 
	keep if hpv!=.
	
	gsem (important safe effective covid3 flu childcovid2 hpv <- ), logit lclass(C 2)
	estimates store twoclass
	gsem (important safe effective covid3 flu childcovid2 hpv <- ), logit lclass(C 3)
	estimates store threeclass
	gsem (important safe effective covid3 flu childcovid2 hpv <- ), logit lclass(C 4)
	estimates store fourclass // won't converge 
	gsem (important safe effective covid3 flu childcovid2 hpv <- ), logit lclass(C 5)
	estimates store fiveclass // won't converge 
	gsem (important safe effective covid3 flu childcovid2 hpv <- ), logit lclass(C 6)
	estimates store sixclass // won't converge 
	
	estimates stats twoclass threeclass 
	gsem (important safe effective covid3 flu childcovid2 mmr <- ), logit lclass(C 3)
	estat lcprob 
	estat lcmean 
	
* LCA Four variables (for country comparison)
	use "$user/$analysis/Data for analysis/USvaxhesitancy.dta", clear 
		gsem (important safe effective covid3  <- ), logit lclass(C 2)
		estimates store twoclass
		
		gsem (important safe effective covid3plus <- ), logit lclass(C 3)
		estimates store threeclass // wont converge
		
		gsem (important safe effective covid3 <- ), logit lclass(C 4)
		estimates store fourclass // wont converge


		gsem (important safe effective covid3plus <- ), logit lclass(C 2)
		estat lcprob
		estat lcmean 	
	
/* LCA with predictors
			gsem (important safe effective trust_science trust_cdc <- _cons) 	 ///
			(C <- income) , family(bernoulli ) link(logit)		 ///
			lclass (C 4)
			
			estat lcprob 

			estat lcmean 

			margins, predict(classpr class(1)) ///
					predict(classpr class(2)) ///
					predict(classpr class(3)) ///
					predict(classpr class(4)) ///
					at(income=(1(1)5))
		  
		  marginsplot, title("Predicted Latent Class Probabilities with 95% CI") ///
						legend(order(1 "Trust neither" 2 "Vaccines+ Instit-" 3 ///
							  "Trust both" 4 "Vaccines- Instit+") ///
						rows(1) position(12) ring(1)) 
