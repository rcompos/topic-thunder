#!/usr/bin/env bash
#
# Deploy ArgoCD
#
# Usage: DEPLOY_ENV=data-production-sol ./install-argocd.sh
#

set +x

function usage(){
  echo -e "usage: DEPLOY_ENV=name-of-environment ${0}\n"
}

if [ "$#" -gt 1 ] || [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
  usage
  exit
fi

if [[ -z "$DEPLOY_ENV" ]]; then
  echo "Environmental variable DEPLOY_ENV must be defined."
  exit 1
fi

kubectl create namespace argocd
kubectl apply -n argocd -f "install-${DEPLOY_ENV}.yaml"

# sleep 10

# Patch service to type LoadBalancer
# kubectl -n argocd patch svc argocd-server -p '{"spec": {"type": "LoadBalancer"}}'
