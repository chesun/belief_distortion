/* explore pilot 1 data from Prolific, Jan 24, 2024
Goals:
1. check guess accuracy, bonus rate too high */

import delimited $datadir/raw/pilot_1_jan_24_2024.csv, clear

// drop all the timing questions
drop *firstclick *lastclick *pagesubmit *clickcount