
Exec {
    logoutput => "on_failure",
}

exec { "add jenkins repo key":
    command => '/usr/bin/wget -q -O - http://pkg.jenkins-ci.org/debian/jenkins-ci.org.key | /usr/bin/sudo /usr/bin/apt-key add -',
}
exec { "add jenkins repo":
    command => '/bin/echo deb http://pkg.jenkins-ci.org/debian binary/ > /etc/apt/sources.list.d/jenkins.list',
    creates => "/etc/apt/sources.list.d/jenkins.list",
    require => Exec['add jenkins repo key']
}

#Update APT cache if it has been more then 24 hours since our last dpkg activity
exec { "apt-get update":
    command => "/usr/bin/apt-get update",
    user => root,
    group => root,
    unless => '/usr/bin/test "`/usr/bin/find /var/log/dpkg.log -mtime 0`"',
    require => Exec['add jenkins repo']
}

package { "jenkins":
    name => ['jenkins'],
    ensure => installed,
    require => Exec["apt-get update"],
}
