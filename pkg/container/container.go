package container

type InputConfig interface {
	GetAddress() string
}

type Secret interface {
	GetMap() map[string]string
	GetString(key string) (string, error)
}

type Container struct {
	Secret Secret
	Config InputConfig

	// TBD add database etc.
}
