package main

import (
	"os"

	"gitlab.science.gc.ca/phc001/gglargs"
)

func main() {

	err := gglargs.Gglargs(os.Args)
	if err != nil {
		panic(err)
	}

}
