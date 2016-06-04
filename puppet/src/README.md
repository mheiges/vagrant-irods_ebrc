This `src` directory contains Puppet modules only available in this
Vagrant project. Because Puppet librarian can clean out the `modules`
directory, we put local modules here, out of librarian's scope, and
reference them for in the Puppetfile for installation to `modules`.