/* initial exploration of data from pilot 4 - 6 on prolific*/

/* To run this do fiile:
do $projdir/do_files/pilot/explore_pilots.do
 */

cap log close _all

log using $projdir/log_files/pilot/explore_pilots.smcl, replace

graph drop _all
set more off
set varabbrev off
set graphics on
set scheme s1color
set seed 1984


use $datadir/clean/pilots_init_clean, clear 

// keep subjects who did not make wrong direction investments, 69 subjects left
keep if dir_correct_subject == 1
preserve 

//-------------------------------------------
// guess 1 distribution
//-------------------------------------------
// check the mean of guess 1 by treatment and true number of full matrix
graph bar (mean) prior, over(r_treat) over(full) asyvars
// group by true number of half matrix
graph bar (mean) prior, over(r_treat) over(half) asyvars

// box whisker plot for guess 1
graph box prior, over(r_treat) over(full) asyvars
graph export $projdir/figures/pilots/pilot6/priors_boxplot.png, replace

//-----------------------------------------
// posterior means and errors
//----------------------------------------

graph bar (mean) post, over(r_treat)  over(invest)  over(full)
graph export $projdir/figures/pilots/pilot6/post_barplot.png, replace

graph bar (mean) post if g1_dirc==0, over(r_treat)  over(invest)  over(full)

graph bar (mean) post, over(r_treat)  over(prior) asyvars


graph bar (mean) post_error, over(r_treat)  over(invest)  over(full)
graph export $projdir/figures/pilots/pilot6/post_errors_boxplot.png, replace

graph bar (mean) diff_post, over(r_treat)  over(invest)  over(full)


bysort r_treat invest full: egen mpost = mean(post)
bysort r_treat full: egen mpost_c = mean(post)
replace mpost = mpost_c if r_treat == 0
graph twoway (line mpost full if r_treat==0) (line mpost full if r_treat==1 & invest == 0 ) (line mpost full if r_treat==1 & invest == 1 ), legend(label(1 "Control") label(2 "Treat, Not Chosen") label(3 "Treat, Chosen"))


gen true = full

gen treat_cond = 0 if r_treat==0
replace treat_cond = 1 if r_treat==1 & invest==0
replace treat_cond = 2 if r_treat==1 & invest==1
label define treatcondlab 0 "Control" 1 "Treat, NoInvest" 2 "Treat, Invest"
label values treat_cond treatcondlab
graph bar post ,  over(treat_cond)  over(full) asyvars

bysort r_treat invest prior: egen mpost = mean(post)
bysort r_treat prior: egen mpost_c = mean(post)
replace mpost = mpost_c if r_treat == 0
twoway (connected mpost prior if treat_cond==0) (connected mpost prior if treat_cond==1) (connected mpost prior if treat_cond==2)

//------------------------------------------------------------------------------
// explore data with one round per observation
//------------------------------------------------------------------------------
// qualitative guess direction mistakes
use $datadir/clean/pilots_2matperob.dta, clear
graph bar dc2, over(r_treat)  over(dc1) asyvars
graph export $projdir/figures/pilots/pilot6/guess_dir.png, replace



log close 
translate $projdir/log_files/pilot/explore_pilots.smcl ///
    $projdir/log_files/pilot/explore_pilots.log, replace 

