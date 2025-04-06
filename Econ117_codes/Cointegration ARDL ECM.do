use "/Users/Lance/Downloads/phi macro data v2.dta", clear

*Test lngpay and lngtax for cointegration

gen lngpay=ln(gpay)
gen lngtax=ln(gtax)

dfuller lngpay, lags(4)
dfuller d.lngpay, lags(3)

dfuller lngtax, lags(4)
dfuller d.lngtax, lags(3)

egranger lngpay lngtax, lags(1) regress
egranger lngpay lngtax, lags(1) 

regress lngpay lngtax


*Test lnpgdp and lnppi2000 for cointegration

gen lnpgdp=ln(pgdp)
gen lnppi2000=ln(ppi2000)

dfuller lnpgdp, lags(4)
dfuller d.lnpgdp, lags(3)

dfuller lnppi2000, lags(4)
dfuller d.lnppi2000, lags(3)

egranger lnpgdp lnppi2000, lags(1) 

regress d.lnpgdp d.lnppi2000

*Test lnfinvc and lngdpc for cointegration

gen lnfinvc=ln(finvc)
gen lngdpc=ln(gdpc)

dfuller lnfinvc, lags(4)
dfuller d.lnfinvc, lags(3)

dfuller lngdpc, lags(4)
dfuller d.lngdpc, lags(3)

egranger lnfinvc lngdpc, lags(1) 

regress lnfinvc lngdpc

*Test lnmtc_nia and lngnpc for cointegration

gen lnmtc=ln(mtc)
gen lngnpc=ln(gnpc)

dfuller lnmtc, lags(4)
dfuller d.lnmtc, lags(3)

dfuller lngnpc, lags(4)
dfuller d.lngnpc, lags(3)

egranger lnmtc lngnpc, lags(1) 

regress lnmtc lngnpc


*ARDL

regress d.lnpgdp l2.d.lnpgdp l3.d.lnpgdp  l4.d.lnpgdp  l5.d.lnpgdp
estat ic

regress d.lnpgdp l.d.lnpgdp l2.d.lnpgdp l3.d.lnpgdp  l4.d.lnpgdp  l5.d.lnpgdp
estat ic

regress d.lnpgdp l.d.lnpgdp l2.d.lnpgdp l3.d.lnpgdp  l4.d.lnpgdp  l5.d.lnpgdp d.lnppi2000 l.d.lnppi2000 l2.d.lnppi2000 l3.d.lnppi2000 l4.d.lnppi2000  
estat ic

*ECM

regress lngpay lngtax
predict uhat_lngpay_lngtax, resid
regress d.lngpay d.lngtax l.uhat_lngpay_lngtax


regress lnfinvc lngdpc
predict uhat_lnfinvc_lngdpc, resid
regress d.lnfinvc d.lngdpc l.uhat_lnfinvc_lngdpc

