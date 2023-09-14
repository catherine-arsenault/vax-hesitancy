

* We estimate the probability of being in each class of hesitancy

		gsem (safe effective important <- ), logit lclass(C 2)

		estat lcmean

		estat lcprob // probabilities of being in each class 

		predict classpost*, classposteriorpr
		list in 1, abbrev(10)
		// For the first individual in our dataset, who responded with a particularistic answer to all four	questions, the probability of being in class 1, the less universalistic class, is almost 1.
		
		estat lcgof
		
* Comparing models that have different numbers of classes
	gsem (safe effective important <- ), logit lclass(C 2)
	estimates store twoclass
	
	gsem (safe effective important <- ), logit lclass(C 1)
	estimates store oneclass
	
	estat lcgof
	
	// if p-val <0.000 We reject the null hypothesis in this case. The one-class model does not fit well
	
	gsem (safe effective important <- ), logit lclass(C 3)
	estimates store threeclass
	
	estat lcgof
	// We will compare our three models using AIC and BIC. Smaller values of AIC and BIC are better
	
	estimates stats oneclass twoclass threeclass
	// The two-class model has both the smallest AIC and the smallest BIC
	
	
* LCA WITH COVARIATES (finite mixture models?) 

gsem (alcohol truant vandalism theft weapon <--_cons) 	 ///
	(C <-- age) , family(bernoulli ) link(logit)		 ///
	lclass (C 3)
	
	estat lcprob // to testimate the proportion of individuals in each class
	estat lcmean
	
	margins, predict(classpr class(1)) ///
			 predict(classpr class(2)) ///
			 predict(classpr class(3)) ///
			at(age=(13(1)18))
			
marginsplot, title("Predicted Latent Class Probabilities with 95% CI")
			legend(order(1 "Class 1" 2 "Class 2" 3 "Class 3") ///
			rows(1) position(12) ring(1)) ytitle
			
			
			
			