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

*workday = weekday == 1 weekend = workday ==0
gen weekday = 0
replace weekday = 1 if tudiaryday>1 & tudiaryday<7

egen work = rowtotal(t0501* t0503*)
egen hw = rowtotal(t060301)
egen tv = rowtotal(t120303 t120304)

*make dummy variables to categorise
gen weekday_work = 0
replace weekday_work = work if weekday == 1 
gen weekend_work = 0
replace weekend_work = work if weekday == 0
gen weekday_hw = 0
replace weekday_hw = hw if weekday == 1
gen weekend_hw = 0
replace weekend_hw = hw if weekday == 0
gen weekday_tv = 0
replace weekday_tv = tv if weekday == 1
gen weekend_tv = 0
replace weekend_tv = tv if weekday == 0

*find average time spent on activity
egen mean_weekday_work = mean(weekday_work/60) if weekday_work > 0
egen mean_weekend_work = mean(weekend_work/60) if weekend_work > 0
egen mean_weekday_hw = mean(weekday_hw/60) if weekday_hw > 0
egen mean_weekend_hw = mean(weekend_hw/60) if weekend_hw > 0
egen mean_weekday_tv = mean(weekday_tv/60) if weekday_tv > 0
egen mean_weekend_tv = mean(weekend_tv/60) if weekend_tv > 0

*find percentage of highschool students doing that activity
egen obs_wdwk = mean(100*(weekday_work>0)) if weekday ==1
egen obs_wedwk = mean(100*(weekend_work>0)) if weekday ==0
egen obs_wdhw = mean(100*(weekday_hw>0)) if weekday ==1
egen obs_wedhw = mean(100*(weekend_hw>0)) if weekday ==0
egen obs_wdtv = mean(100*(weekday_tv>0)) if weekday ==1
egen obs_wedtv = mean(100*(weekend_tv>0)) if weekday ==0

*collapse to work on new variables 
collapse mean_weekday_work mean_weekend_work mean_weekday_hw mean_weekend_hw mean_weekday_tv mean_weekend_tv obs_wdwk obs_wedwk obs_wdhw obs_wedhw obs_wdtv obs_wedtv 

*stack all the repeated observations to get a single value
stack obs_wdwk mean_weekday_work obs_wedwk mean_weekend_work obs_wdhw mean_weekday_hw obs_wedhw mean_weekend_hw obs_wdtv mean_weekday_tv obs_wedtv mean_weekend_tv, into(xaxis yaxis) clear

label variable yaxis "Average Hours Spent on Activity"
label variable xaxis "Percentage Of High School Students"

*create a variable to identity values as per categories 
g activity_code = word("Work,Weekday Work,Weekend HW,Weekday HW,Weekend TV,Weekday TV,Weekend", _stack)

graph twoway scatter yaxis xaxis, mlabel(activity_code) xsc(r(0 100)) ysc(r(0 6)) title("TIME SPENT ON ACTIVITIES OVER WEEKDAY VS ""WEEKEND BY HIGH SCHOOL STUDENTS")

list yaxis xaxis activity_code