
class jenkins {
    exec { "add jenkins repo key":
        command => '/usr/bin/wget -q -O - http://pkg.jenkins-ci.org/debian/jenkins-ci.org.key | /usr/bin/sudo /usr/bin/apt-key add -',
        unless => '/usr/bin/sudo /usr/bin/apt-key list |grep "Kohsuke Kawaguchi"',
    }
    exec { "add jenkins repo":
        command => '/bin/echo deb http://pkg.jenkins-ci.org/debian binary/ > /etc/apt/sources.list.d/jenkins.list && /usr/bin/sudo /usr/bin/apt-get update',
        creates => "/etc/apt/sources.list.d/jenkins.list",
        require => Exec['add jenkins repo key']
    }
    package { "install jenkins package":
        name => ['jenkins'],
        ensure => installed,
        require => Exec['add jenkins repo']
    }
    exec { "stop jenkins":
        require => Package['install jenkins package'],
        command => '/usr/sbin/service jenkins stop'
        }
    notice("Jenkins will be at http://${::ipaddress_eth1}:8080/ after a reboot")
}
