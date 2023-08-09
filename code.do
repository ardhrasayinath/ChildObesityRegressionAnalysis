use "/Users/ardhra/Downloads/nhis_00009.dta", clear
*Droping the unwanted variables
drop bmicat
drop educrec2_mom2
drop educrec2_pop2
drop bmicat_mom2
drop bmicat_pop2
drop mod10dmin_mom2
drop mod10dmin_pop2
drop mod10fno_mom2
drop mod10fno_pop2
drop mod10ftp_mom2
drop mod10ftp_pop2
drop dietdyr_mom2
drop dietdyr_pop2
drop wtprognow_mom2
drop wtprognow_pop2
drop pclookhelyr_mom2
drop pclookhelyr_pop2
drop hourswrk_pop2
drop hourswrk_mom2
drop mod10fno_mom
drop mod10fno_pop
drop mod10ftp
drop mod10fno
drop mod10dmin

*Select the sample
drop if (age<12 | age>=18)
drop if (cstatflg!=1)
drop if (incfam07on>=96)
drop if (racea>500)


*Generate new variables if moms value ==0 or . and replace it with pops
gen minperweekmom = 0*(mod10ftp_mom == 1 )+(mod10dmin_mom*mod10ftp_mom*7)*(mod10ftp_mom== 2) + (mod10dmin_mom*mod10ftp_mom)*(mod10ftp_mom == 3) + (mod10dmin_mom*mod10ftp_mom/4)*(mod10ftp_mom == 4)+(mod10dmin_mom*mod10ftp_mom/52)*(mod10ftp_mom == 5)

gen minperweekpop = 0*(mod10ftp_pop == 1 )+(mod10dmin_pop*mod10ftp_pop*7)*(mod10ftp_pop== 2) + (mod10dmin_pop*mod10ftp_pop)*(mod10ftp_pop== 3) + (mod10dmin_pop*mod10ftp_pop/4)*(mod10ftp_pop == 4)+(mod10dmin_pop*mod10ftp_pop/52)*(mod10ftp_pop == 5)

gen minperweek= minperweekmom  if (minperweekmom !=. )
replace minperweek = minperweekpop if (minperweek==. & minperweekpop !=. )
summarize minperweek
tab minperweek



* Grouping
gen racemy=1*(racea==100)+2*(racea==200)+3*(racea>200 & racea<400)+4*(racea>399 & racea<500)
replace racemy= . if (racemy!= 1 & racemy != 2 & racemy != 3 & racemy != 4)
label define lracemy  1 "White American"  2 "Black American"  3 "Alaskan"  4 "Asian"
label values racemy lracemy
tab racemy

gen edumom= 1*(educrec2_mom >=31 & educrec2_mom <=41)+2*(educrec2_mom ==42)+3* (educrec2_mom==51) +4*(educrec2_mom ==54)+5*(educrec2_mom == 60)
replace edumom= . if (edumom!= 1 & edumom != 2 & edumom != 3 & edumom != 4 & edumom != 5)
label define ledumom  1 "less than grade 12"  2 "High school"  3 "Some College"  4  "Bachelors" 5 "Masters"
label values edumom ledumom
tab edumom,nolabel

gen edupop=1*(educrec2_pop >=31 & educrec2_pop<=41)+2*(educrec2_pop ==42)+3* (educrec2_pop==51) +4*(educrec2_pop ==54)+5*(educrec2_pop == 60)
replace edupop= . if (edupop!= 1 & edupop != 2 & edupop != 3 & edupop != 4 & edupop != 5 )
label define ledupop  1 "less than grade 12"  2 "High school"  3 "Some College"  4  "Bachelors" 5 "Masters"
label values edupop ledupop
tab edupop


