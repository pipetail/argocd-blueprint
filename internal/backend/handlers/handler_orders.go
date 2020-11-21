package handlers

import (
	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/service/sqs"
	"github.com/gin-gonic/gin"
	"github.com/pipetail/argocd-blueprint/pkg/container"
	"github.com/pipetail/argocd-blueprint/pkg/server"
)

func OrdersNew(container container.Container) func(c *gin.Context) {
	return func(c *gin.Context) {

		// get queue name from application secrets / configuration
		queueUrl, err := container.Secret.GetString("sqsOrders")
		if err != nil {
			server.HandleInternalServerError(c, "could not get sqsOrders")
			return
		}

		// send a new message to SQS queue
		_, err = container.SQS.SendMessage(&sqs.SendMessageInput{
			MessageBody: aws.String("test bla bla bla"),
			QueueUrl:    aws.String(queueUrl),
		})
		if err != nil {
			server.HandleInternalServerError(c, "could not send message to queue")
			return
		}

		c.JSON(200, gin.H{
			"hello": "world",
		})
	}
}
