/* clean data from pilot 4 on prolific, 
completed Feb 13, 2024 */

/* To run this do fiile:
do $projdir/do_files/pilot/clean_pilot4.do
 */

cap log close _all

log using $projdir/log_files/pilot/clean_pilot4.smcl, replace

graph drop _all
set more off
set varabbrev off
set graphics off
set scheme s1color
set seed 1984

import delimited $datadir/raw/pilot_4_import_ready.csv, varnames(1) clear

//-----------------------------------------------------
// initial cleaning
//-----------------------------------------------------

//-----------drop observations-------------
// drop obs missing prolific id
drop if prolific_pid == ""
// drop obs who declined consent
drop if q4 == "No, I do not wish to participate in this study"
// drop likely duplicates
drop if q_relevantidduplicate == "TRUE" | q_relevantidduplicatescore >= 75
// drop obs that are likely bots
drop if q_relevantidfraudscore >= 30
drop if q_recaptchascore <= 0.5
// drop if failed quiz
keep if quiz_failed==0
// keep if finished
keep if finished == "TRUE"

//----------- drop variables --------------

// drop all timing data
drop *click *pagesubmit *clickcount
// drop all questions except demographics and embedded data
drop q_relevantidlaststartdate - v1410
// drop practice rounds embedded data
drop current* practice* chosen*

// drop other survey admin variables
drop startdate - progress finished userlanguage - q_relevantidfraudscore distributionchannel

// pilot4 already has a built in embedded data field for quiz_failed, calculate total errors
gen quiz_errors_total = 0
forvalues quiznum = 1/9 {
    replace quiz_errors_total = quiz_errors_total + errors_quiz_q`quiznum'
}

// drop round 11 and 12, only 10 rounds in pilot4
drop *loop11 *loop12 *round11 *round12

// reshape into long format for analysis
reshape long treat_loop task_id_loop ///
    guess_1_a_round guess_1_b_round ///
    actual_red_a_round actual_red_b_round ///
    guess_2_a_round guess_2_b_round ///
    invest_round success_round, i(responseid) j(round)

rename guess_1_a_round guess_1_a 
rename guess_1_b_round guess_1_b
rename actual_red_a_round actual_red_a
rename actual_red_b_round actual_red_b
rename guess_2_a_round guess_2_a 
rename guess_2_b_round guess_2_b
rename invest_round invest
rename success_round success 

rename treatment treat_block 

gen session = "pilot4"

//------ demographics and embedded data are left here-----------

// keep only choice and belief data, and experiment setup parameters
/* drop how_guess - belief_first_or_second  */
keep responseid - recordeddate invest_score - session



log close 
translate $projdir/log_files/pilot/clean_pilot4.smcl ///
    $projdir/log_files/pilot/clean_pilot4.log, replace 