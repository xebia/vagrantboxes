
class oraclejdks {
    exec {"create java dir":
        command => "/bin/mkdir -p /opt/java",
        creates => "/opt/java",
        user => root,
        group => root,
    }
    
    exec { "extract available jdks":
        command => "/usr/bin/find /vagrant/downloads/ -type f -name 'jdk*-linux-x64.tar.gz' -print0 | /usr/bin/xargs -n1 -0 /bin/tar -xzf ",
        cwd => "/opt/java",
        user => root,
        group => root,
        require => Exec["create java dir"],
    }
}
