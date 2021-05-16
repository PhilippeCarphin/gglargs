package main

import (
	"fmt"
	"strings"

	"os"

	"gitlab.science.gc.ca/phc001/gglargs"
)

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

func main() {

	remainingArgs, settings, err := processInitialArgs(os.Args)
	if err != nil {
		panic(err)
	}

	defs, scriptArgs, err := processDefinitions(remainingArgs)
	if err != nil {
		panic(err)
	}

	fmt.Printf("Parsed definitions")
	for _, d := range defs {
		fmt.Printf("    %+v\n", d)
	}
	fmt.Printf("ScriptArgs : %+v", scriptArgs)
	fmt.Printf("Settings : %+v\n", settings)
}
func processDefinitions(args []string) (defs []gglargs.Definition, scriptArgs []string, err error) {
	defs = make([]gglargs.Definition, 0)
	var remainingArgs = args
	for len(args) > 0 {

		if remainingArgs[0] == "++" {
			break
		}

		def := gglargs.Definition{
			KeyName:             remainingArgs[0],
			KeyDefault:          remainingArgs[1],
			KeyAlternateDefault: remainingArgs[2],
			KeyDescription:      remainingArgs[3],
		}
		defs = append(defs, def)
		remainingArgs = remainingArgs[4:]
	}

	scriptArgs = remainingArgs[1:]
	return
}

func iniList() error {
	return nil
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

	if myArgs[0] != "-" {
		Settings.ScriptNom = myArgs[0]
		myArgs = myArgs[1:]
	}

	if strings.HasPrefix(myArgs[0], "[") {
		Settings.HelpGeneral = myArgs[0][1 : len(myArgs[0])-1]
		myArgs = myArgs[1:]
	}

	return myArgs, Settings, nil
}
