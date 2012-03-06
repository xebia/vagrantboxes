

class apt {
    #Update APT cache if it has been more then 24 hours since our last dpkg activity
    exec { "refresh":
        command => "/usr/bin/apt-get update",
        user => root,
        group => root,
        unless => '/usr/bin/test "`/usr/bin/find /var/log/dpkg.log -mtime 0`"',
    }
}


