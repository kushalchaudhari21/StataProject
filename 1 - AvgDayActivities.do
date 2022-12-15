clear
use "E:\Users\kc3655\Documents\project\avgHoursSpentOnDay.dta"

*Keep if the respondendent is enrolled in school/college/university
keep if teschenr == 1
* Is it highschool, college or university?
keep if teschlvl == 1
* Age from 15 to 19
keep if 15>=teage & teage<=19
*september to may drop the rest
drop if tumonth == 6
drop if tumonth == 7
drop if tumonth == 8
*2003-2007
drop if tuyear>=2008
* keeping students in 7th, 8th, 9th, 10th and 11th and 12th grade
drop if peeduca<=33
drop if peeduca>=39
* keep fulltime students only
keep if teschft == 1
* drop non work days
drop if trholiday == 1
drop if tudiaryday == 1
drop if tudiaryday == 7

*maybe i can gen a var sleeping and add all times up
*rename variables
gen sleeping = t010101 
gen grooming = t010201 
*Add all variable containing eating and drinking into one variable
egen eatDrink = rowtotal(t11*)
egen education = rowtotal(t06*)
egen leisureSports = rowtotal(t12* t13* t160101 t160102)
egen travel = rowtotal(t18*)
egen working = rowtotal(t05* t03*)
egen total = rowtotal(sleeping grooming eatDrink education leisureSports travel working)
gen other = 1440 - total

*get average minutes spent on activity
egen mean_sleeping = mean(sleeping/60)
egen mean_grooming = mean(grooming/60)
egen mean_eatDrink = mean(eatDrink/60)
egen mean_education = mean(education/60)
egen mean_leisureSports = mean(leisureSports/60)
egen mean_travel = mean(travel/60)
egen mean_working = mean(working/60)
egen mean_other = mean(other/60)

*Label variables
label var mean_working "Working"
label var mean_eatDrink "Eating/Drinking"
label var mean_grooming "Grooming"
label var mean_travel "Traveling"
label var mean_leisureSports "Leisure/Sports"
label var mean_education "Education"
label var mean_sleeping "Sleeping"
label var mean_other "Other"

*piechart
graph pie mean_working mean_eatDrink mean_grooming mean_travel mean_leisureSports mean_education mean_sleeping mean_other, scheme(economist)

summarize mean_working mean_eatDrink mean_grooming mean_travel mean_leisureSports mean_education mean_sleeping mean_other







