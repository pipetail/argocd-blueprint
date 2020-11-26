package main

import (
	"log"

	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/aws/aws-sdk-go/service/sqs"
	"github.com/pipetail/argocd-blueprint/internal/backend/config"
	"github.com/pipetail/argocd-blueprint/internal/backend/handlers"
	"github.com/pipetail/argocd-blueprint/pkg/container"
	"github.com/pipetail/argocd-blueprint/pkg/secret"
	"github.com/pipetail/argocd-blueprint/pkg/server"
)

func main() {
	// create AWS session
	sess := session.Must(session.NewSession())

	// get secret configuration from secrets manager
	s, err := secret.New(sess, "dev/backend", "AWSCURRENT")
	if err != nil {
		log.Fatalf("could not obtain secrets: %s", err)
	}

	// create SQS service
	sqsService := sqs.New(sess)

	// create container for dependencies
	container := container.Container{
		Secret: s,
		Config: config.Get(),
		SQS:    sqsService,
	}

	// create a new Gin server
	e := server.New(container)
	e.MountGET("/", handlers.Root)
	e.MountGET("/_health/ready", handlers.HealthReady)
	e.MountGET("/_health/alive", handlers.HealthAlive)
	e.MountPOST("/api/orders", handlers.OrdersNew)

	// start the main loop
	e.Run()

}
