Maturity?
---------
Experimental

Repository?
-----------
This holds a single vagrant box configuration

Vagrant?
--------
[Vagrant](http://vagrantup.com/) boxes are makefiles for virtual machines in [Virtual Box](https://www.virtualbox.org/). They contain a small configuration, followed by a set of [Puppet](http://puppetlabs.com/) or Chef scripts.

Use?
----
1.  Open the `manifests/default.pp` file after checking out this git repo
2.  Uncomment all the `include` [module](https://github.com/xebia/vagrantboxes/tree/master/modules) statements you like in your VM
3.  Issue the command `vagrant up` next to the `Vagrantfile`

    ... Wait for it ...

4.  Log into the VM using the command `vagrant ssh`
5.  Reboot the VM to start all the installed services with `sudo reboot`. They are not enabled by default to save memory during installation

If you find you have not got enough memory allocated, change the memory configuration in `Vagrantfile`.

Contribute?
-----------
1.  Create your own module in modules, feel free to use [Puppet Forge](http://forge.puppetlabs.com/) as a reference.
2.  Add a commented-out include line in the `default.pp` file.
