package handlers

import (
	"github.com/gin-gonic/gin"
	"github.com/pipetail/argocd-blueprint/pkg/server"
)

func Root(secret server.Secret) func(c *gin.Context) {
	return func(c *gin.Context) {
		// mysqlPassword, err := secret.GetString("mysqlPassword")
		// if err != nil {
		// 	server.HandleInternalServerError(c, "could not get mysqlPassword")
		// 	return
		// }

		// someToken, err := secret.GetString("someToken")
		// if err != nil {
		// 	server.HandleInternalServerError(c, "could not get someToken")
		// 	return
		// }

		c.JSON(200, gin.H{
			"hello": "world",
		})
	}
}
