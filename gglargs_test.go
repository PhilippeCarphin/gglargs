package gglargs

import (
	"strings"
	"testing"
)

func TestNoDefs(t *testing.T) {
	args := []string{"./cclargs", "++", "a", "b", "c"}

	remainingArgs, _, _ := processInitialArgs(args)
	if remainingArgs[0] != "++" {
		t.Fatalf("remainingArgs should start with '++' when it is present and there are no options")
	}
}

func TestScriptNom(t *testing.T) {
	args := []string{"./cclargs", "nomScript", "++", "a", "b", "c"}

	_, settings, _ := processInitialArgs(args)
	if settings.ScriptNom != "nomScript" {
		t.Fatalf("settings.ScriptNom should be 'nomScript', got '%s'", settings.ScriptNom)
	}
}

func TestScriptArgs(t *testing.T) {
	args := []string{"./cclargs", "nomScript", "++", "a", "b", "c"}

	remainingArgs, settings, _ := processInitialArgs(args)
	if settings.ScriptNom != "nomScript" {
		t.Fatalf("settings.ScriptNom should be 'nomScript', got '%s'", settings.ScriptNom)
	}

	_, scriptArgs, _ := processDefinitions(remainingArgs)
	if len(scriptArgs) != 3 {
		t.Fatalf("scriptArgs should have 3 elements : (scriptArgs: %v)", scriptArgs)
	}
}

func TestParseDefinitions(t *testing.T) {
	args := []string{"./cclargs", "nomScript", "-k1", "d1", "[Kle 1]", "++", "-k1", "v1"}
	remainingArgs, _, err := processInitialArgs(args)
	if err != nil {
		t.Fatal(err)
	}

	defs, _, err := processDefinitions(remainingArgs)
	if err != nil {
		t.Fatal(err)
	}

	if defs[0].KeyName != "k1" {
		t.Fatalf("Wrong value for first definition : Expected 'k1', got '%s'", defs[0].KeyName)
	}
}

func TestParseValues(t *testing.T) {
	args := []string{"./cclargs", "nomScript", "-k1", "d1", "[Kle 1]", "++", "-k1", "v1", "v2", "v3"}
	remainingArgs, _, err := processInitialArgs(args)
	if err != nil {
		t.Fatal(err)
	}

	defs, scriptArgs, err := processDefinitions(remainingArgs)
	if err != nil {
		t.Fatal(err)
	}

	posargs := parseScriptArgs(defs, scriptArgs)

	if defs[0].Value != "v1" {
		t.Fatalf("Wrong value for defs[0].Value : expected 'v1', got '%s'", defs[0].Value)
	}

	if len(posargs) != 2 {
		t.Fatalf("Posargs should have had two values, got : '%#v'", posargs)
	}
}

func TestExportBash(t *testing.T) {
	args := []string{"./cclargs", "nomScript", "-k1", "d1", "[Kle 1]", "++", "-k1", "v1", "v2", "v3"}
	remainingArgs, _, err := processInitialArgs(args)
	if err != nil {
		t.Fatal(err)
	}

	defs, scriptArgs, err := processDefinitions(remainingArgs)
	if err != nil {
		t.Fatal(err)
	}

	posargs := parseScriptArgs(defs, scriptArgs)

	s := strings.Builder{}
	exportBASH(defs, posargs, &s)
	expected := "k1='v1'\nset -- \"$@\" 'v2' 'v3'\n"
	if s.String() != expected {
		t.Fatalf("Export BASH produced wrong output, got \n%s", s.String())
	}

}
func TestParseOptions(t *testing.T) {
	args := []string{"cmd/gglargs/", "-NOUI", "-D", "&", "-python", "xflow", "[For complete and up to date information on this command, see the man page by typing 'man xflow']",
		"-d", "", "", "[sequencer date]",
		"-exp=bonjour", "adsf", "[experiment path]",
		"-noautomsg", "0", "1", "[value 1 means no auto message display]",
		"-debug", "0", "1", "[debug message]",
		"++", "asdf", "second script arg", "third",
	}

	remainingArgs, settings, err := processInitialArgs(args)
	if err != nil {
		panic(err)
	}
	if settings.UI != false {
		t.Fail()
	}

	if settings.Interp != Python {
		t.Fail()
	}

	defs, scriptArgs, err := processDefinitions(remainingArgs)
	if err != nil {
		panic(err)
	}

	if len(defs) != 4 {
		t.Fail()
	}

	if len(scriptArgs) != 3 {
		t.Fail()
	}
}
