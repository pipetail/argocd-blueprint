package server

import "github.com/gin-gonic/gin"

type InputConfig interface {
	GetAddress() string
}

type Secret interface {
	GetMap() map[string]string
	GetString(key string) (string, error)
}

type Server struct {
	Engine *gin.Engine
	Config InputConfig
	Secret Secret
}

func New(c InputConfig, s Secret) Server {
	engine := gin.Default()
	return Server{
		Engine: engine,
		Config: c,
		Secret: s,
	}
}

func (s *Server) MountGET(path string, handler func(Secret) func(*gin.Context)) {
	s.Engine.GET(path, handler(s.Secret))
}

func (s *Server) Run() {
	s.Engine.Run(s.Config.GetAddress())
}
