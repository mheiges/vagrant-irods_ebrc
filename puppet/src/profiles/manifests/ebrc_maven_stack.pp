# Full Maven deployment for EuPathDB BRC servers
#
# Includes
#  - installing one or more Maven packages from EuPathDB YUM repo
#  - installing EBRC's java stack (javac is required to execute mvn)
#
# Hiera
#
#  The following hiera data should be set for use by the underlying
#  modules.
#
#  Used by ebrc_maven
#    ebrc_maven::packages - an array of Maven packages to install, e.g
#       ebrc_maven::packages:
#         - maven-3.3.3
#    ebrc_maven::maven_home - the full path to $MAVEN_HOME ($M2), e.g.
#       ebrc_maven::maven_home: /usr/java/maven-3.3.3
#
#  Used by ebrc_java
#    ebrc_java::packages - an array of Java packages to install, e.g
#        ebrc_java::packages:
#          - jdk-1.7.0_80
#          - jdk-1.8.0_01
#    ebrc_java::java_home - the full path to $JAVA_HOME, e.g.
#         ebrc_java::java_home: /usr/java/jdk1.7.0_80
#
class profiles::ebrc_maven_stack {

  include ::ebrc_yum_repo
  include ::profiles::ebrc_java_stack

  $maven_home = hiera('ebrc_maven::maven_home')

  class { '::ebrc_maven':
    packages   => hiera('ebrc_maven::packages'),
    maven_home => hiera('ebrc_maven::maven_home'),
  }

  Class['::ebrc_yum_repo'] ->
  Class['::ebrc_maven']

}
