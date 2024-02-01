if c(hostname) == "scribe" {
    global datadir ""
}
else if c(os) == "MacOSX" & c(username) == "christinasun" {
    global datadir "/Users/christinasun/Library/CloudStorage/Dropbox/Davis/Research_Projects/belief_distortion/data_local"
    global projdir "/Users/christinasun/Library/CloudStorage/Dropbox/github_repos/belief_distortion/analysis"
    cd $projdir
}
else {
    di "hostname: " c(hostname)
    di "username: " c(username)
    di "Settings for this host and user not found!"
}

