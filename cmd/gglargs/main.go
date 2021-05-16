package main

import (
	"fmt"
	"os"

	"gitlab.com/philippecarphin/gglargs"
)

func main() {

	autocomplete := os.Getenv("GGLARGS_GENERATE_AUTOCOMPLETE")

	if autocomplete != "" {
		fmt.Printf("PISS BUCKET\n")
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
