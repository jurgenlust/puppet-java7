class java7 {
	$version = "1.7.0_05"
	$tarball = $architecture ? {
		"amd64" => "jdk-7u5-linux-x64.tar.gz",
		default => "jdk-7u5-linux-i586.tar.gz",
	}
	
	package { "java-common":
		ensure => latest,
	}
	
	file { "java-tarball":
		ensure => file,
		path => "/tmp/$tarball",
		source => "puppet:///modules/java7/${tarball}", 
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
		command => "/bin/mv jdk${version} /usr/lib/jvm/jdk${version}",
		cwd => "/tmp",
		user => "root",
		require => File["/usr/lib/jvm"],
	}
	
	file { "/usr/lib/jvm/java-7-oracle":
		ensure => link,
		target => "/usr/lib/jvm/jdk${version}",
		require => Exec["move-java-directory"]
	}
	
	exec { "install-java-alternative":
		command => '/usr/sbin/update-alternatives --install "/usr/bin/java" "java" "/usr/lib/jvm/java-7-oracle/bin/java" 1',
		require => File["/usr/lib/jvm/java-7-oracle"],
	}

	exec { "install-javac-alternative":
		command => '/usr/sbin/update-alternatives --install "/usr/bin/javac" "javac" "/usr/lib/jvm/java-7-oracle/bin/javac" 1',
		require => File["/usr/lib/jvm/java-7-oracle"],
	}

	exec { "install-javaws-alternative":
		command => '/usr/sbin/update-alternatives --install "/usr/bin/javaws" "javaws" "/usr/lib/jvm/java-7-oracle/bin/javaws" 1',
		require => File["/usr/lib/jvm/java-7-oracle"],
	}
}