#!/bin/bash

error=0
skip=0
verbose=1

dependencies=("tmux" "awk" "sha256sum")

for dep in ${dependencies[*]}; do
    if ! [[ -x "$(command -v $dep)" ]]; then
        echo "Please install $dep"
        exit 1
    fi
done

vim_versions=("nvim" "vim" "vim-7.4.1689")
tests=("lorem" "forward_jumping" "backward_jumping" "for" "cla" "shell")

cd $(dirname $0)

for vim in ${vim_versions[*]}; do
    if [[ -x "$(command -v $vim)" ]]; then
        echo -n "Running tests for $vim:"
        [[ $verbose != 0 ]] && echo

        for test_name in ${tests[*]}; do
            ./test.sh $test_name $vim $verbose || ((++error))
        done

        if [[ $verbose == 0 ]]; then
            if [[ $error == 0 ]]; then
                echo " OK"
            else
                echo " Error"
            fi
        fi
    else
        echo "$vim is not installed. Skipping"
        ((++skip))
    fi
    echo
done

if [[ $skip == ${#vim_versions[@]} ]]; then
    echo "No tests vere run at all."
    echo "Please install either vim or neovim and run corresponding tests"
    ((++error))
fi

exit $error
