
- Creates user `dbuser`
- with password `pass1234`
- owning database `dbdatabase`

by default. It does so, by loading all ../files/sql/*.sql as db admin.

Please note: As with all services, postgresql will be stopped after installation to preserve memory to keep the installation process more predictable.

Either reboot after installation, or use `vagrant ssh` followed by `sudo service postgresql start`.
