puppet-java7
============

Puppet module for managing Oracle JDK 7 on Debian or Ubuntu.

Note that this module does not work out-of-the-box. You need to manually download the i586 or x64 JDK tarballs from Oracle here:
[http://www.oracle.com/technetwork/java/javase/downloads/jdk7-downloads-1637583.html](http://www.oracle.com/technetwork/java/javase/downloads/jdk7-downloads-1637583.html).
By default, either *jdk-7u5-linux-i586.tar.gz* or *jdk-7u5-linux-x64.tar.gz* (depending on your architecture) need to be put in the *files* directory of this module. 

You can also configure the class with the name of the tarball, the java version to install, and the path where the JDK tarball can be found.
For example, the following configuration is used in Debian Wheeze to install the 1.7.0_21 version of the X64 JDK:

    class some_class {
       class { 'java7':
          version => '1.7.0_21',
          tarball_name_prefix => 'jdk-7u21-linux',
          jdk_path => '/var/run/puppet/java/'
       }
    }
