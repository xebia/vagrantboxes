
class devtools {
    package {"development tools":
        name => [
            "vim",
            "emacs",
            "git",
            "net-tools",
            "nmap",
            "apache2-utils",
            "subversion",
            "telnet",
            "rsync",
        ],
        ensure => installed,
        require => Class["Apt"]
    }
}
