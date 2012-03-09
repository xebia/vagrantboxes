
class mongodb {
    exec { "add mongodb repo key":
        command => '/usr/bin/sudo /usr/bin/apt-key adv --keyserver keyserver.ubuntu.com --recv 7F0CEB10',
        unless => '/usr/bin/sudo /usr/bin/apt-key list |grep "7F0CEB10"',
    }
    exec { "add mongodb repo":
        command => '/bin/echo "deb http://downloads-distro.mongodb.org/repo/debian-sysvinit dist 10gen" > /etc/apt/sources.list.d/mongodb.list && /usr/bin/sudo /usr/bin/apt-get update',
        creates => "/etc/apt/sources.list.d/mongodb.list",
        require => Exec['add mongodb repo key']
    }
    package { "install mongodb package":
        name => ['mongodb-10gen'],
        ensure => installed,
        require => Exec['add mongodb repo']
    }
    exec { "stop mongodb":
        require => Package['install mongodb package'],
        command => '/usr/sbin/service mongodb stop'
        }
    notice("MongoDB will be at ${::ipaddress_eth1} after a reboot")
}
