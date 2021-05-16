package main

import (
	"os"

	"gitlab.science.gc.ca/phc001/gglargs"
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
