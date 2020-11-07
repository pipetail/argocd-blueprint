package main

import (
	"github.com/pipetail/argocd-blueprint/internal/backend/config"
	"github.com/pipetail/argocd-blueprint/internal/backend/handlers"
	"github.com/pipetail/argocd-blueprint/pkg/server"
)

func main() {
	// create config from environment variables
	// this is gonna stop exexution if something's missing
	c := config.Get()

	// create a new Gin server
	s := server.New(c)
	s.MountGET("/", handlers.Root)

	// start the main loop
	s.Run()
}
