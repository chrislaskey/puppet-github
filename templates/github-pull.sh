#!/usr/bin/env bash

remote_name="<%= remote_name %>"
remote_branch="<%= remote_branch %>"
remote_url="https://github.com/<%= remote_user %>/<%= remote_repository %>"
target_path="<%= target_path %>"
target_repo="${target_path}/.git"
update_if_exists=<%= update_if_exists %>

set -o nounset
set -o errtrace
set -o errexit
set -o pipefail

# General functions

log () {
	printf "$*\n"
}

error () {
	log "ERROR: " "$*\n"
	exit 1
}

verify_root_privileges () {
	if [[ $EUID -ne 0 ]]; then
		fail "Requires root privileges."
	fi
}

# Application functions

if_does_not_exist_then_clone_and_exit () {
	if [[ ! -d "${target_path}/.git" ]]; then
		if ! git clone -o "$remote_name" -b "$remote_branch" "$remote_url" "$target_path"; then
			error "Could not clone git repository. Tried command 'git clone -o ${remote_name} -b ${remote_branch} ${remote_url} ${target_path}'"
		fi
		exit 0
	fi
}

if_do_not_update_is_set_then_exit () {
	if ! $update_if_exists; then
		log "Notice: Clone not needed, local directory already exists. Do not update set. Exiting successfully with no action."
		exit 0
	fi
}

pull_latest_from_github () {
	# Could fail for a variety of reasons:
	# - Uncommitted local changes
	# - Missing branch
	# -	Connectivity issues
	# Rather than try to catch each, let command fail and output errors.

	if ! git pull "$remote_name" "$remote_branch":"$remote_branch"; then
		echo "git --git-dir ${target_repo} pull ${remote_name} ${remote_branch}:${remote_branch};"
		error "Repository already exists locally. Failed to pull latest version from github."
	fi
}

# Execute applicatoin

if_does_not_exist_then_clone_and_exit
if_do_not_update_is_set_then_exit
pull_latest_from_github
