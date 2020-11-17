package secret

import (
	"encoding/json"
	"fmt"
	"os"

	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/aws/aws-sdk-go/service/secretsmanager"
)

type Secret struct {
	MySQLPassword string `json:"mysqlPassword"`
}

func Get(name string, version string) (Secret, error) {
	region := os.Getenv("AWS_REGION")
	secret := Secret{}

	svc := secretsmanager.New(session.New(&aws.Config{
		Region: &region,
	}))

	input := &secretsmanager.GetSecretValueInput{
		SecretId:     aws.String(name),
		VersionStage: aws.String(version),
	}

	result, err := svc.GetSecretValue(input)
	if err != nil {
		return secret, fmt.Errorf("could not obtain secret: %s", err)
	}

	err = json.Unmarshal([]byte(*result.SecretString), &secret)
	if err != nil {
		return secret, fmt.Errorf("could not unmarshal secret: %s", err)
	}

	return secret, nil
}
