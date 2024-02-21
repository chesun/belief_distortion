/* clean the loop and merge settings data for set 1 matrices */

/* To run this do fiile:
do $projdir/do_files/pilot/clean_matdata_set1.do
 */

cap log close _all

log using $projdir/log_files/pilot/clean_matdata_set1.smcl, replace

graph drop _all
set more off
set varabbrev off
set graphics off
set scheme s1color
set seed 1984

import delimited $datadir/raw/set_1_lm_settings.csv, varnames(1) clear


// dummy for top or bottom half shown
gen top = 1 if mat_half == "top"
replace top = 0 if mat_half == "bottom"

// rename vars
rename mat_1_red_half half_a
rename mat_1_red_total full_a

rename mat_2_red_half half_b
rename mat_2_red_total full_b

drop pair_number mat_half treatment 

preserve

// make a temp dataset for left matrices (portfolio A in the experiment)
keep *_a task_id top 
gen left = 1 
label var left "Left Portfolio (Portfolio A)"
rename half_a half 
rename full_a full 

tempfile a 
save `a'

restore 

// make a dataset for right matrices (Portfolio B in the experiment)
keep *_b task_id top 
gen left = 0
label var left "Left Portfolio (Portfolio A)"
rename half_b half 
rename full_b full 

append using `a'

label define leftlab 0 "Right (B)" 1 "Left (A)"
label values left leftlab 

label var half "True Red in Half"
label var full "True Red in Full"

label var top "Top or Bottom Half"

save $datadir/clean/matdata_set1_clean.dta, replace 






log close 
translate $projdir/log_files/pilot/clean_matdata_set1.smcl ///
    $projdir/log_files/pilot/clean_matdata_set1.log 