#!/bin/bash
#

__complete_ord_soumet_gglargs_call.sh() {
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
	COMPREPLY=( $(compgen -W "$(__suggest_ord_soumet_gglargs_call.sh_candidates)" -- ${cur}))

	return 0
}

__suggest_ord_soumet_gglargs_call.sh_candidates(){
    # We use the current word to decide what to do
    local cur="${COMP_WORDS[COMP_CWORD]}"
    if __dash_dash_in_words ; then
        return
    fi

    option=$(__get_current_option)
    if [[ "$option" != "" ]] ; then
        __suggest_ord_soumet_gglargs_call.sh_args_for ${option}
    else
        if [[ "$cur" = -* ]] ; then
            __suggest_ord_soumet_gglargs_call.sh_options
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

 __suggest_ord_soumet_gglargs_call.sh_options(){
	candidates=" -addstep -altcfgdir -args -as -c -clone -cm -coschedule -cpus -custom -d_ -display -e -epilog -firststep -geom -image -immediate -iojob -jn -jobcfg -jobfile -jobtar -keep -l -laststep -listing -m -mach_ -mail -mpi -node -noendwrap -norerun -norset -nosubmit -notify -o -op -p -postfix -ppid -preempt -prefix -prio -project -prolog -q -queue -rerun -resid -rsrc -retries -seqno -share -shell -smt -splitstd -sq -ssmuse -step -sys -t -tag -threads -tmpfs -v -w -waste -with -wrapdir -xterm"
}

__suggest_ord_soumet_gglargs_call.sh_args_for(){
	case "$1" in 
		-addstep)
			__suggest_key_addstep_values
			;;
		-altcfgdir)
			__suggest_key_altcfgdir_values
			;;
		-args)
			__suggest_key_args_values
			;;
		-as)
			__suggest_key_as_values
			;;
		-c)
			__suggest_key_c_values
			;;
		-clone)
			__suggest_key_clone_values
			;;
		-cm)
			__suggest_key_cm_values
			;;
		-coschedule)
			__suggest_key_coschedule_values
			;;
		-cpus)
			__suggest_key_cpus_values
			;;
		-custom)
			__suggest_key_custom_values
			;;
		-d_)
			__suggest_key_d__values
			;;
		-display)
			__suggest_key_display_values
			;;
		-e)
			__suggest_key_e_values
			;;
		-epilog)
			__suggest_key_epilog_values
			;;
		-firststep)
			__suggest_key_firststep_values
			;;
		-geom)
			__suggest_key_geom_values
			;;
		-image)
			__suggest_key_image_values
			;;
		-immediate)
			__suggest_key_immediate_values
			;;
		-iojob)
			__suggest_key_iojob_values
			;;
		-jn)
			__suggest_key_jn_values
			;;
		-jobcfg)
			__suggest_key_jobcfg_values
			;;
		-jobfile)
			__suggest_key_jobfile_values
			;;
		-jobtar)
			__suggest_key_jobtar_values
			;;
		-keep)
			__suggest_key_keep_values
			;;
		-l)
			__suggest_key_l_values
			;;
		-laststep)
			__suggest_key_laststep_values
			;;
		-listing)
			__suggest_key_listing_values
			;;
		-m)
			__suggest_key_m_values
			;;
		-mach_)
			__suggest_key_mach__values
			;;
		-mail)
			__suggest_key_mail_values
			;;
		-mpi)
			__suggest_key_mpi_values
			;;
		-node)
			__suggest_key_node_values
			;;
		-noendwrap)
			__suggest_key_noendwrap_values
			;;
		-norerun)
			__suggest_key_norerun_values
			;;
		-norset)
			__suggest_key_norset_values
			;;
		-nosubmit)
			__suggest_key_nosubmit_values
			;;
		-notify)
			__suggest_key_notify_values
			;;
		-o)
			__suggest_key_o_values
			;;
		-op)
			__suggest_key_op_values
			;;
		-p)
			__suggest_key_p_values
			;;
		-postfix)
			__suggest_key_postfix_values
			;;
		-ppid)
			__suggest_key_ppid_values
			;;
		-preempt)
			__suggest_key_preempt_values
			;;
		-prefix)
			__suggest_key_prefix_values
			;;
		-prio)
			__suggest_key_prio_values
			;;
		-project)
			__suggest_key_project_values
			;;
		-prolog)
			__suggest_key_prolog_values
			;;
		-q)
			__suggest_key_q_values
			;;
		-queue)
			__suggest_key_queue_values
			;;
		-rerun)
			__suggest_key_rerun_values
			;;
		-resid)
			__suggest_key_resid_values
			;;
		-rsrc)
			__suggest_key_rsrc_values
			;;
		-retries)
			__suggest_key_retries_values
			;;
		-seqno)
			__suggest_key_seqno_values
			;;
		-share)
			__suggest_key_share_values
			;;
		-shell)
			__suggest_key_shell_values
			;;
		-smt)
			__suggest_key_smt_values
			;;
		-splitstd)
			__suggest_key_splitstd_values
			;;
		-sq)
			__suggest_key_sq_values
			;;
		-ssmuse)
			__suggest_key_ssmuse_values
			;;
		-step)
			__suggest_key_step_values
			;;
		-sys)
			__suggest_key_sys_values
			;;
		-t)
			__suggest_key_t_values
			;;
		-tag)
			__suggest_key_tag_values
			;;
		-threads)
			__suggest_key_threads_values
			;;
		-tmpfs)
			__suggest_key_tmpfs_values
			;;
		-v)
			__suggest_key_v_values
			;;
		-w)
			__suggest_key_w_values
			;;
		-waste)
			__suggest_key_waste_values
			;;
		-with)
			__suggest_key_with_values
			;;
		-wrapdir)
			__suggest_key_wrapdir_values
			;;
		-xterm)
			__suggest_key_xterm_values
			;;
	esac
}

