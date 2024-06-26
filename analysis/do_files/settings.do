if c(hostname) == "scribe" {
    global datadir "/home/research/ca_ed_lab/users/chesun/personal/jmp/data"
    global projdir "/home/research/ca_ed_lab/users/chesun/personal/jmp"
    cd $projdir 
    di "Scribe settings set correctly"

}
else if c(os) == "MacOSX" & c(username) == "christinasun" {
    global datadir "/Users/christinasun/Library/CloudStorage/Dropbox/Davis/Research_Projects/belief_distortion/data_local"
    global projdir "/Users/christinasun/Library/CloudStorage/Dropbox/github_repos/belief_distortion/analysis"
    global racedatadir "/Users/christinasun/Library/CloudStorage/Dropbox/Davis/Research_Projects/belief_distortion_discrimination/data_local"
    cd $projdir
    di "Personal Macbook settings set correctly"

}
else if c(hostname) == "Christina-PC" & c(username) == "sunch" {
    global datadir "D:\Programs\Dropbox\Davis\Research_Projects\belief_distortion\data_local"
    global racedatadir "D:\Programs\Dropbox\Davis\Research_Projects\belief_distortion_discrimination\data_local"
    global projdir "D:\Programs\Dropbox\github_repos\belief_distortion\analysis"
    cd $projdir
    di "Personal desktop PC settings set correctly"
}
else {
    di "hostname: " c(hostname)
    di "username: " c(username)
    di "Settings for this host and user not found!"
}

