package handlers

import (
	"fmt"

	"github.com/gin-gonic/gin"
	"github.com/pipetail/argocd-blueprint/pkg/secret"
)

func Root(c *gin.Context) {

	s, err := secret.Get("dev/backend", "AWSCURRENT")
	if err != nil {
		panic(fmt.Sprintf("could not receive secrets: %s", err))
	}

	c.JSON(200, gin.H{
		"hello": s.MySQLPassword,
	})
}
