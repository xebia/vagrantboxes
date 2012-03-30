
#TODO Inject the DISPLAY :0 variable in jenkins configuration, instead of overwriting config.
class xebium_ci {
    include jenkins
    include x11

    install-jenkins-plugin { "git-plugin" :
        name => "git",
        require => [Class['jenkins'], Package['Xebium CI packages']]
    }
    package {"Xebium CI packages":
        name => [
        "openjdk-6-jdk",
        "git",
        "iceweasel",
        "tar",
        "gzip",
        ],
        ensure => installed,
        require => Class["apt"]
    }
    File {
        owner => "jenkins",
        group => "nogroup",
        require => Class['jenkins'],
    }
    #TODO Use jenkins ci or xmlstarlet to fix the DISPLAY configuration
    file { "/var/lib/jenkins/config.xml":
        source => "puppet:///modules/xebium_ci/jenkins/config.xml"
    }
    file { "/var/lib/jenkins/hudson.plugins.git.GitSCM.xml":
        source => "puppet:///modules/xebium_ci/jenkins/hudson.plugins.git.GitSCM.xml"
    }
    file { "/var/lib/jenkins/hudson.tasks.Maven.xml":
        source => "puppet:///modules/xebium_ci/jenkins/hudson.tasks.Maven.xml"
    }

    #Install the Xebium job
    file { "/var/lib/jenkins/jobs/xebium":
      ensure => directory,
      recurse => true,
      purge => true,
      mode => 0644,
      source => "puppet:///modules/xebium_ci/xebium",
      require => Exec['create jobs directory']
    }
    exec {'create jobs directory':
        command => "/bin/mkdir -p /var/lib/jenkins/jobs",
        creates => "/var/lib/jenkins/jobs",
        user => "jenkins",
        group => "jenkins",
    }
    exec { "download maven":
        command => "/usr/bin/wget --continue --output-document=/vagrant/downloads/apache-maven-3.0.4-bin.tar.gz http://apache.hippo.nl/maven/binaries/apache-maven-3.0.4-bin.tar.gz",
        creates => "/vagrant/downloads/apache-maven-3.0.4-bin.tar.gz",
    }
    
    exec { "extract maven":
        command => "/bin/mkdir -p /var/lib/jenkins/tools/Maven_3.0.4; /bin/tar -xz -C /var/lib/jenkins/tools/Maven_3.0.4 --strip-components=1 -f /vagrant/downloads/apache-maven-3.0.4-bin.tar.gz",
        user => "jenkins",
        group => "nogroup",
        creates => "/var/lib/jenkins/tools/Maven_3.0.4",
        require => [Exec['download maven']],
    }
}

########################
### Code below copied from https://github.com/rafaelfelix/puppet-jenkins/blob/master/manifests/init.pp
########################
define install-jenkins-plugin($name, $version=0) {
  $plugin = "${name}.hpi"
  $plugin_parent_dir = "/var/lib/jenkins"
  $plugin_dir = "/var/lib/jenkins/plugins"

  if ($version != 0) {
    $base_url = "http://updates.jenkins-ci.org/download/plugins/${name}/${version}/"
  }
  else {
    $base_url = "http://updates.jenkins-ci.org/latest/"
  }

  if (!defined(File["${plugin_dir}"])) {
    file {
      [$plugin_parent_dir, $plugin_dir]:
        owner => "jenkins",
        ensure => directory;
    }
  }

  if (!defined(User["jenkins"])) {
    user {
      "jenkins" :
        ensure => present;
    }
  }
  exec {
    "download-${name}" :
      command => "wget --no-check-certificate ${base_url}${plugin}",
      cwd => "${plugin_dir}",
      require => File["${plugin_dir}"],
      path => ["/usr/bin", "/usr/sbin",],
      user => "jenkins",
      group => "nogroup",
      unless => "test -f ${plugin_dir}/${plugin}";
  }
}