__suggest_key_addstep_values(){
	# User defines completions for options by setting candidates
	candidates=""
}

__suggest_key_altcfgdir_values(){
	# User defines completions for options by setting candidates
	candidates=""
}

__suggest_key_args_values(){
	# User defines completions for options by setting candidates
	candidates=""
}

__suggest_key_as_values(){
	# User defines completions for options by setting candidates
	candidates=""
}

__suggest_key_c_values(){
	# User defines completions for options by setting candidates
	candidates=""
}

__suggest_key_clone_values(){
	# User defines completions for options by setting candidates
	candidates=""
}

__suggest_key_cm_values(){
	# User defines completions for options by setting candidates
	candidates=""
}

__suggest_key_coschedule_values(){
	# User defines completions for options by setting candidates
	candidates=""
}

__suggest_key_cpus_values(){
	# User defines completions for options by setting candidates
	candidates=""
}

__suggest_key_custom_values(){
	# User defines completions for options by setting candidates
	candidates=""
}

__suggest_key_d__values(){
	# User defines completions for options by setting candidates
	candidates=""
}

__suggest_key_display_values(){
	# User defines completions for options by setting candidates
	candidates=""
}

__suggest_key_e_values(){
	# User defines completions for options by setting candidates
	candidates=""
}

__suggest_key_epilog_values(){
	# User defines completions for options by setting candidates
	candidates=""
}

__suggest_key_firststep_values(){
	# User defines completions for options by setting candidates
	candidates=""
}

__suggest_key_geom_values(){
	# User defines completions for options by setting candidates
	candidates=""
}

__suggest_key_image_values(){
	# User defines completions for options by setting candidates
	candidates=""
}

__suggest_key_immediate_values(){
	# User defines completions for options by setting candidates
	candidates=""
}

__suggest_key_iojob_values(){
	# User defines completions for options by setting candidates
	candidates=""
}

__suggest_key_jn_values(){
	# User defines completions for options by setting candidates
	candidates=""
}

__suggest_key_jobcfg_values(){
	# User defines completions for options by setting candidates
	candidates=""
}

__suggest_key_jobfile_values(){
	# User defines completions for options by setting candidates
	candidates=""
}

__suggest_key_jobtar_values(){
	# User defines completions for options by setting candidates
	candidates=""
}

__suggest_key_keep_values(){
	# User defines completions for options by setting candidates
	candidates=""
}

__suggest_key_l_values(){
	# User defines completions for options by setting candidates
	candidates=""
}

__suggest_key_laststep_values(){
	# User defines completions for options by setting candidates
	candidates=""
}

__suggest_key_listing_values(){
	# User defines completions for options by setting candidates
	candidates=""
}

__suggest_key_m_values(){
	# User defines completions for options by setting candidates
	candidates=""
}

__suggest_key_mach__values(){
	# User defines completions for options by setting candidates
	candidates=""
}

