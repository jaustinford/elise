####################################################
# git wrapper
####################################################

git_add () {
    git add --all .
}

git_commit () {
    git commit -m "$1"
}

git_push () {
    git push -u origin $1 --quiet
}

####################################################
# git definitions
####################################################

find_remote_git_project () {
    remote_url=$(git config -l \
        | grep remote.origin.url \
        | cut -d":" -f2)
}

find_last_commit_hash () {
    commit_hash=$(git log \
        | egrep '^commit' \
        | head -1 \
        | awk '{print $2}')
}

count_commits () {
    number_of_commits=$(git log | egrep '^commit\ ' | wc -l)
}

####################################################
# error handles
####################################################

check_if_anything_to_add () {
    if [ "$(git status | tail -1)" == 'nothing to commit, working tree clean' ]; then
        print_message 'stderr' 'nothing to commit'
        exit 1

    fi
}