gen edu=edumom if (edumom !=. & edumom <9)
*replace edu = edupop if (edu==. & edupop !=0 & bmicat_pop  <9)
replace edu = edupop if (edu==. & edupop !=.& bmicat_pop  <9)
summarize edu
replace edu= . if (edu != 1 & edu != 2 & edu != 3 & edu != 4 & edu != 5 )
label define ledu 1 "less than grade 12"  2 "High school"  3 "Some College"  4  "Bachelors" 5 "Masters"
label values edu ledu
tab edu

gen income=1*(incfam07on>=10 & incfam07on<=12)+2*(incfam07on>=20 & incfam07on<=23)+3*(incfam07on==24)
replace income= . if (income!= 1 & income != 2 &income != 3 )
label define lincome 1 "less than 50,000"  2 "50,000 to 100,000"  3 "100,000 and above"
label values income lincome
summarize i.income
tab income



*bmi restrictions
*generating new variable on parents bmi
gen bmi=bmicat_mom if (bmicat_mom !=0 & bmicat_mom <9)
replace bmi = bmicat_pop if (bmi==. & bmicat_pop !=0 & bmicat_pop  <9)
tab bmi
*parentsex
*constructing a dummy variable to capture the different influence of father and mother on child bmi 
gen mom=1 if (bmi==bmicat_mom&bmicat_mom!=.)
replace mom=0 if (mom==.&bmi==bmicat_pop&bmicat_pop!=.)
tab mom

*Dietary restrictions/ever told by Dr or health professional to reduce fat
gen diet= dietdyr_mom if (dietdyr_mom !=0 & dietdyr_mom <7)
replace diet = dietdyr_pop if (diet==. & dietdyr_pop!=0 & dietdyr_pop <7 )
summarize diet 
tab diet
*Participation in weight loss program
gen weight= wtprognow_mom if (wtprognow_mom !=0 & wtprognow_mom <7)
replace weight= wtprognow_pop if (weight==. & wtprognow_pop!=0 & wtprognow_pop <7 )
summarize weight 
tab weight
*Has looked health information in internet
gen health= pclookhelyr_mom if (pclookhelyr_mom  !=0 & pclookhelyr_mom  <7)
replace health= pclookhelyr_pop  if (health==. & pclookhelyr_pop!=0 & pclookhelyr_pop <7 )
summarize health
tab health
*total working hours
gen hourswrkk=hourswrk_mom if (hourswrk_mom !=0 & hourswrk_mom<97)
replace hourswrkk= hourswrk_pop if (hourswrkk==. & hourswrk_pop!=0 & hourswrk_pop <97 )
tab hourswrkk


