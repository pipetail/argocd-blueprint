# Install

1) `kubectl create ns argocd`
2) `wget https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml`
3) `kubectl apply -f install.yaml -n argocd`

