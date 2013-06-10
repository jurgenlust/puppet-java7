class java7 ($version = "1.7.0_05", $tarball_name_prefix = "jdk-7u5-linux", $jdk_path = "") {

	$tarball = $architecture ? {
		"amd64" => "${tarball_name_prefix}-x64.tar.gz",
		default => "${tarball_name_prefix}-i586.tar.gz",
	}
	
	package { "java-common":
		ensure => latest,
	}
	
	if jdk_path == "" {
		file { "java-tarball":
			ensure => file,
			path => "/tmp/$tarball",
			source => "puppet:///modules/java7/${tarball}", 
		}
	}
	else {
		exec { "cp-java-tarball-to-tmp":
			command => "cp $jdk_path/$tarball /tmp/$tarball",
			unless => "[ -f /tmp/$tarball]"
		} ->
		file { "java-tarball":
			ensure => file,
			path => "/tmp/$tarball",
		}
	}
	
	exec { "extract-java-tarball":
		command => "/bin/tar -xvzf ${tarball}",
		cwd => "/tmp",
		user => "root",
		creates => "/tmp/jdk${version}",
		require => File["java-tarball"],
	}
	
	file { "/usr/lib/jvm":
		ensure => directory,
		owner => "root",
		group => "root",
		require => Exec["extract-java-tarball"],
	}

	exec { "move-java-directory":
		command => "/bin/cp -r jdk${version} /usr/lib/jvm/jdk${version}",
		creates => "/usr/lib/jvm/jdk${version}",
		cwd => "/tmp",
		user => "root",
		require => File["/usr/lib/jvm"],
		notify => [
			Exec["install-java-alternative"],
			Exec["install-javac-alternative"],
			Exec["install-javaws-alternative"]
		]
	}
	
	file { "/usr/lib/jvm/java-7-oracle":
		ensure => link,
		target => "/usr/lib/jvm/jdk${version}",
		require => Exec["move-java-directory"]
	}
	
	exec { "install-java-alternative":
		command => '/usr/sbin/update-alternatives --install "/usr/bin/java" "java" "/usr/lib/jvm/java-7-oracle/bin/java" 1',
		refreshonly => true,
		require => File["/usr/lib/jvm/java-7-oracle"],
	}

	exec { "install-javac-alternative":
		command => '/usr/sbin/update-alternatives --install "/usr/bin/javac" "javac" "/usr/lib/jvm/java-7-oracle/bin/javac" 1',
		refreshonly => true,
		require => File["/usr/lib/jvm/java-7-oracle"],
	}

	exec { "install-javaws-alternative":
		command => '/usr/sbin/update-alternatives --install "/usr/bin/javaws" "javaws" "/usr/lib/jvm/java-7-oracle/bin/javaws" 1',
		refreshonly => true,
		require => File["/usr/lib/jvm/java-7-oracle"],
	}
}
