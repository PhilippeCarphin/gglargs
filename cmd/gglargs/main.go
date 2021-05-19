package main

import (
	"os"

	"gitlab.com/philippecarphin/gglargs"
)

func main() {

	err := gglargs.Gglargs(os.Args, os.Stdout)
	if err != nil {
		panic(err)
	}

}
