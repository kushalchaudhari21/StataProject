clear
use "E:\Users\kc3655\Documents\project\avgHoursSpentOnDay.dta"

* If the respondendent is enrolled in school/college/university
keep if teschenr == 1
* Is it highschool, college or university?
keep if teschlvl == 1
* Age from 15 to 19
keep if teage>=15 & teage<=19
*september to may drop the rest
drop if tumonth == 6
drop if tumonth == 7
drop if tumonth == 8
*2003-2007
drop if tuyear>=2008
* keeping students in 7th, 8th, 9th, 10th and 11th grade
drop if peeduca<=33
drop if peeduca>=39
* keep fulltime students only
keep if teschft == 1

egen other = rowtotal(t01* t02* t03* t04* t05* t06* t07* t08* t09* t10* t11* t1201* t1202* t120301 t120302 t120305 t120306 t120307 t120308 t120309 t120310 t120311 t120312 t120313 t120399 t13* t14* t15* t16* t18*)
egen sleeping = rowtotal(t0101*)
egen hw = rowtotal(t0603*)
egen sports = rowtotal(t1301*)
egen tv = rowtotal(t120303 t120304)

by tesex, sort: regress other tv if other>0 & tv>0
by tesex, sort: regress sleeping tv if sleeping>0 & tv>0
by tesex, sort: regress hw tv if hw>0 & tv>0
by tesex, sort: regress sports tv if sports>0 & tv>0


graph twoway (lfit other tv) (scatter other tv) if other>0 & tv>0, name(otherTV, replace)
graph twoway (lfit sleeping tv) (scatter sleeping tv) if sleeping>0 & tv>0, name(sleepingTV, replace)
graph twoway (lfit hw tv) (scatter hw tv) if hw>0 & tv>0, name(hwTV, replace)
graph twoway (lfit sports tv) (scatter sports tv) if sports>0 & tv>0, name(sportsTV, replace)


 