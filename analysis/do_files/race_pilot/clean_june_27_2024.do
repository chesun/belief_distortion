/* race frame vs neutral frame. hiring and belief */

/* To run this do fiile:
do $projdir/do_files/race_pilot/clean_june_27_2024.do
 */

cap log close _all

log using $projdir/log_files/race_pilot/clean_june_27_2024.smcl, replace

graph drop _all
set more off
set varabbrev off
/* set graphics off */
set scheme s1color
set seed 1984


import delimited $racedatadir/raw/pilot_june_27_2024.csv, varnames(1) clear


//--------------------------------------------------------------------
// initial cleaning
//--------------------------------------------------------------------

//------------create session and subject ID -------------------
gen sessionid = 2
gen subjectid = _n 

//-------------------drop observations------------------
drop if mi(prolific_pid)

// drop obs who declined consent
drop if q4 == 0
// drop likely duplicates
keep if q_relevantidduplicatescore < 75
// drop obs that are likely bots
drop if q_relevantidfraudscore >= 30
drop if q_recaptchascore <= 0.5
// drop obs who failed quiz
drop if quiz_failed == 1
// keep if finished
keep if finished == 1
// screen out obs who did not go through the prior stage
drop if mi(asian_prior_1)

//--------------------------------------------------------------------
// combine belief variables between treatments
//--------------------------------------------------------------------
// v137 v138 etc are in the hiring + belief treatment 
forvalues loop = 1/8 {
    replace lm`loop'_belief_time_pagesubmit = v`= 135 + (`loop' - 1)*11' if belief_only == 0
    replace lm`loop'_belief_1 = v`=137 + (`loop' - 1)*11' if belief_only == 0
    replace lm`loop'_belief_2 = v`=138 + (`loop' - 1)*11' if belief_only == 0

    rename lm`loop'_belief_time_pagesubmit lm`loop'_belief_time

    rename lm`loop'_hire_time_pagesubmit lm`loop'_hire_time

    // drop first click, last click, and click count, and vars in the hiring treatment
    drop lm`loop'*click lm`loop'*clickcount
    forvalues num = 133/138 {
         drop v`=`num' + (`loop' - 1)*11'
    }
}

rename lm1_* wmbm_*
rename lm2_* wfbf_*
rename lm3_* wmhm_*
rename lm4_* wmam_*
rename lm5_* ambm_*
rename lm6_* amhm_*
rename lm7_* afbm_*
rename lm8_* afhm_*




log close 
translate $projdir/log_files/race_pilot/clean_june_27_2024.smcl ///
    $projdir/log_files/race_pilot/clean_june_27_2024.log, replace 