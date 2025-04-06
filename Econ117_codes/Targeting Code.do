clear

use "/Users/lance/Downloads/Targeting files/FIES 2006 Exercise dichotomous.dta"

keep if regn==41

*Generating per capita income
gen pcinc=toinc/fsize

*As is typically done, we work with the LN of income rather than the untransformed level of income
gen lnpcinc=ln(pcinc)

*Assume poverty line is equal to 15,000
*Identify poor
gen poor_actual=1 if pcinc<15000
replace poor_actual=0 if pcinc>=15000

save "/Users/lance/Downloads/Targeting files/FIES 2006 Exercise dichotomous v2.dta", replace

*Divide sample into estimation sample and testing sample
set seed 12345
sample 50

gen samplegrp=1
keep regn prv shsn strata hcn samplegrp

merge 1:1 regn prv shsn strata hcn using "/Users/lance/Downloads/Targeting files/FIES 2006 Exercise dichotomous v2.dta", generate(_merge2)
*samplegrp=1 is the estimation sample; we will assign testing sample samplegrp=2
recode samplegrp (.=2)


*Income function 1: per capita income as function of family size and ownership of durable goods
*Estimated only using estimation sample
reg lnpcinc fsize radioqty tvqty vtrqty sterqty refqty washqty aircnqty carqty phoneqty ovenqty motorqty if samplegrp==1 
*Generate predicted values of lnpchinc_hat for all (estimation and testing sample)
predict lnpcinc_hat_1, xb
*Compute predicted per capita income
gen pcinc_hat_1=exp(lnpcinc_hat_1)
*Identify predicted poor
gen poor_pr_1=1 if pcinc_hat_1<15000
recode poor_pr_1 (.=0)
*Measuring accuracy of model on estimation sample
tabulate poor_actual poor_pr_1 if samplegrp==1
*Measuring accuracy of model on testing sample
tabulate poor_actual poor_pr_1 if samplegrp==2

**Income function 2: per capita income as function of family size, ownership of durable goods, region of residence
reg lnpcinc fsize radioqty tvqty vtrqty sterqty refqty washqty aircnqty carqty phoneqty ovenqty motorqty i.regn if sample==1
*Generate predicted values of lnpchinc_hat for all (estimation and testing sample)
predict lnpcinc_hat_2
*Compute predicted per capita income
gen pcinc_hat_2=exp(lnpcinc_hat_2)
*Identify predicted poor
gen poor_pr_2=1 if pcinc_hat_2<15000
recode poor_pr_2 (.=0)
*Measuring accuracy of model on estimation sample
tabulate poor_actual poor_pr_2 if samplegrp==1
*Measuring accuracy of model on testing sample
tabulate poor_actual poor_pr_2 if samplegrp==2

**Income function 3: per capita income as function of family size, ownership of durable goods, region of residence, electricity expenditure
reg lnpcinc fsize radioqty tvqty vtrqty sterqty refqty washqty aircnqty carqty phoneqty ovenqty motorqty i.regn elec_exp if sample==1 
*Generate predicted values of lnpchinc_hat for all (estimation and testing sample)
predict lnpcinc_hat_3 
*Compute predicted per capita income
gen pcinc_hat_3=exp(lnpcinc_hat_3)
*Identify predicted poor
gen poor_pr_3=1 if pcinc_hat_3<15000
recode poor_pr_3 (.=0)
*Measuring accuracy of model on estimation sample
tabulate poor_actual poor_pr_3 if samplegrp==1
*Measuring accuracy of model on testing sample
tabulate poor_actual poor_pr_3 if samplegrp==2 
save "/Users/lance/Downloads/Targeting files/FIES 2006 Exercise dichotomous v3.dta", replace

***Adding variables from Labor Force Survey
clear
use "/Users/lance/Downloads/Targeting files/LFS jan 2007.dta"
keep if regn==41
gen collgrad=1 if grade>=60 & grade<99
gen minor=1 if age<15
gen hsunderadlt=1 if grade<=3 & age>=25
gen one=1
bysort regn strata shsn hcn: egen collgrad_n=sum(collgrad)
browse regn strata shsn hcn grade collgrad collgrad_n
bysort regn strata shsn hcn: egen minor_n=sum(minor)
bysort regn strata shsn hcn: egen hsunderadlt_n=sum(hsunderadlt)
bysort regn strata shsn hcn: egen hhsize_n=sum(one)
browse regn strata shsn hcn grade collgrad collgrad_n minor_n
gen prop_hsunder=hsunderadlt_n/hhsize
keep if rel==1
keep regn prv shsn strata hcn collgrad_n minor_n hsunderadlt_n hhsize_n prop_hsunder

merge 1:1 regn prv shsn strata hcn using "/Users/lance/Downloads/Targeting files/FIES 2006 Exercise dichotomous v3.dta", generate(_merge3)

**Income function 4: per capita income as function of family size, ownership of durable goods, region of residence, electricity expenditure, human capital characteristics 
reg lnpcinc c.fsize c.radioqty c.tvqty c.vtrqty c.sterqty c.refqty c.washqty c.aircnqty c.carqty c.phoneqty c.ovenqty /*
*/ c.motorqty i.regn c.elec_exp c.collgrad_n c.minor_n c.hsunderadlt_n c.prop_hsunder if sample==1

*Generate predicted values of lnpchinc_hat for all (estimation and testing sample)
predict lnpcinc_hat_41
*Compute predicted per capita income
gen pcinc_hat_41=exp(lnpcinc_hat_41)
*Identify predicted poor
gen poor_pr_41=1 if pcinc_hat_41<15000
recode poor_pr_41 (.=0)
recode samplegrp (.=2)
*Measuring accuracy of model on estimation sample
tabulate poor_actual poor_pr_41 if samplegrp==1

*Measuring accuracy of model on testing sample
tabulate poor_actual poor_pr_41 if samplegrp==2
