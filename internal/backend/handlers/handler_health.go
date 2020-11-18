package handlers

import (
	"github.com/gin-gonic/gin"
	"github.com/pipetail/argocd-blueprint/pkg/container"
	"github.com/pipetail/argocd-blueprint/pkg/server"
)

func HealthReady(container container.Container) func(c *gin.Context) {
	return func(c *gin.Context) {

		// check if secrets were obtained
		_, err := container.Secret.GetString("mysqlPassword")
		if err != nil {
			server.HandleInternalServerError(c, "could not get mysqlPassword")
			return
		}

		_, err = container.Secret.GetString("someToken")
		if err != nil {
			server.HandleInternalServerError(c, "could not get someToken")
			return
		}

		_, err = container.Secret.GetString("sqsOrders")
		if err != nil {
			server.HandleInternalServerError(c, "could not get sqsOrders")
			return
		}

		// todo check connection to DBs etc

		// server is ready
		c.JSON(200, gin.H{
			"ready": "ok",
		})
	}
}

func HealthAlive(container container.Container) func(c *gin.Context) {
	return func(c *gin.Context) {
		c.JSON(200, gin.H{
			"alive": "ok",
		})
	}
}
