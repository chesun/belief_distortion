/* explore data from pilot 3 on prolific, 
completed Feb 7, 2024 */

/* To run this do fiile:
do $projdir/do_files/pilot/explore_pilot3.do
 */

cap log close _all

log using $projdir/log_files/pilot/explore_pilot3.smcl, replace

graph drop _all
set more off
set varabbrev off
set graphics off
set scheme s1color
set seed 1984

import delimited $datadir/raw/pilot_3_feb_7_2024_import_ready.csv, varnames(1) clear




//-----------------------------------------------------
// initial cleaning
//-----------------------------------------------------
// drop all timing data
drop *click *pagesubmit *clickcount

// drop practice round data and quiz answers
drop loop1_q34_1 - q67 current_loop* current_practice*

// drop admin variables
drop startdate-progress finished recordeddate distributionchannel-q4

// drop prolific ID question, use embedded data
drop q5

// drop loop question answers, use embedded data
drop loop*

// drop unused round embedded data
forvalues i = 13/20 {
    drop *round`i'
    drop *loop`i'
}

// create a var for failing the quiz, this becomes an embedded data field in pilot 4
// in pilot3 the max number of failed tries for each quiz question is 2
gen quiz_failed = 0

forvalues quiznum = 1/9 {
    replace quiz_failed = 1 if errors_quiz_q`quiznum' >= 3
}

drop if quiz_failed == 1

//--------------------------------------------
// calculate investment game scores
//---------------------------------------------
gen invest_score = 0
forvalues round = 1/12 {
    gen success_round`round' = 0
    replace success_round`round' = 1 if ///
        ((actual_red_a_round`round' > actual_red_b_round`round') & invest_round`round' == "A") ///
        | ((actual_red_a_round`round' < actual_red_b_round`round') & invest_round`round' == "B")
    replace invest_score = invest_score + success_round`round'
}

sort invest_score
gen earned_game_bonus = 0
sum win_bonus
replace earned_game_bonus = r(max) if _n <= 3
// export investment game score to csv
preserve 
keep responseid prolific_pid earned_game_bonus earned_belief_bonus earned_invest_bonus
export delimited using $datadir/clean/pilot3_bonus.csv, replace 
restore

// keep only the belief, choice, and actual red variables
drop q144 - errors_quiz_q9

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

gen change_a = guess_2_a - guess_1_a
gen change_b = guess_2_b - guess_1_b

twoway (scatter guess_1_a actual_red_a if treat_loop=="baseline", yscale(range(0 100)) xscale(range(0 100))) (scatter guess_1_a actual_red_a if treat_loop=="control", yscale(range(0 100)) xscale(range(0 100)) ), legend(label(1 "Treatment") label(2 "Control")) title("Portfolio A Guess 1")
twoway (scatter guess_1_b actual_red_b if treat_loop=="baseline", yscale(range(0 100)) xscale(range(0 100))) (scatter guess_1_b actual_red_b if treat_loop=="control", yscale(range(0 100)) xscale(range(0 100)) ), legend(label(1 "Treatment") label(2 "Control")) title("Portfolio B Guess 1")


ranksum guess_1_b, by(treat_loop)

save $datadir/clean/pilot_3_clean.dta, replace

log close 
translate $projdir/log_files/pilot/explore_pilot3.smcl ///
    $projdir/log_files/pilot/explore_pilot3.log, replace