/* check the validity of embedded data from pilot3 on prolific, 
completed Feb 7, 2024 */

/* To run this do fiile:
do $projdir/do_files/pilot/check_embedded_data.do
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

//--------------------------------------------------------------------------------------
// check actual red embedded data equals actual red from the loop and merge settings
//-------------------------------------------------------------------------------------------

preserve
forvalues round = 1/12 {
    keep actual_red_a_round`round' actual_red_b_round`round' task_id_loop`round' responseid
    rename task_id_loop`round' task_id
    tempfile actual_red_check
    save `actual_red_check'

    import delimited $datadir/raw/set_1_lm_settings.csv, varnames(1) clear
    merge 1:m task_id using `actual_red_check', keep(3) nogen
    assert mat_1_red_total == actual_red_a_round`round'
    assert mat_2_red_total == actual_red_b_round`round'
    di "assertion passed"
    restore, preserve 
}

log close
translate using $projdir/log_files/pilot/explore_pilot3.smcl ///
    using $projdir/log_files/pilot/explore_pilot3.log, replace