package main

import (
	"os"
)

func main() {
	if err := run(); err != nil {
		panic(err)
	}
}

func run() error {
	return os.RemoveAll("./account-provider/pkg/generated")
}