*CATEGORISE DEPENDENT VARIABLE
gen kidcat = 1*(bmikid < 1500 & bmikid > 0) + 2*(bmikid >= 1500 & bmikid <= 2100) + 3*(bmikid > 2100 & bmikid < 2420) + 4*(bmikid >= 2420 & bmikid < 9999) if (sex==1 & age == 12)
replace kidcat = 1*(bmikid < 1480 & bmikid > 0) + 2*(bmikid >= 1480 & bmikid <= 2180) + 3*(bmikid > 2180 & bmikid < 2520) + 4*(bmikid >= 2520 & bmikid < 9999) if (sex==2 & age == 12)
replace kidcat = 1*(bmikid < 1540 & bmikid > 0) + 2*(bmikid >= 1540 & bmikid <= 2180) + 3*(bmikid > 2180 & bmikid < 2520) + 4*(bmikid >= 2520 & bmikid < 9999) if (sex==1 & age == 13)
replace kidcat = 1*(bmikid < 1520 & bmikid > 0) + 2*(bmikid >= 1520 & bmikid <= 2260) + 3*(bmikid > 2260 & bmikid < 2620) + 4*(bmikid >= 2620 & bmikid < 9999) if (sex==2 & age == 13)
replace kidcat = 1*(bmikid < 1600 & bmikid > 0) + 2*(bmikid >= 1600 & bmikid <= 2260) + 3*(bmikid > 2260 & bmikid < 2620) + 4*(bmikid >= 2620 & bmikid < 9999) if (sex==1 & age == 14)
replace kidcat = 1*(bmikid < 1580 & bmikid > 0) + 2*(bmikid >= 1580 & bmikid <= 2340) + 3*(bmikid > 2340 & bmikid < 2720) + 4*(bmikid >= 2720 & bmikid < 9999) if (sex==2 & age == 14)
replace kidcat = 1*(bmikid < 1660 & bmikid > 0) + 2*(bmikid >= 1660 & bmikid <= 2340) + 3*(bmikid > 2340 & bmikid < 2680) + 4*(bmikid >= 2680 & bmikid < 9999) if (sex==1 & age == 15)
replace kidcat = 1*(bmikid < 1620 & bmikid > 0) + 2*(bmikid >= 1620 & bmikid <= 2400) + 3*(bmikid > 2400 & bmikid < 2800) + 4*(bmikid >= 2800 & bmikid < 9999) if (sex==2 & age == 15)
replace kidcat = 1*(bmikid < 1720 & bmikid > 0) + 2*(bmikid >= 1720 & bmikid <= 2420) + 3*(bmikid > 2420 & bmikid < 2760) + 4*(bmikid >= 2760 & bmikid < 9999) if (sex==1 & age == 16)
replace kidcat = 1*(bmikid < 1680 & bmikid > 0) + 2*(bmikid >= 1680 & bmikid <= 2460) + 3*(bmikid > 2460 & bmikid < 2880) + 4*(bmikid >= 2880 & bmikid < 9999) if (sex==2 & age == 16)
replace kidcat = 1*(bmikid < 1760 & bmikid > 0) + 2*(bmikid >= 1760 & bmikid <= 2500) + 3*(bmikid > 2500 & bmikid < 2820) + 4*(bmikid >= 2820 & bmikid < 9999) if (sex==1 & age == 17)
replace kidcat = 1*(bmikid < 1720 & bmikid > 0) + 2*(bmikid >= 1720 & bmikid <= 2520) + 3*(bmikid > 2520 & bmikid < 2960) + 4*(bmikid >= 2960 & bmikid < 9999) if (sex==2 & age == 17)
tab kidcat
drop if (kidcat==0)

summarize i.kidcat age i.sex  i.racemy i.hispyn i.income i.bmi i.edu i.diet i.weight i.health minperweek hourswrkk if (kidcat * age *sex* racemy * hispyn * income * bmi * edu*diet* weight *health* minperweek *hourswrkk!=.)
drop if (kidcat * age *sex* racemy * hispyn * income * bmi * edu*diet* weight *health* minperweek *hourswrkk==.)
*testing for nonlinearity of the variables minperweek and hourswrkk
twoway (scatter kidcat minperweek)
hist kidcat
hist minperweek
tabstat kidcat minperweek,stats(sk)

twoway (scatter kidcat hourswrkk)
hist kidcat
hist hourswrkk
tabstat kidcat hourswrkk,stats(sk)

*ordinal probit model
oprobit kidcat i.bmi age i.sex i.racemy i.hispyn i.edu i.hourswrkk i.income i.diet i.weight i.health minperweek
*testing joint significance of variables
testparm i.bmi
testparm i.edu i.income i.hourswrkk
testparm i.diet i.weight i.health i.minperweek

*capturing the different influence of father and mother on child bmi
oprobit kidcat i.bmi##i.mom

*computing marginal effects to predict output
margins,at (bmi=4 )
margins,at (income=1 )
margins,at (edu=5)
margins,at (hourswrkk)
margins,at (diet=1)
margins,at (weight=1)
margins,at (health=2)
margins,at (minperweek=10)


*by sex:summarize kidcat 
twoway (scatter kidcat minperweek)
oprobit kidcat i.bmi

margins bmi
marginsplot, xdimension(bmi)
marginsplot, xdimension(bmi) horizontal recast(scatter) graphregion(margin(medium))
*what age children are mostly obese
margins, at(age=(12(1)17))


