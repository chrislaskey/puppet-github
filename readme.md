About
================================================================================

The `github` module makes it simple to clone a github repository and keep it in
sync with the main branch on github.

```puppet
	github::pull { "/local/path/including/repo":
		remote_user => "github_user",
		remote_repository => "github_repository_name",
		remote_branch => "master",
		remote_name => "origin",
		ensure => "latest",
  	}
```

Parameters
----------

##### `local_path`

The path on the local machine where the repository should be saved. Must be
unique.

##### `remote_user`

The github user name. E.g., github.com/remote_user/remote_repository

##### `remote_repository`

The github repository name. E.g., github.com/remote_user/remote_repository

##### `remote_branch`

The name of the remote branch. Default value is `master`.

##### `remote_name`

The name of the remote. Default value is `origin`.

##### `ensure`

Determines whether the repository should be updated:
- "latest" (default) will execute a `git pull` every time the puppet catalog is
  run.
- "present" will execute the initial `git clone` but never a `git pull`

Todo
----

- Add "absent" as an `ensure` value which removes local repository
- Generalize from github to git. Include github specific code as a sub-branch


License
================================================================================

All code written by me is released under MIT license. See the attached
license.txt file for more information, including commentary on license choice.
