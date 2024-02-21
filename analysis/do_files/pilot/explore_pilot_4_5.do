/* initial exploration of data from pilot 4 and 5 on prolific*/

/* To run this do fiile:
do $projdir/do_files/pilot/clean_pilot4_5.do
 */

cap log close _all

log using $projdir/log_files/pilot/explore_pilot4_5.smcl, replace

graph drop _all
set more off
set varabbrev off
set graphics on
set scheme s1color
set seed 1984


use $datadir/clean/pilot_4_5_append_init_clean, clear 



// check the distribution of guess 2 between treatments
// guess 2 A, in baseline treatment, by invest choice
twoway (scatter post_a true_a if loop_baseline==1 & invest_a == 0) (scatter post_a true_a if loop_baseline==1 & invest_a == 1), title("Baseline loops") legend(label(1 "Invested in B") label(2 "Invested in A"))
// plot it on prior
twoway (scatter post_a prior_a if loop_baseline==1 & invest_a == 0) (scatter post_a prior_a if loop_baseline==1 & invest_a == 1), title("Baseline loops") legend(label(1 "Invested in B") label(2 "Invested in A"))

// guess 2 A, in control treatment, by invest choice
twoway (scatter post_a true_a if loop_baseline==0 & invest_a == 0) (scatter post_a true_a if loop_baseline==0 & invest_a == 1), title("Control loops") legend(label(1 "Invested in B") label(2 "Invested in A"))
// plot on prior
twoway (scatter post_a prior_a if loop_baseline==0 & invest_a == 0) (scatter post_a prior_a if loop_baseline==0 & invest_a == 1), title("Control loops") legend(label(1 "Invested in B") label(2 "Invested in A"))

// guess 2 B
twoway (scatter post_b prior_b if loop_baseline==1 & invest_a == 0) (scatter post_b prior_b if loop_baseline==1 & invest_a == 1), title("Baseline loops") legend(label(1 "Invested in B") label(2 "Invested in A"))
twoway (scatter post_b prior_b if loop_baseline==0 & invest_a == 0) (scatter post_b prior_b if loop_baseline==0 & invest_a == 1), title("Control loops") legend(label(1 "Invested in B") label(2 "Invested in A"))



bysort true_a invest_a: egen mean_post_a = mean(post_a) if loop_baseline==1
bysort true_a: egen temp = mean(post_a) if loop_baseline==0
replace mean_post_a = temp if loop_baseline==0

twoway (scatter mean_post_a true_a if loop_baseline==1 ) (scatter mean_post_a true_a if loop_baseline==0)


twoway (scatter mean_post_a true_a if loop_baseline==1 & invest_a == 1) (scatter mean_post_a true_a if loop_baseline== 1 & invest_a==0) (scatter mean_post_a true_a if loop_baseline== 0), legend(label(1 "Treat, Invest A") label(2 "Treat, invest B") label(3 "Control"))



graph bar (mean) post_a,  over(loop_baseline) over(invest_a)  over(true_a)

log close 
translate $projdir/log_files/pilot/explore_pilot4_5.smcl ///
    $projdir/log_files/pilot/explore_pilot4_5.log, replace 

