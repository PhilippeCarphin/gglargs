package gglargs

import (
	"fmt"
	"io"
	"strings"
)

// https://github.com/mfvalin/dot-profile-setup/blob/master/src/cclargs_lite%2B.c

//struct definition
//{
//    char *kle_nom;        /* nom de la clef */
//    char *kle_def1;       /* premiere valeur de defaut */
//    char *kle_def2;       /* deuxieme valeur de defaut */
//    char *kle_val;        /* valeur finale donnee a la clef */
//    char *kle_desc;       /* descripteur pour aide interactive */
//    enum typecle type;
//};

type SettingsDef struct {
	UI          bool
	OnAffiche   bool
	Delimiter   string
	Interp      Interpreter
	ScriptNom   string
	HelpGeneral string
}

type Interpreter int

const (
	Shell Interpreter = iota
	Python
	Perl
)

func (i Interpreter) String() string {
	switch i {
	case Shell:
		return "Shell"
	case Python:
		return "Python"
	case Perl:
		return "Perl"
	default:
		panic("Unknown value for Interpreter")
	}
}

type Definition struct {
	KeyName             string
	KeyDefault          string
	KeyAlternateDefault string
	KeyDescription      string
	KeyType             int

	Value string
}

func GenerateArgumentValues(args []string, w io.Writer) error {
	remainingArgs, _, err := processInitialArgs(args)
	if err != nil {
		return err
	}

	defs, scriptArgs, err := processDefinitions(remainingArgs)
	if err != nil {
		return err
	}

	posargs := parseScriptArgs(defs, scriptArgs)

	exportBASH(defs, posargs, w)

	return nil
}

func GenerateAutocomplete(args []string, w io.Writer) error {

	remainingArgs, settings, err := processInitialArgs(args)
	if err != nil {
		return err
	}

	defs, scriptArgs, err := processDefinitions(remainingArgs)
	if err != nil {
		return err
	}

	_ = parseScriptArgs(defs, scriptArgs)

	exportBashAutocomplete(defs, settings, w)
	return nil
}

func processDefinitions(args []string) (defs []Definition, scriptArgs []string, err error) {
	defs = make([]Definition, 0)
	remainingArgs := args
	for {

		if len(remainingArgs) == 0 {
			return defs, nil, nil
		}

		if remainingArgs[0] == "++" {
			return defs, remainingArgs[1:], nil
		}

		var def Definition
		remainingArgs, def, err = handleOneKey(remainingArgs)
		if err != nil {
			panic(err)
		}
		defs = append(defs, def)
	}
}

func handleOneKey(remainingArgs []string) ([]string, Definition, error) {
	def := Definition{}
	var firstDefaultSet bool // Allow the first default to be ""

	if strings.Contains(remainingArgs[0], "=") {
		tokens := strings.Split(remainingArgs[0], "=")
		def.KeyName = tokens[0][1:]
		def.KeyDefault = tokens[1]
		firstDefaultSet = true
	} else {
		def.KeyName = remainingArgs[0][1:]
	}

	for i := 1; ; i++ {

		// End of the whole argument list
		if i == len(remainingArgs) {
			return nil, def, nil
		}

		arg := remainingArgs[i]

		// End of option definitions or start of next option defintion
		if arg == "++" || strings.HasPrefix(arg, "-") {
			return remainingArgs[i:], def, nil
		}

		// Everything after the key name is either another default or the description
		if strings.HasPrefix(arg, "[") {
			def.KeyDescription = arg
		} else {
			if firstDefaultSet {
				def.KeyAlternateDefault = arg
			} else {
				def.KeyDefault = arg
				def.Value = arg
				firstDefaultSet = true
			}
		}
	}
}

