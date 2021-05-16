#!/bin/bash

__complete_nomScript() {
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
	COMPREPLY=( $(compgen -W "$(__suggest_nomScript_candidates)" -- ${cur}))

	return 0
}

__suggest_nomScript_candidates(){
    # We use the current word to decide what to do
    local cur="${COMP_WORDS[COMP_CWORD]}"
    if __dash_dash_in_words ; then
        return
    fi

    option=$(__get_current_option)
    if [[ "$option" != "" ]] ; then
        __suggest_nomScript_args_for ${option}
    else
        if [[ "$cur" = -* ]] ; then
            __suggest_nomScript_options
        fi
    fi

    echo "$candidates"
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

 __suggest_nomScript_options(){
	candidates=" -k1 -k2"
}

__suggest_nomScript_args_for(){
	case "$1" in 
		-k1)
			__suggest_key_k1_values
			;;
		-k2)
			__suggest_key_k2_values
			;;
	esac
}

__suggest_key_k1_values(){
	# User defines completions for options by setting candidates
	candidates=""
}

__suggest_key_k2_values(){
	# User defines completions for options by setting candidates
	candidates=""
}

complete -o default -F __complete_nomScript nomScript
