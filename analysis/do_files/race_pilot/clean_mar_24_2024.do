/* race frame vs neutral frame. hiring and belief */

/* To run this do fiile:
do $projdir/do_files/race_pilot/clean_mar_24_2024.do
 */

cap log close _all

log using $projdir/log_files/race_pilot/clean_mar_24_2024.smcl, replace

graph drop _all
set more off
set varabbrev off
/* set graphics off */
set scheme s1color
set seed 1984


import delimited $racedatadir/raw/pilot_mar_24_2024.csv, varnames(1) clear


//--------------------------------------------------------------------
// initial cleaning
//--------------------------------------------------------------------

//------------create session and subject ID -------------------
gen sessionid = 1
gen subjectid = _n 

//-------------------drop observations------------------
drop if mi(prolific_pid)

// drop obs who declined consent
drop if q4 == "No, I do not wish to participate in this study"
// drop likely duplicates
keep if q_relevantidduplicatescore < 75
// drop obs that are likely bots
drop if q_relevantidfraudscore >= 30
drop if q_recaptchascore <= 0.5
// drop subjects who failed one or more quiz questions
// quiz_failed = 1 if one or more answers are wrong
/* correct answers:
1: FALSE
2: $2
3: $0 */
// remove spaces in quiz answers
foreach var of varlist quiz1 - quiz3 {
    replace `var' = strtrim(`var')
}
gen quiz1correct = 0 
replace quiz1correct = 1 if quiz1 == "FALSE"

gen quiz2correct = 0 
replace quiz2correct = 1 if quiz2 == "$2"

gen quiz3correct = 0
replace quiz3correct = 1 if quiz3 == "$0"

gen quizscore = quiz1correct + quiz2correct + quiz3correct

drop if quiz_failed == 1
// keep if finished
keep if finished == "TRUE"



//--------------------------------------------------------------------
// rename the treatment variable
//--------------------------------------------------------------------
rename treat treat_race 
label var treat_race "race framing treatment"

//--------------------------------------------------------------------
// rename the hiring variables 
//--------------------------------------------------------------------
foreach var of varlist *hire {
    replace `var' = strlower(`var')
}

// notation: wmaf = white male asian female 
gen hire_white_wmaf = 1 if john_amy_hire == "john"
replace hire_white_wmaf = 0 if john_amy_hire == "amy"
label var hire_white_wmaf "hire white in white male-asian female pair"

/* rename john_amy_hire wmaf_hire */

//notation: wfbf = white female black female
gen hire_white_wfbf = 1 if mari_audre_hire == "mari"
replace hire_white_wfbf = 0 if mari_audre_hire == "audre"
label var hire_white_wfbf "hire white in white female-black female pair"

/* rename mari_audre_hire wfbf_hire */

// notation: wmbf = white male black female 
gen hire_white_wmbf = 1 if maya_dave_hire == "dave"
replace hire_white_wmbf = 0 if maya_dave_hire == "maya"
label var hire_white_wmbf "hire white in white male - black female pair"

/* rename maya_dave_hire wmbf_hire  */

// notation: ambm = asian male black male
gen hire_asian_ambm = 1 if kai_jordan_hire == "kai"
replace hire_asian_ambm = 0 if kai_jordan_hire == "jordan"
label var hire_asian_ambm "hire asian in asian male- black male pair"

// notation: afhm = asian female hispanic male
gen hire_asian_afhm = 1 if hana_juan_hire == "hana"
replace hire_asian_afhm = 0 if hana_juan_hire =="juan"
label var hire_asian_afhm "hire asian in asian female-hispanic male pair"

//--------------------------------------------------------------------
// rename the belief variables 
//--------------------------------------------------------------------
rename john_amy_belief_1 belief_white_wmaf
rename john_amy_belief_2 belief_asian_wmaf
label var belief_white_wfbf "belief for white in white male-asian female pair"
label var belief_asian_wmaf "belief for asian in white male-asian female pair"

rename mari_audre_belief_1 belief_white_wfbf 
rename mari_audre_belief_2 belief_black_wfbf

log close 
translate $projdir/log_files/race_pilot/clean_mar_24_2024.smcl ///
    $projdir/log_files/race_pilot/clean_mar_24_2024.log, replace 