
class x11 {
    package { "install X11 packages":
        name => ['xmonad', 'vnc4server', 'nodm'],
        ensure => installed,
        require => Class["apt"],
    }
    file {"nodm":
        path    => "/etc/default/nodm",
        owner   => root,
        group   => root,
        mode    => 644,
        content => template("x11/nodm"),
        require => Package['install X11 packages'],
    }
    file {"xserverrc":
        path    => "/root/.xserverrc",
        owner   => root,
        group   => root,
        mode    => 744,
        content => template("x11/xserverrc"),
        require => Package['install X11 packages'],
    }
    notice("VNC will be at ${::ipaddress_eth1} after a reboot")
}
