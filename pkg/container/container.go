package container

import (
	"github.com/aws/aws-sdk-go/service/sqs"
)

type InputConfig interface {
	GetAddress() string
}

type Secret interface {
	GetMap() map[string]string
	GetString(key string) (string, error)
}

type SQSService interface {
	SendMessage(*sqs.SendMessageInput) (*sqs.SendMessageOutput, error)
}

type Container struct {
	Secret Secret
	Config InputConfig
	SQS    SQSService
}
