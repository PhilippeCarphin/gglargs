package main

import (
	"os"

	"gitlab.com/philippecarphin/gglargs"
)

func main() {

	autocomplete := os.Getenv("GGLARGS_GENERATE_AUTOCOMPLETE")

	if autocomplete != "" {
		err := gglargs.GenerateAutocomplete(os.Args, os.Stdout)
		if err != nil {
			panic(err)
		}
	} else {
		err := gglargs.GenerateArgumentValues(os.Args, os.Stdout)
		if err != nil {
			panic(err)
		}
	}

}
