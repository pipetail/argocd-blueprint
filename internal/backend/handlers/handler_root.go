package handlers

import (
	"github.com/gin-gonic/gin"
	"github.com/pipetail/argocd-blueprint/pkg/server"
)

func Root(secret server.Secret) func(c *gin.Context) {
	return func(c *gin.Context) {
		c.JSON(200, gin.H{
			"hello": secret.GetMap(),
		})
	}
}
