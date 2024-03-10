/* clean version to of the design, only one round, between subject
Pilot 7 */

/* To run this do fiile:
do $projdir/do_files/pilot/clean_pilot7.do
 */

cap log close _all

log using $projdir/log_files/pilot/clean_pilot7.smcl, replace

graph drop _all
set more off
set varabbrev off
/* set graphics off */
set scheme s1color
set seed 1984

import delimited $datadir/raw/pilot_7_import_ready.csv, varnames(1) clear

/* create vars for true red dots */
gen a = 63 if matrix== "63_58" | matrix == "63_41"
replace a = 58 if matrix == "58_63"
gen b = 58 if matrix == "63_58"
replace b = 41 if matrix == "63_41"
replace b = 63 if matrix == "58_63"

gen pairid = 1 if matrix == "63_58"
replace pairid = 2 if matrix == "63_41"
replace pairid = 3 if matrix == "58_63"

gen trueahigher = 1
replace trueahigher = 0 if pairid == 3

gen setid = 1
label var setid "matrix set"

// dummy for investing in portfolio A in treatment or thinking A higher in control
gen gahigher = .
replace gahigher = 1 if (invest == "Portfolio A" & treat == 1) | (q16 == "Portfolio A" & treat==0)
replace gahigher = 0 if (invest== "Portfolio B" & treat == 1) | (q16 == "Portfolio B" & treat==0)

gen investa = 1 if invest == "Portfolio A"
replace investa = 0 if invest == "Portfolio B"

// guess if matrix is 63 and 58
gen guessa = q21_1 if matrix == "63_58" | matrix == "58_63"
replace guessa  = q28_1 if matrix == "63_41"

gen guessb = q21_2 if matrix == "63_58" | matrix == "58_63"
replace guessb = q28_2 if matrix == "63_41"

// delete survey preview and tests 
drop if strpos(startdate, "3/2/24")!= 0

gen dcguess = 0
replace dcguess = 1 if trueahigher == gahigher 

label define treatlab 0 "Control" 1 "Treat"
label values treat treatlab


// calculate bonus
gen success = 0
replace success = 1 if investa == trueahigher





graph bar guessa guessb if pairid == 3,  over(gahigher) over(treat)
graph bar guessa guessb if pairid == 2, over(gahigher)


log close 
translate using $projdir/log_files/pilot/clean_pilot7.smcl ///
    using $projdir/log_files/pilot/clean_pilot7.log, replace 