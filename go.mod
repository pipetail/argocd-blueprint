module github.com/pipetail/argocd-blueprint

go 1.15

replace github.com/pipetail/argocd-blueprint/pkg/server v0.0.0 => ../pkg/server

replace github.com/pipetail/argocd-blueprint/internal/backend/handlers v0.0.0 => ../internal/backend/handlers

require (
	github.com/aws/aws-sdk-go v1.35.30
	github.com/gin-gonic/gin v1.6.3
	github.com/sethvargo/go-envconfig v0.3.2
	google.golang.org/appengine v1.6.7
)
