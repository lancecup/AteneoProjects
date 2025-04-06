use "/Users/lance/Downloads/phi macro data v2.dta"

** gnp, Private Consumption, Fixed investments

*Finding stationary version
gen lngdpc=ln(gdpc)
gen lnconc=ln(conc)
gen lnfinvc=ln(finvc)
dfuller lngdpc
dfuller D.lngdpc
dfuller lnconc
dfuller D.lnconc
dfuller lnfinvc
dfuller D.lnfinvc

*Lag selection
varsoc D.lngdpc D.lnconc D.lnfinvc, maxlag(8)

*Estimation of VAR Model
var D.lngdpc D.lnconc D.lnfinvc, lags(1/3)

*Checking for stability condition
varstable, graph

*Checking for serial correlation
varlmar, mlag(4)

*Checking residuals for normality
varnorm

*Checking for joint significance of lags
varwle

*Granger causality test
vargranger

*Forecasting
fcast compute F_, step(20)
fcast graph F_D_lngdpc F_D_lnconc F_D_lnfinvc, observed lpattern(dash)

*Time series plot actual and forecast
tsline D.lngdpc F_D_lngdpc
tsline D.lnconc F_D_lnconc
tsline D.lnfinvc F_D_lnfinvc
