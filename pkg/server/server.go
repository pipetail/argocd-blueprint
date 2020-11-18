package server

import (
	"github.com/gin-gonic/gin"
	"github.com/pipetail/argocd-blueprint/pkg/container"
)

type Server struct {
	Engine    *gin.Engine
	Container container.Container
}

func New(c container.Container) Server {
	engine := gin.Default()
	return Server{
		Engine:    engine,
		Container: c,
	}
}

func (s *Server) MountGET(path string, handler func(container.Container) func(*gin.Context)) {
	s.Engine.GET(path, handler(s.Container))
}

func (s *Server) Run() {
	s.Engine.Run(s.Container.Config.GetAddress())
}

func HandleInternalServerError(c *gin.Context, message string) {
	c.JSON(500, gin.H{
		"status":  "error",
		"code":    500,
		"message": message,
	})
}
