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

*rename variables
egen sports = rowtotal(t1301* t130301 t130401)
egen gamesComputer = rowtotal(t120307 t120308)
egen socializing = rowtotal(t1201* t1202* t120501 t120502)
egen tv = rowtotal(t120303 t120304)
egen readingRelaxing = rowtotal(t120301 t120312)
egen total_leisureSports = rowtotal(t12* t13*)
egen total = rowtotal(sports gamesComputer socializing tv readingRelaxing)
gen other = total_leisureSports - total

*Get means
egen mean_sports = mean(sports/60), by(tesex)
egen mean_gamesComputer = mean(gamesComputer/60), by(tesex)
egen mean_socializing = mean(socializing/60), by(tesex)
egen mean_tv = mean(tv/60), by(tesex)
egen mean_readingRelaxing = mean(readingRelaxing/60), by(tesex)
egen mean_total_leisureSports = mean(total_leisureSports/60), by(tesex)
egen mean_other = mean(other/60), by(tesex)

label var mean_sports "Sports" 
label var mean_gamesComputer "Games/Computer"
label var mean_socializing "Socializing"
label var mean_tv "TV"
label var mean_readingRelaxing "Reading/Relax"
label var mean_total_leisureSports "Leisure/Sports"
label var mean_other "Other"

graph bar mean_tv mean_readingRelaxing mean_sports mean_socializing mean_gamesComputer mean_other, over(tesex) scheme(meta) stack

by tesex, sort: summarize mean_total_leisureSports mean_tv mean_readingRelaxing mean_sports mean_socializing mean_gamesComputer mean_other