func processInitialArgs(args []string) ([]string, SettingsDef, error) {

	Settings := SettingsDef{}
	var myArgs = args

	// Ditch program name
	myArgs = myArgs[1:]

	if myArgs[0] == "-NOUI" {
		myArgs = myArgs[1:]
		Settings.UI = false
	} else {
		Settings.UI = true
	}

	if myArgs[0] == "-D" {
		Settings.Delimiter = myArgs[1]
		myArgs = myArgs[2:]
	}

	if myArgs[0] == "-python" {
		Settings.Interp = Python
		myArgs = myArgs[1:]
	}

	if myArgs[0] == "-perl" {
		Settings.Interp = Perl
		myArgs = myArgs[1:]
	}

	if myArgs[0] == "-+" {
		Settings.OnAffiche = true
		myArgs = myArgs[1:]
	}

	if myArgs[0] != "-" && myArgs[0] != "++" {
		Settings.ScriptNom = myArgs[0]
		myArgs = myArgs[1:]
	}

	if strings.HasPrefix(myArgs[0], "[") {
		Settings.HelpGeneral = myArgs[0][1 : len(myArgs[0])-1]
		myArgs = myArgs[1:]
	}

	return myArgs, Settings, nil
}

func parseScriptArgs(defs []Definition, scriptArgs []string) []string {
	posargs := make([]string, 0)
	for i := 0; i < len(scriptArgs); i++ {

		arg := scriptArgs[i]
		if !strings.HasPrefix(arg, "-") {
			posargs = append(posargs, arg)
			continue
		}

		found := false
		for defNumber := range defs {
			if defs[defNumber].KeyName == arg[1:] {
				defs[defNumber].Value = scriptArgs[i+1]
				found = true
				i++
				break
			}
		}
		if !found {
			panic(fmt.Errorf("invalid option '%s'", arg))
		}

	}
	return posargs
}

func exportBASH(defs []Definition, posargs []string, w io.Writer) {
	for _, d := range defs {
		fmt.Fprintf(w, "%s='%s'\n", d.KeyName, d.Value)
	}

	fmt.Fprint(w, "set -- \"$@\"")
	for _, arg := range posargs {
		fmt.Fprintf(w, " '%s'", arg)
	}
	fmt.Fprintf(w, "\n")
}

func exportBashAutocomplete(defs []Definition, settings SettingsDef, w io.Writer) {
	// DRIVER FUNCTION
	fmt.Fprintf(w, `#!/bin/bash

__complete_%s() {
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
	COMPREPLY=( $(compgen -W "$(__suggest_%s_candidates)" -- ${cur}))

	return 0
}

__suggest_%s_candidates(){
    # We use the current word to decide what to do
    local cur="${COMP_WORDS[COMP_CWORD]}"
    if __dash_dash_in_words ; then
        return
    fi

    option=$(__get_current_option)
    if [[ "$option" != "" ]] ; then
        __suggest_%s_args_for ${option}
    else
        if [[ "$cur" = -* ]] ; then
            __suggest_%s_options
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

`, settings.ScriptNom, settings.ScriptNom, settings.ScriptNom, settings.ScriptNom, settings.ScriptNom)

	// COMPLETE OPTIONS
	fmt.Fprintf(w, ` __suggest_%s_options(){
	candidates="`, settings.ScriptNom)
	for _, d := range defs {
		fmt.Fprintf(w, " -%s", d.KeyName)
	}
	fmt.Fprintf(w, `"
}

`)

	fmt.Fprintf(w, `__suggest_%s_args_for(){
	case "$1" in 
`, settings.ScriptNom)

	for _, d := range defs {
		fmt.Fprintf(w, `		-%s)
			__suggest_key_%s_values
			;;
`, d.KeyName, d.KeyName)
	}

	fmt.Fprintf(w, `	esac
}

`)

	for _, d := range defs {
		fmt.Fprintf(w, `__suggest_key_%s_values(){
	# User defines completions for options by setting candidates
	candidates=""
}

`, d.KeyName)
	}

	fmt.Fprintf(w, "complete -o default -F __complete_%s %s\n", settings.ScriptNom, settings.ScriptNom)
}
