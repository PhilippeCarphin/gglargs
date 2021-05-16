package gglargs

import (
	"fmt"
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

func Gglargs(args []string) error {
	remainingArgs, settings, err := processInitialArgs(args)
	if err != nil {
		panic(err)
	}

	defs, scriptArgs, err := processDefinitions(remainingArgs)
	if err != nil {
		panic(err)
	}

	for _, d := range defs {
		fmt.Printf("    %+v\n", d)
	}
	fmt.Printf("ScriptArgs : %+v\n", scriptArgs)
	fmt.Printf("Settings : %+v\n", settings)
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
