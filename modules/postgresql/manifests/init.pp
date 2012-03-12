

class postgresql {
    exec { 'load bootstrap sql':
        #TODO Fix a cool puppet way of doing the thing below, so we don't depend on vagrant
        command => '/bin/su --command /vagrant/modules/postgresql/files/loadsql.sh --login postgres',
        require => Package['install postgresql package'],
        creates => '/tmp/loadsql.done',
        logoutput => "on_failure",
    }
    file {"pg_hba.conf":
        path    => "/etc/postgresql/8.4/main/pg_hba.conf",
        owner   => postgres,
        group   => postgres,
        mode    => 644,
        content => template("postgresql/pg_hba.conf.erb"),
        require => Package['install postgresql package'],
    }
    file {"postgresql.conf":
        path    => "/etc/postgresql/8.4/main/postgresql.conf",
        owner   => postgres,
        group   => postgres,
        mode    => 644,
        content => template("postgresql/postgresql.conf"),
        require => Package['install postgresql package'],
    }
    package { "install postgresql package":
        name => ['postgresql'],
        ensure => installed,
    }
    exec { "stop postgresql":
        require => [Package['install postgresql package'], Exec['load bootstrap sql'], File['pg_hba.conf'], File['postgresql.conf'] ],
        command => '/usr/sbin/service postgresql stop'
    }
    notice("Postgresql will be available at ${::ipaddress_eth1} user:dbuser, pass:pass1234, db:dbdatabase after a reboot")
}
