#!/usr/bin/env bash

set -e

. "${ELISE_ROOT_DIR}/src/elise.sh"
. "${ELISE_ROOT_DIR}/src/colors.sh"
. "${ELISE_ROOT_DIR}/src/general.sh"
. "${ELISE_ROOT_DIR}/src/git.sh"

MODE="$1"

if [ "$#" -ge 1 ]; then
    permissions_and_dos_line_endings '/root'
    check_if_anything_to_add
    find_remote_git_project
    count_commits
    print_message 'stdout' 'username' "$(git config -l | egrep ^user.name | cut -d'=' -f2)"
    print_message 'stdout' 'email' "$(git config -l | egrep ^user.email | cut -d'=' -f2)"
    print_message 'stdout' 'remote url' "$remote_url"

    if [ "${MODE}" == "add" ]; then
        git_add

    elif [ "${MODE}" == "commit" ]; then
        MESSAGE="$2"
        print_message 'stdout' 'message' "${MESSAGE}"
        git_commit "${MESSAGE}"

    elif [ "${MODE}" == "push" ]; then
        BRANCH="$2"
        print_message 'stdout' 'branch' "${BRANCH}"
        git_push "${BRANCH}"

    elif [ "${MODE}" == "all" ]; then
        BRANCH="${GITHUB_DEFAULT_COMMIT_BRANCH}"

        if [ ! -z "$2" ]; then
            MESSAGE="$2"

        else
            MESSAGE="${GITHUB_DEFAULT_COMMIT_MESSAGE}"

        fi

        print_message 'stdout' 'branch' "${BRANCH}"
        print_message 'stdout' 'message' "${MESSAGE}"
        print_message 'stdout' 'commit number' "$(echo $number_of_commits+1 | bc -l)"
        git_add
        git_commit "${MESSAGE}"
        git_push "${BRANCH}"

    fi

    find_last_commit_hash
    print_message 'stdout' 'commit hash' "$commit_hash"
    print_message 'stdout' 'done'

fi
