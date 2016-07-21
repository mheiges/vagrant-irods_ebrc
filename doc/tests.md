
## Create resources

There some resources defined in hiera (see `irods::icommands` execs) that
are created as part of the provisioning of the client node
(`vagrant up client`). Confirm that is the case.

    $ vagrant ssh rs1

    [vagrant@rs1 ~]$ sudo su - irods

    -bash-4.2$ ilsresc
    demoResc
    rs1Resource
    -bash-4.2$ 
    -bash-4.2$ ilsresc
    data:roundrobin
    └── data_7k_001
    data_7k_002
    demoResc
    repl:replication
    ├── data_7k_003
    └── data_7k_004
    rs1Resource


## Test replication resource

    [vagrant@rs1 ~]$ echo passWORD | ireinit icatadmin
    [vagrant@rs1 ~]$ date > foo
    [vagrant@rs1 ~]$ iput -R repl foo
    [vagrant@rs1 ~]$ ils -l foo
      icatadmin         0 repl;data_7k_004           29 2016-06-29.12:39 & foo
      icatadmin         1 repl;data_7k_003           29 2016-06-29.12:39 & foo


Confirm file is replicated to rs1 and icat

    $ vagrant ssh rs1 -- sudo ls -l /srv/irods/vault_7k_003/home/icatadmin
    total 4
    -rw------- 1 irods irods 29 Jun 29 12:39 foo

    $ vagrant ssh ies -- sudo ls -l /srv/irods/vault_7k_004/home/icatadmin
    total 4
    -rw------- 1 irods irods 29 Jun 29 12:39 foo

## Test PAM auth.

On rs1 (already logged in as `icatadmin`)

    [vagrant@rs1 ~]$ iadmin mkuser mheiges rodsuser

On client, bootstrap `irods_environment.json` with PAM auth scheme.

    [vagrant@client ~]$ mkdir -p ~/.irods && echo '{"irods_authentication_scheme": "PAM"}' | jq . > .irods/irods_environment.json

Login

(if using PAM/LDAP be sure the LDAP server is reachable from behind its firewall)

    [vagrant@client ~]$ iinit 
    One or more fields in your iRODS environment file (irods_environment.json) are
    missing; please enter them.
    Enter the host name (DNS) of the server to connect to: ies.irods.vm
    Enter the port number: 1247
    Enter your irods user name: mheiges
    Enter your irods zone: ebrc
    Those values will be added to your environment file (for use by
    other iCommands) if the login succeeds.

    Enter your current PAM password:

Confirm

    [vagrant@client ~]$ ienv |grep user
    NOTICE: irods_user_name - mheiges
