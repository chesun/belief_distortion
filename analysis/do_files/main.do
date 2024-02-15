/* to run this do file on local Mac machine:
cd "/Users/christinasun/Library/CloudStorage/Dropbox/github_repos/belief_distortion/analysis"
do do_files/main.do
 */

if c(hostname) == "scribe" {
    cd "/home/research/ca_ed_lab/users/chesun/personal/jmp"
    do do_files/settings.do
}
else if c(os) == "MacOSX" & c(username) == "christinasun" {
    cd "/Users/christinasun/Library/CloudStorage/Dropbox/github_repos/belief_distortion/analysis"
    do do_files/settings.do
}
else {
    di "hostname: " c(hostname)
    di "username: " c(username)
    di "Settings for this host and user not found!"
    di "current directory: "
    pwd
}


do $projdir/do_files/pilot/explore_pilot3.do
