#!/usr/bin/env bash

describe "Clean Porcelain Tests"

alias gcp='../git-clean-porcelain'

before() {
    rm -fr ./tests
    mkdir ./tests
    cd ./tests
    git init --quiet
    git status
}

after() {
    cd ..
    rm -fr ./tests
}


test_equal() {
    echo "RECEIVED:\n$1\nEXPECTED:\n$2"
    test "$(printf "$1")" "=" "$(printf "$2")"
}

it_runs_on_bash_4() {
    version=$(/usr/bin/env bash -c 'echo $BASH_VERSION' | cut -c1-2)
    test_equal "$version" "4."
}
it_has_no_output_for_empty_repo() {
    test_equal `gcp` ""
}

it_sees_a_new_file_just_like_git_status() {
    touch a_file
    test_equal "$(gcp)" "?? a_file"
}

it_sees_added_files_just_like_git_status() {
    touch a_file
    touch b_file
    git add a_file
    test_equal "$(gcp)" "A  a_file\n?? b_file"
}

it_sees_unmodified_file() {
    touch a_file
    touch b_file
    git add a_file
    git commit -m"commited a file"
    test_equal "$(gcp)" "   a_file\n?? b_file"
}

it_sees_modified_file() {
    touch a_file
    touch b_file
    git add a_file
    git add b_file
    git commit -m"commited a file and b file"
    echo "somestuff" > a_file
    test_equal "$(gcp)" " M a_file\n   b_file"
}

it_sees_it_yet_another_file() {
    touch a_file
    touch b_file
    git add a_file
    git add b_file
    git commit -m"commited a file and b file"
    echo "somestuff" > a_file
    touch c_file
    test_equal "$(gcp)" " M a_file\n   b_file\n?? c_file"
}

it_ignores_ignored_files() {
    echo "ign_*" > .gitignore
    touch a_file
    touch ign_file
    test_equal "$(gcp)" "?? a_file\n?? .gitignore"
}
