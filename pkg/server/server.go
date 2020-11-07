package server

import "github.com/gin-gonic/gin"

type InputConfig interface {
	GetAddress() string
}

type Server struct {
	Engine *gin.Engine
	Config InputConfig
	// Secrets["nameOfSecret"] = "/v1.0/secrets/kubernetes/my-secret"
	Secrets map[string]string
}

func New(c InputConfig) Server {
	engine := gin.Default()
	return Server{
		Engine: engine,
		Config: c,
	}
}

func (s *Server) MountGET(path string, handler func(*gin.Context)) {
	s.Engine.GET(path, handler)
}

func (s *Server) Run() {
	s.Engine.Run(s.Config.GetAddress())
}
