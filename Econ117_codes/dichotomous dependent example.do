*use LFS Jan 2001\LFS Jan 2001.dta clear

*lf participation as a function of education, age, sex, hh size

gen education=grade
replace education=6 if grade>=60 & grade<=78
replace education=. if grade==99

*generating education dummy variablees

gen bel_hsgrad1=1 if education<4
gen hsgrad1=1 if education==4
gen collunder1=1 if education==5
gen collgrad1=1 if education==6
recode bel_hsgrad hsgrad1 collunder1 collgrad1 (.=0)

*generating marital status dummy variables

gen married=1 if mstat==2
replace married=0 if mstat==1|mstat==3|mstat==4|mstat==5
gen mstat_oth=1 if mstat==3|mstat==4|mstat==5
replace mstat_oth=0 if mstat==1|mstat==2

*generating variable for dummy for male

gen male=1 if sex==1
replace male=0 if sex==2

gen agesq=age^2

*generating variable number of household members 

gen one=1
bysort prv hcn: egen hhsize=sum(one)

*generating dependent variable labor force particiation

gen lf=1 if (empst1==1|empst1==2) & age>=15 & conwr~=1 & conwr~=2
replace lf=0 if empst1==3 & age>=15 & conwr~=1 & conwr~=2

*LINEAR PROBABILITY MODEL
reg lf  male age agesq married mstat_oth hsgrad1 collunder1 collgrad1 hhsize

predict lf_pred if age>=15 & conwr==3
browse conwr male age agesq married mstat_oth hsgrad1 collunder1 collgrad1 hhsize lf* /*
*/ if age>=15 & conwr==3

*Problem: if probability, why values greater than 1 and less than 0

*Tagpi solution
gen lf_pred2=lf_pred
replace lf_pred2=0.99999 if lf_pred>=1
replace lf_pred2=0.00001 if lf_pred<=0


*heteroskedasticity
predict e_resid, resid
scatter e_resid lf_pred

*USING PROBIT MODEL
probit lf  male age agesq married mstat_oth hsgrad1 collunder1 collgrad1 hhsize
*Check out what the two commands below do
estat classification, cutoff(0.5)
lsens

probit lf  i.male c.age c.agesq i.married i.mstat_oth i.hsgrad1 i.collunder1 i.collgrad1 c.hhsize
margins, dydx(*)

*USING LOGIT MODEL

logit lf  male age agesq married mstat_oth hsgrad1 collunder1 collgrad1 hhsize
estat classification
lsens

logit lf  i.male c.age c.agesq i.married i.mstat_oth i.hsgrad1 i.collunder1 i.collgrad1 c.hhsize
margins, dydx(*)

