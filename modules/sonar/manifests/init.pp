

class sonar {
    $sonarVersion = "2.13.1"
    exec { "download sonar":
        command => "/usr/bin/wget --continue --output-document=/vagrant/downloads/sonar-${sonarVersion}.zip http://dist.sonar.codehaus.org/sonar-${sonarVersion}.zip",
        creates => "/vagrant/downloads/sonar-${sonarVersion}.zip",
    }
    
    package {"unzip": ensure => installed}
    
    exec { "extract sonar":
        command => "/usr/bin/unzip /vagrant/downloads/sonar-${sonarVersion}.zip",
        cwd => "/opt/",
        creates => "/opt/sonar-${sonarVersion}/",
        require => [Package['unzip'], Exec['download sonar']],
    }
    exec {"install sonar":
        command => "/bin/ln -s /opt/sonar-${sonarVersion}/bin/linux-x86-64/sonar.sh /etc/init.d/sonar; /usr/sbin/update-rc.d sonar defaults",
        creates => "/etc/rc0.d/K01sonar",
        require => [Exec['extract sonar']],
    }
    notice("Sonar will be at http://${::ipaddress_eth1}:9000/ after a reboot")
}
