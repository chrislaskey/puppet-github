define github::pull (
	$local_path = $title,
	# https://github.com/<remote_user>/<remote_repo>
	$remote_user,
	$remote_repository,
	$remote_branch = "master",
	$remote_name = "origin",
	$ensure = "latest",
){

	$target_path = regsubst($local_path, "/^", "")

	# Strip /'s from the local path for a unique identifier.
	# Note: delete function from stdlib does not work correctly,
	# modifying both the input and output variable. Using regsubst
	# instead as it functions as expected.
	$uid = regsubst($local_path, "/", "-", "G")
	$unique_file_path = "/etc/puppet/scripts/github-pull-${uid}.sh"

	if $ensure == "latest" {
		$update_if_exists = true
	}else{
		$update_if_exists = false
	}

	if ! defined( Package["git"] ){
		package { "git":
			ensure => "latest",
		}
	}

	if ! defined( File["/etc/puppet/scripts"] ){
		file { "/etc/puppet/scripts":
			ensure => "directory",
			owner => "puppet",
			group => "puppet",
			mode => "0700",
		}
	}

	file { $unique_file_path:
		ensure => "present",
		content => template("github/github-pull.sh"),
		owner => "puppet",
		group => "puppet",
		mode => "0700",
		require => [
			Package["git"],
			File["/etc/puppet/scripts"],
		]
	}

	exec { $unique_file_path:
		path => "/bin:/sbin:/usr/bin:/usr/sbin",
		user => "root",
		group => "root",
		logoutput => "on_failure",
		require => [
			File[$unique_file_path],
		],
	}

}