__suggest_key_mail_values(){
	# User defines completions for options by setting candidates
	candidates=""
}

__suggest_key_mpi_values(){
	# User defines completions for options by setting candidates
	candidates=""
}

__suggest_key_node_values(){
	# User defines completions for options by setting candidates
	candidates=""
}

__suggest_key_noendwrap_values(){
	# User defines completions for options by setting candidates
	candidates=""
}

__suggest_key_norerun_values(){
	# User defines completions for options by setting candidates
	candidates=""
}

__suggest_key_norset_values(){
	# User defines completions for options by setting candidates
	candidates=""
}

__suggest_key_nosubmit_values(){
	# User defines completions for options by setting candidates
	candidates=""
}

__suggest_key_notify_values(){
	# User defines completions for options by setting candidates
	candidates=""
}

__suggest_key_o_values(){
	# User defines completions for options by setting candidates
	candidates=""
}

__suggest_key_op_values(){
	# User defines completions for options by setting candidates
	candidates=""
}

__suggest_key_p_values(){
	# User defines completions for options by setting candidates
	candidates=""
}

__suggest_key_postfix_values(){
	# User defines completions for options by setting candidates
	candidates=""
}

__suggest_key_ppid_values(){
	# User defines completions for options by setting candidates
	candidates=""
}

__suggest_key_preempt_values(){
	# User defines completions for options by setting candidates
	candidates=""
}

__suggest_key_prefix_values(){
	# User defines completions for options by setting candidates
	candidates=""
}

__suggest_key_prio_values(){
	# User defines completions for options by setting candidates
	candidates=""
}

__suggest_key_project_values(){
	# User defines completions for options by setting candidates
	candidates=""
}

__suggest_key_prolog_values(){
	# User defines completions for options by setting candidates
	candidates=""
}

__suggest_key_q_values(){
	# User defines completions for options by setting candidates
	candidates=""
}

__suggest_key_queue_values(){
	# User defines completions for options by setting candidates
	candidates=""
}

__suggest_key_rerun_values(){
	# User defines completions for options by setting candidates
	candidates=""
}

__suggest_key_resid_values(){
	# User defines completions for options by setting candidates
	candidates=""
}

__suggest_key_rsrc_values(){
	# User defines completions for options by setting candidates
	candidates=""
}

__suggest_key_retries_values(){
	# User defines completions for options by setting candidates
	candidates=""
}

__suggest_key_seqno_values(){
	# User defines completions for options by setting candidates
	candidates=""
}

__suggest_key_share_values(){
	# User defines completions for options by setting candidates
	candidates=""
}

__suggest_key_shell_values(){
	# User defines completions for options by setting candidates
	candidates=""
}

__suggest_key_smt_values(){
	# User defines completions for options by setting candidates
	candidates=""
}

__suggest_key_splitstd_values(){
	# User defines completions for options by setting candidates
	candidates=""
}

__suggest_key_sq_values(){
	# User defines completions for options by setting candidates
	candidates=""
}

__suggest_key_ssmuse_values(){
	# User defines completions for options by setting candidates
	candidates=""
}

__suggest_key_step_values(){
	# User defines completions for options by setting candidates
	candidates=""
}

__suggest_key_sys_values(){
	# User defines completions for options by setting candidates
	candidates=""
}

__suggest_key_t_values(){
	# User defines completions for options by setting candidates
	candidates=""
}

__suggest_key_tag_values(){
	# User defines completions for options by setting candidates
	candidates=""
}

__suggest_key_threads_values(){
	# User defines completions for options by setting candidates
	candidates=""
}

__suggest_key_tmpfs_values(){
	# User defines completions for options by setting candidates
	candidates=""
}

__suggest_key_v_values(){
	# User defines completions for options by setting candidates
	candidates=""
}

__suggest_key_w_values(){
	# User defines completions for options by setting candidates
	candidates=""
}

__suggest_key_waste_values(){
	# User defines completions for options by setting candidates
	candidates=""
}

__suggest_key_with_values(){
	# User defines completions for options by setting candidates
	candidates=""
}

__suggest_key_wrapdir_values(){
	# User defines completions for options by setting candidates
	candidates=""
}

__suggest_key_xterm_values(){
	# User defines completions for options by setting candidates
	candidates=""
}

complete -o default -F __complete_ord_soumet_gglargs_call.sh ord_soumet
