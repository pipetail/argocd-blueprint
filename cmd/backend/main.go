package main

import (
	"log"

	"github.com/pipetail/argocd-blueprint/internal/backend/config"
	"github.com/pipetail/argocd-blueprint/internal/backend/handlers"
	"github.com/pipetail/argocd-blueprint/pkg/container"
	"github.com/pipetail/argocd-blueprint/pkg/secret"
	"github.com/pipetail/argocd-blueprint/pkg/server"
)

func main() {
	// create config from environment variables
	// this is gonna stop exexution if something's missing
	c := config.Get()

	// get secret configuration from secrets manager
	s, err := secret.New("dev/backend", "AWSCURRENT")
	if err != nil {
		log.Fatalf("could not obtain secrets: %s", err)
	}

	// create container for dependencies
	container := container.Container{
		Secret: s,
	}

	// create a new Gin server
	e := server.New(container)
	e.MountGET("/", handlers.Root)
	e.MountGET("/_health/ready", handlers.HealthReady)
	e.MountGET("/_health/alive", handlers.HealthAlive)

	// start the main loop
	e.Run()
}
