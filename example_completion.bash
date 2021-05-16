#!/bin/bash

if ((${#BASH_SOURCE[@]})); then
    #bash
    shell_source=${BASH_SOURCE[0]}
elif ((${#KSH_VERSION[@]})); then
    #ksh
    shell_source=${.sh.file}
fi

sourced_file="$(cd "$(dirname "${shell_source}")"; pwd -P)/$(basename "${shell_source}")"
this_dir=$(dirname "${shell_source}")
__complete_gitlab-runner() {
    # This is the function that will be called when we press TAB.
    #
    # It's purpose is # to examine the current command line (as represented by the 
    # array COMP_WORDS) and to determine what the autocomplete should reply through
    # the array COMPREPLY.
    #
    # This function is organized with subroutines who  are responsible for setting 
    # the 'candidates' variable.
    #
    # The compgen then filters out the candidates that don't begin with the word we are
    # completing. In this case, if '--' is one of the words, we set empty candidates,
    # otherwise, we look at the previous word and delegate # to candidate-setting functions

	COMPREPLY=()

	# We use the current word to filter out suggestions
    local cur="${COMP_WORDS[COMP_CWORD]}"

	# Compgen: takes the list of candidates and selects those matching ${cur}.
	# Once COMPREPLY is set, the shell does the rest.
	COMPREPLY=( $(compgen -W "$(__suggest_candidates)" -- ${cur}))

	return 0
}

__suggest_candidates(){
    # We use the current word to decide what to do
    local cur="${COMP_WORDS[COMP_CWORD]}"
    if __dash_dash_in_words ; then
        return
    fi

    option=$(__get_current_option)
    if [[ "$option" != "" ]] ; then
        __suggest_gitlab-runner_args_for ${option}
    else
        if [[ "$cur" = -* ]] ; then
            __suggest_gitlab-runner_options
        elif [[ $COMP_CWORD == 1 ]] ; then
            __suggest_gitlab-runner_subcommand
        else
            true
        fi
    fi
}

__suggest_gitlab-runner_args_for(){
    case "$1" in 
    --token|-t)
        __suggest_gitlab-runner_tokens
        ;;
    --url|-u)
        __suggest_gitlab-runner_url
        ;;
    --executor)
        __suggest_gitlab-runner_executor
        ;;
    --builds-dir)
        echo $SICI_BUILDS_DIR
        ;;
    --cache-dir)
        echo $SICI_CACHE_DIR
        ;;
    esac
}

__suggest_gitlab-runner_options(){
    echo "--registration-token -r --debug --log-level --cpuprofile --help -h --version -v --token -t --url -u --non-interactive --url --registration-token --description --executor --builds-dir --cache-dir"
}

__suggest_gitlab-runner_subcommand(){
    echo "list run register install uninstall start stop restart status run-single unregister verify artifacts-downloader artifacts-uploader cache-archiver cache-extractor help"
}

__suggest_gitlab-runner_url(){
    echo "https://gitlab.science.gc.ca/ci"
}

__suggest_gitlab-runner_executor(){
    echo "shell docker ssh jobrun ordsoumet"
}
__dash_dash_in_words(){
    for ((i=0;i<COMP_CWORD-1;i++)) ; do
        w=${COMP_WORD[$i]}
        if [[ "$w" == "--" ]] ; then
            return 0
        fi
    done
    return 1
}
__get_current_option(){
	# The word before that
	local prev="${COMP_WORDS[COMP_CWORD-1]}"
    if [[ "$prev" == -* ]] ; then
        echo "$prev"
    fi
}

__suggest_gitlab-runner_tokens(){
    python3 ${this_dir}/get_tokens.py
}

################################################################################
# Arrange for the __phil_complete() function to be called when completing the
# command "to_complete".
################################################################################
complete -o default -F __complete_gitlab-runner \
    gitlab-runner \
    gitlab-runner-science \
    gitlab-ci-multi-runner \
    gitlab-runner-linux-amd64 \
    gitlab-runner-com
