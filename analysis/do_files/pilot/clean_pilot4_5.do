/* clean data from pilot 4 and 5 on prolific*/

/* To run this do fiile:
do $projdir/do_files/pilot/clean_pilot4_5.do
 */

cap log close _all

log using $projdir/log_files/pilot/clean_pilot4_5.smcl, replace

graph drop _all
set more off
set varabbrev off
set graphics off
set scheme s1color
set seed 1984

foreach pilotnum in 4 5 {
    import delimited $datadir/raw/pilot_`pilotnum'_import_ready.csv, varnames(1) clear

    //-----------------------------------------------------
    // initial cleaning
    //-----------------------------------------------------

    //-----------drop observations-------------
    // drop obs missing prolific id
    drop if prolific_pid == ""
    // drop obs who declined consent
    drop if q4 == "No, I do not wish to participate in this study"
    // drop likely duplicates
    keep if q_relevantidduplicatescore < 75
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
    drop q_relevantidlaststartdate - which_not_understand
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

    // calculate game winner bonuses
    gsort -invest_score
    gen earned_game_bonus = 0
    sum win_bonus
    replace earned_game_bonus = r(max) if _n <= 3
    gen earned_bonus_all = earned_game_bonus + earned_belief_bonus + earned_invest_bonus
    // export investment game score to csv
    preserve 
    keep responseid prolific_pid invest_score earned_bonus_all earned_game_bonus earned_belief_bonus earned_invest_bonus 
    export delimited using $datadir/clean/pilot`pilotnum'_bonus.csv, replace 
    restore

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

    gen sessionid = `pilotnum'



    //------ demographics and embedded data are left here-----------

    /* in this data, no one wrote in gender */
    drop gender_6_text

    // keep only choice and belief data demographics, and experiment setup parameters
    keep responseid - recordeddate ///
        rses* list_exp* race - gender ///
        num_rounds invest_score treat* task_id* guess* actual* quiz* invest success sessionid

    drop quiz_failed
    // get actual red numbers from merging the matrix set records, discard the embedded data.
    drop actual_red*
    

    order responseid round guess* treat* task* invest success sessionid

    save $datadir/clean/pilot_`pilotnum'_init_clean.dta, replace
}



// append pilot4 and pilot5 data
use $datadir/clean/pilot_4_init_clean.dta, clear 
append using $datadir/clean/pilot_5_init_clean.dta

/* // create aligned version of the guess 2 variable: so that A and B portfolios are the same between treatments
// in the survey they are swapped between treatments
foreach letter in a b {
    gen guess_2_`letter'_align = guess_2_`letter' if treat_loop == "baseline"
    gen guess_1_`letter'_align = guess_1_`letter' if treat_loop == "baseline"

    gen actual_red_`letter'_align = actual_red_`letter' if treat_loop == "baseline"
}

replace guess_2_a_align = guess_2_b if treat_loop == "control"
replace guess_2_b_align = guess_2_a if treat_loop == "control"

replace guess_1_a_align = guess_1_b if treat_loop == "control"
replace guess_1_b_align = guess_1_a if treat_loop == "control"

replace actual_red_a_align = actual_red_b if treat_loop == "control"
replace actual_red_b_align = actual_red_a if treat_loop == "control"

// aligned investment (swap investment between A and B for control)


// create numeric dummies for investment and treatment variables
gen invest_a = 0 if invest == "B"
replace invest_a = 1 if invest == "A"
label var invest_a "Invest in A"

gen r_treat = 1 if treat_loop == "baseline"
replace r_treat = 0 if treat_loop == "control"
label var r_treat "treatment round"

gen b_treat = 1 if treat_block == "baseline"
replace b_treat = 0 if treat_block == "control"
label var b_treat "treatment block"

// make value labels for the treatment variables 
label define treatlab 0 "Control" 1 "Treatment"

label values r_treat treatlab
label values b_treat treatlab

// rename the aligned variables
rename guess_2_?_align post_?
rename guess_1_?_align prior_?

rename actual_red_?_align true_?

gen diff_1 = prior_a - prior_b
label var diff_1 "Guess 1 Diff (A-B)"
gen diff_2 = post_a - post_b
label var diff_2 "Guess 2 Diff (A-B)"

 */



// append guesses for portfolio A and B
preserve 

save $datadir/clean/pilot_4_5_append_init_clean.dta, replace 






log close 
translate $projdir/log_files/pilot/clean_pilot4_5.smcl ///
    $projdir/log_files/pilot/clean_pilot4_5.log, replace 