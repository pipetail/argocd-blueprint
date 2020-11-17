# install

1) get and install CRDs https://github.com/dapr/dapr/tree/master/charts/dapr/crds
2) `helm repo add dapr https://dapr.github.io/helm-charts/`
3) `helm template dapr dapr/dapr --namespace dapr-system > install.yaml`
4) `kubectl create ns dapr-system`
5) `kubectl apply -f install.yaml -n dapr-system`
