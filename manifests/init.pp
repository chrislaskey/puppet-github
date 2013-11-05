class puppetapt (
	$release,
	# See http://apt.puppetlabs.com/ for a list of available releases
){

	$deb_file_name = "puppetlabs-release-${release}.deb"
	$deb_file_url = "http://apt.puppetlabs.com/${deb_file_name}"

	file { "/etc/puppet/scripts":
		ensure => "directory",
		owner => "puppet",
		group => "puppet",
		mode => "0700",
	}

	file { "/etc/puppet/scripts/install-puppetapt.sh":
		ensure => "present",
		content => template("puppetapt/install-puppetapt.sh"),
		owner => "puppet",
		group => "puppet",
		mode => "0700",
		require => [
			File["/etc/puppet/scripts"],
		]
	}

	exec { "install-puppetapt.sh":
		command => "/etc/puppet/scripts/install-puppetapt.sh",
		path => "/bin:/sbin:/usr/bin:/usr/sbin",
		user => "root",
		group => "root",
		logoutput => "on_failure",
		require => [
			File["/etc/puppet/scripts/install-puppetapt.sh"],
		],
	}

}
