package handlers

import (
	"github.com/gin-gonic/gin"
	"github.com/pipetail/argocd-blueprint/pkg/server"
)

func HealthReady(secret server.Secret) func(c *gin.Context) {
	return func(c *gin.Context) {
		c.JSON(200, gin.H{
			"ready": "ok",
		})
	}
}

func HealthAlive(secret server.Secret) func(c *gin.Context) {
	return func(c *gin.Context) {
		c.JSON(200, gin.H{
			"alive": "ok",
		})
	}
}
