## install traefik

1) `helm template traefik traefik/traefik -n traefik > install.yaml`
2) create CRDs file
3) `kubectl apply -f crds.yaml`
4) `kubectl create ns traefik`
5) `kubectl apply -f install.yaml -n traefik`