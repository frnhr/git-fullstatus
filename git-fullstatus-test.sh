#!/usr/bin/env bash

# Running tests with Roundup:
# $ roundup git-fullstatus-test.sh
#
# Installing Roundup:
# https://github.com/bmizerany/roundup/blob/master/INSTALLING#files


describe "Git-FullStatus Tests"

alias gfs='../git-fullstatus'

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
    r="$(printf "$1")"
    e="$(printf "$2")"
    _="




##################################################
Expected:
$e
Received:
$r
##################################################

"
    test "$r" "=" "$e"
}

it_is_running_on_bash_4() {
    version=$(/usr/bin/env bash -c 'echo $BASH_VERSION' | cut -c1-2)
    test_equal "$version" "4."
}

it_has_no_output_for_empty_repo() {
    test_equal `gfs` ""
}

it_sees_a_new_file_just_like_git_status() {
    touch a_file
    test_equal "$(gfs)" "?? a_file"
}

it_sees_added_files_just_like_git_status() {
    touch a_file
    touch b_file
    git add a_file
    test_equal "$(gfs)" \
"\
A  a_file
?? b_file
"
}

it_sees_unmodified_file() {
    touch a_file
    touch b_file
    git add a_file
    git commit -m"commited a file"
    test_equal "$(gfs)" \
"\
   a_file
?? b_file
"
}

it_sees_modified_file() {
    touch a_file
    touch b_file
    git add a_file
    git add b_file
    git commit -m"commited a file and b file"
    echo "somestuff" > a_file
    test_equal "$(gfs)" \
"\
 M a_file
   b_file
"
}

it_sees_it_yet_another_file() {
    touch a_file
    touch b_file
    git add a_file
    git add b_file
    git commit -m"commited a file and b file"
    echo "somestuff" > a_file
    touch c_file
    test_equal "$(gfs)" \
"\
 M a_file
   b_file
?? c_file
"
}

it_ignores_ignored_files() {
    echo "ign_*" > .gitignore
    touch a_file
    touch ign_file
    test_equal "$(gfs)" \
"\
?? .gitignore
?? a_file
"
}

it_handles_space_in_file_names() {
    touch "z_file"
    touch "a file"
    touch "ign file"
    echo "ign*" > .gitignore
    git add .
    git commit -m"some files"
    touch "b file"
    echo "somestuff" > "a file"
    test_equal "$(gfs)" \
"\
   .gitignore
 M a file
?? b file
   z_file
"
}

xit_handles_unicode_chars_in_file_names() {
    # breaks miserably, on multiple points
    touch "z_file"
    touch "š file"
    touch "filešname"
    touch "fileČ"
    git add .
    git commit -m"some files"
    touch "ć file"
    echo "somestuff" > "filešname"
    test_equal "$(gfs)" \
"\
   š file
 M filešname
?? ć file
   z_file
"
}

it_handles_special_chars_in_file_names() {
    touch "z_file"
    touch "file | a"
    touch "file & b"
    touch "file << c"
    touch "file >> d"
    touch "file ;"
    touch "file|a"
    touch "file&b"
    touch "file<<c"
    touch "file>>d"

    test_equal "$(gfs)" "\
?? file & b
?? file ;
?? file << c
?? file >> d
?? file | a
?? file&b
?? file<<c
?? file>>d
?? file|a
?? z_file
"
    git add .
    test_equal "$(gfs)" "\
A  file & b
A  file ;
A  file << c
A  file >> d
A  file | a
A  file&b
A  file<<c
A  file>>d
A  file|a
A  z_file
"
    git commit -m"some files"
    test_equal "$(gfs)" "\
   file & b
   file ;
   file << c
   file >> d
   file | a
   file&b
   file<<c
   file>>d
   file|a
   z_file
"

    echo "a modification" >> "file & b"
    echo "a modification" >> "file ;"
    echo "a modification" >> "file << c"
    echo "a modification" >> "file >> d"
    echo "a modification" >> "file | a"
    echo "a modification" >> "file&b"
    echo "a modification" >> "file<<c"
    echo "a modification" >> "file>>d"
    echo "a modification" >> "file|a"
    echo "a modification" >> "z_file"

    test_equal "$(gfs)" "\
 M file & b
 M file ;
 M file << c
 M file >> d
 M file | a
 M file&b
 M file<<c
 M file>>d
 M file|a
 M z_file
"

}