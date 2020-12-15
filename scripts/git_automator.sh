#!/usr/bin/env bash

set -e

. "${SHELL_ROOT_DIR}/src/eslabs.ini"
. "${SHELL_ROOT_DIR}/src/general.sh"
. "${SHELL_ROOT_DIR}/src/colors.sh"
. "${SHELL_ROOT_DIR}/src/git.sh"

MODE="$1"

if [ "$#" -ge 1 ]; then
    check_if_anything_to_add
    find_remote_git_project
    print_message 'stdout' 'username' "${GITHUB_COMMIT_USERNAME}"
    print_message 'stdout' 'email' "${GITHUB_COMMIT_EMAIL}"
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
        git_add
        git_commit "${MESSAGE}"
        git_push "${BRANCH}"

    fi

    find_last_commit_hash
    print_message 'stdout' 'commit' "$commit_hash"
    print_message 'stdout' 'done'

fi
