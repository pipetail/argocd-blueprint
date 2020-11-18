package handlers

import (
	"github.com/gin-gonic/gin"
	"github.com/pipetail/argocd-blueprint/pkg/container"
)

func HealthReady(c container.Container) func(c *gin.Context) {
	return func(c *gin.Context) {
		c.JSON(200, gin.H{
			"ready": "ok",
		})
	}
}

func HealthAlive(c container.Container) func(c *gin.Context) {
	return func(c *gin.Context) {
		c.JSON(200, gin.H{
			"alive": "ok",
		})
	}
}
