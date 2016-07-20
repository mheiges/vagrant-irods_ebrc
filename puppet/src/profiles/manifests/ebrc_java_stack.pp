# Full java deployment for EuPathDB BRC servers
# Includes
#  - installing one or more Java packages from EuPathDB YUM repo
#  - adds EuPathDB's certificate authority to cacerts keystore.
#
# Hiera
#
#  The following hiera data should be set for use by the underlying
#  modules.
#
#  Used by ebrc_java
#    ebrc_java::packages - an array of Java packages to install, e.g
#        ebrc_java::packages:
#          - jdk-1.7.0_80
#          - jdk-1.8.0_01
#    ebrc_java::java_home - the full path to $JAVA_HOME, e.g.
#         ebrc_java::java_home: /usr/java/jdk1.7.0_80
#
#  Used by ::profiles::ebrc_ca_keystore
#   java_keystore_target - the full path to the Java keystore file, e.g.
#         java_keystore_target: /etc/pki/tls/certs/cacerts
#   java_keystore_passwd - the keystore password
#         java_keystore_passwd: graeo5locza
#
#  Used by ::profiles::ebrc_ca_bundle
#    ebrc_ca::cacert - the file name of EBRC's CA
#       ebrc_ca::cacert: apidb-ca-rsa.crt
#
class profiles::ebrc_java_stack {

  include ::ebrc_yum_repo
  include ::profiles::ebrc_ca_bundle
  include ::profiles::ebrc_ca_keystore

  $java_home     = hiera('ebrc_java::java_home')
  $java_packages = hiera('ebrc_java::packages')

  class { '::ebrc_java':
    packages  => $java_packages,
    java_home => $java_home,
  }

  Class['::ebrc_yum_repo'] ->
  Class['::ebrc_java'] ->
  Class['::profiles::ebrc_ca_bundle'] ->
  Class['::profiles::ebrc_ca_keystore']

}
