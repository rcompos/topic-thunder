#!/usr/bin/env bash

kubectl create namespace argocd
kubectl apply -n argocd -f install.yaml

# sleep 10
# kubectl -n argocd patch svc argocd-server -p '{"spec": {"type": "LoadBalancer"}}'
