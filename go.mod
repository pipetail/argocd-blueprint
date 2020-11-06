module github.com/pipetail/argocd-blueprint

go 1.15

replace github.com/pipetail/argocd-blueprint/pkg/server v0.0.0 => ../pkg/server

require github.com/gin-gonic/gin v1.6.3
