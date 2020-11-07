package config

import (
	"context"
	"log"

	"github.com/sethvargo/go-envconfig"
)

type Config struct {
	Address      string `env:"CONFIG_BACKEND_ADDRESS,default=:8080"`
	LogFormat    string `env:"CONFIG_BACKEND_LOG_FORMAT,default=json"`
	DaprHTTPPort int    `env:"DAPR_HTTP_PORT"`
}

func Get() Config {
	ctx := context.Background()
	var c Config
	if err := envconfig.Process(ctx, &c); err != nil {
		log.Fatalf("could not create config: %s", err)
	}
	return c
}

func (c Config) GetAddress() string {
	return c.Address
}
