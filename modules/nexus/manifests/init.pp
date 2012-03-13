
class nexus {
    $nexusVersion = "2.0.2"
    exec { "download nexus":
        command => "/bin/mkdir -p /opt/nexus; chown vagrant.vagrant /opt/nexus; /usr/bin/wget --continue --output-document=/opt/nexus/nexus-${nexusVersion}.zip http://www.sonatype.org/downloads/nexus-${nexusVersion}-bundle.zip",
        creates => "/opt/nexus/nexus-${nexusVersion}.zip",
    }
    
    package {"unzip": 
        ensure => installed,
        require => Class["apt"],
    }
    package {"openjdk-6-jdk":
        ensure => installed,
        require => Class["apt"],
    }
    exec { "configure start script":
        command => "/bin/sed --in-place=.orig -r -e 's/^#RUN_AS_USER=/RUN_AS_USER=vagrant/' /opt/nexus/nexus-${nexusVersion}/bin/nexus",
        user => "vagrant",
        group => "vagrant",
        creates => "/opt/nexus/nexus-${nexusVersion}/bin/nexus.orig",
        require => Exec['extract nexus'],
    }
    
    exec { "extract nexus":
        command => "/usr/bin/unzip nexus-${nexusVersion}.zip",
        user => "vagrant",
        group => "vagrant",
        cwd => "/opt/nexus/",
        creates => "/opt/nexus/nexus-${nexusVersion}/",
        require => [Package['unzip'], Exec['download nexus']],
    }
    exec {"install nexus":
        command => "/bin/ln -s /opt/nexus/nexus-${nexusVersion}/bin/nexus /etc/init.d/nexus; /usr/sbin/update-rc.d nexus defaults",
        creates => "/etc/rc0.d/K01nexus",
        require => [Exec['configure start script'], Package['openjdk-6-jdk']],
    }
    notice("Nexus will be at http://${::ipaddress_eth1}:8081/nexus/ after a reboot")
}
