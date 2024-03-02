/* clean data from pilot 4, 5, and 6 on prolific*/

/* To run this do fiile:
do $projdir/do_files/pilot/clean_pilots.do
 */

cap log close _all

log using $projdir/log_files/pilot/clean_pilots.smcl, replace

graph drop _all
set more off
set varabbrev off
set graphics off
set scheme s1color
set seed 1984

foreach pilotnum in 4 5 6 {
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
        actual_red_half_a_round actual_red_half_b_round ///
        guess_2_a_round guess_2_b_round ///
        invest_round success_round, i(responseid) j(round)

    rename guess_1_a_round g1a 
    rename guess_1_b_round g1b
    rename actual_red_a_round full_a
    rename actual_red_b_round full_b
    rename actual_red_half_a_round half_a // pilot 4 doesn't have these embedded data
    rename actual_red_half_b_round half_b
    rename guess_2_a_round g2a 
    rename guess_2_b_round g2b
    rename invest_round invest
    rename success_round success 

    rename treatment treat_block 


    //------ demographics and embedded data are left here-----------

    /* in this data, no one wrote in gender */
    drop gender_6_text

    // keep only choice and belief data demographics, and experiment setup parameters
    keep responseid - recordeddate ///
        rses* list_exp* race - gender ///
        num_rounds invest_score treat* task_id* g?? full* quiz* invest success

    drop quiz_failed

    

    order responseid round g?? treat* task* invest success

    //-------------------------------------------------
    // create numeric dummies for treatment variables
    //--------------------------------------------------
    gen r_treat = 1 if treat_loop == "baseline"
    replace r_treat = 0 if treat_loop == "control"
    label var r_treat "treatment round"

    gen b_treat = 1 if treat_block == "baseline"
    replace b_treat = 0 if treat_block == "control"
    label var b_treat "treatment block"

    // make value labels for the treatment variables 
    label define treatlab 0 "C" 1 "T"

    label values r_treat treatlab
    label values b_treat treatlab

    // numeric dummy for invest in a
    gen invest_a = 0 if invest=="B"
    replace invest_a = 1 if invest == "A"

    // drop the string vars
    drop treat_block treat_loop 

    rename task_id_loop task_id

    //create a matrxi pair id
    gen pair_id = task_id if task_id<=10
    replace pair_id = task_id - 10 if task_id > 10

    //-----------------------------------------------------------------------------
    // exclude subjects in the treatment who did not invest in the right direction according to prior
    //-----------------------------------------------------------------------------
    gen diff_1 = g1a - g1b
    label var diff_1 "Guess 1 Diff (A-B)"
    gen diff_2 = g2a - g2b
    label var diff_2 "Guess 2 Diff (A-B)"
    // check if subjects understood the rules of the game: if they invested correctly based on their beliefs 
    gen dir_correct_round = 0
    label var dir_correct_round "Invest according to belief in round"
    // in treatment, investment should follow direction of priors 
    replace dir_correct_round = 1 if (invest_a==1 & diff_1 > 0 & r_treat==1) | (invest_a==0 & diff_1 < 0 & r_treat==1) 
    replace dir_correct_round = 1 if (diff_1 == 0 & r_treat==1) // if priors are even in the treatment, either choice is justifiable
    // in control, investment should follow direction of posteriors
    // if in control, they invested in A when they guessed A higher, and invested in B when they guessed B higher.
    replace dir_correct_round = 1 if (r_treat == 0 & invest_a == 1 & diff_2 > 0) | (r_treat == 0 & invest_a == 0 & diff_2 < 0)
    replace dir_correct_round = . if r_treat == 0 & diff_2 == 0 // if posterior guesses are even, they did not understand the game
    bysort responseid: egen dir_correct_subject = min(dir_correct_round)
    label var dir_correct_subject "Subject always invest according to belief"
    
    gen session_id = `pilotnum'
    rename responseid response_id


    //dummy for guess direction correct
    gen dc1 = 0
    replace dc1 = 1 if (full_a > full_b & g1a > g1b) | (full_a < full_b & g1a < g1b)

    gen dc2 = 0
    replace dc2 = 1 if (full_a > full_b & g2a > g2b) | (full_a < full_b & g2a < g2b)

    label define dc1lab 0 "Dir 1 Wrong" 1 "Dir 1 Correct"
    label values dc1 dc1lab 
    label define dc2lab 0 "Dir 2 Wrong" 1 "Dir 2 Correct"
    label values dc2 dc2lab

    gen woman = 1 if gender == "Man"
    replace woman = 0 if gender == "Woman"
    drop gender 



    // recode the RSES scale
    // these have the same rubric: strongly agree 3 to strongly disagree 0
    foreach i in 1 3 4 7 10 {
        gen rses_`i'_sc = 0 if rses_`i' == "Strongly Disagree"
        replace rses_`i'_sc = 1 if rses_`i' == "Disagree"
        replace rses_`i'_sc = 2 if rses_`i' == "Agree"
        replace rses_`i'_sc = 3 if rses_`i' == "Strongly Agree"

    }

    // these have the same rubric: strongly agree 0 to strongly disagree 3
    foreach i in 2 5 6 8 9 {
        gen rses_`i'_sc = 0 if rses_`i' == "Strongly Agree"
        replace rses_`i'_sc = 1 if rses_`i' == "Agree"
        replace rses_`i'_sc = 2 if rses_`i' == "Disagree"
        replace rses_`i'_sc = 3 if rses_`i' == "Strongly Disagree"
    }

    gen rses_sc = 0
    forvalues i = 1/10 {
        replace rses_sc = rses_sc + rses_`i'_sc
    }

    drop rses_? rses_10 rses_?_sc rses_10_sc
    label var rses_sc "RSES Scale, 0-30"

    // list experiment items
    forvalues num = 1/13 {
        gen agree_le`num' = 1 if list_exp_`num' == "Agree"
        replace agree_le`num' = 0 if list_exp_`num' == "Disagree"
    }
    label var agree_le1 "Can drive"
    label var agree_le2 "Vegetarian good"
    label var agree_le3 "Relax gun control"
    label var agree_le4 "Have license"
    label var agree_le5 "COVID overblown"
    label var agree_le6 "Gave > 1000 USD"
    label var agree_le7 "Dual Citizen"
    label var agree_le8 "Has social media"
    label var agree_le9 "Would vote anti abortion"
    label var agree_le10 "Should legalize rec marijuana federal"
    label var agree_le11 "Support BLM"
    label var agree_le12 "Own iPhone"
    label var agree_le13 "Parents decide vaccine"


    label data "Pilot `pilotnum', 1 obs per round"
    save $datadir/clean/pilot_`pilotnum'_init_clean.dta, replace
}



// append pilot4 and pilot5 and pilot6 data
use $datadir/clean/pilot_4_init_clean.dta, clear 
append using $datadir/clean/pilot_5_init_clean.dta
append using $datadir/clean/pilot_6_init_clean.dta

label data "One obs per round, both portfolios per obs"
save $datadir/clean/pilots_2matperob.dta, replace

    //--------------------------------------------------
    // split into portfolio A and B and append ------------------------
    //--------------------------------------------------
    preserve



    // drop guesses for portfolio B
    drop g?b 
    rename g1a prior 
    rename g2a post
    // indicator for portfolio A
    gen left = 1
    // a numeric var for invested in the portfolio in the round
    gen invest_temp = 1 if invest == "A"
    replace invest_temp = 0 if invest=="B"
    drop invest 
    rename invest_temp invest 

    tempfile a
    save `a', replace 

    restore

    drop g?a 
    rename g1b prior 
    rename g2b post 
    gen left = 0 

    gen invest_temp = 1 if invest == "A"
    replace invest_temp = 0 if invest=="B"
    drop invest 
    rename invest_temp invest 

    append using `a'


    // there should now be 2 observations per round

    // get actual red numbers from merging the matrix set records, discard the embedded data.
    drop full* 

    // merge on the matrix data
    merge m:1 task_id left using $datadir/clean/matdata_set1_clean, nogen

    order response_id session_id round task_id left *treat half full prior post invest success 


    label var left "Left Portfolio (Portfolio A)"
    label values left leftlab 

    label var prior "Guess 1"
    label var post "Guess 2"

    /* label define investlab 0 "Not Invested" 1 "Invested"
    label values invest investlab */

    
label data "2 obs per round, 1 portfolio per obs"
save $datadir/clean/pilots_init_clean.dta, replace 




set graph on

log close 
translate $projdir/log_files/pilot/clean_pilots.smcl ///
    $projdir/log_files/pilot/clean_pilots.log, replace 