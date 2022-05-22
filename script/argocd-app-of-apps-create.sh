#!/usr/bin/env bash
#
# For all directory names starting with 'proj-', create the ArgoCD application.
#
# Usage: DEPLOY_ENV=data-production-sol ./argocd-app-create.sh
#

function usage(){
  echo -e "usage: DEPLOY_ENV=name-of-environment ${0} [app]\n"
}

if [ "$#" -gt 1 ] || [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
  usage
  exit
fi

if [[ -z "$DEPLOY_ENV" ]]; then
  echo "Environmental variable DEPLOY_ENV must be defined."
  exit 1
fi

cd ..

if [[ -z "$1" ]]; then  # No arguments
  for proj in `ls -d -1 proj-*`; do
    echo "argocd app create -f ${proj}/env/${DEPLOY_ENV}/application.yaml"
  done
else # Argument received
  proj="$1"
  echo "argocd app create -f ${proj}/env/${DEPLOY_ENV}/application.yaml"
fi

echo
read -p "Create applications in ArgoCD? [y|n] " -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
  echo "Exiting."
  exit 2
fi

if [[ -z "$1" ]]; then  # No arguments
  for proj in `ls -d -1 proj-*`; do
    echo "argocd app create -f ${proj}/env/${DEPLOY_ENV}/application.yaml"
    argocd app create -f "${proj}/env/${DEPLOY_ENV}/application.yaml"
  done
else # Argument received
  proj="$1"
  echo "argocd app create -f ${proj}/env/${DEPLOY_ENV}/application.yaml"
  argocd app create -f "${proj}/env/${DEPLOY_ENV}/application.yaml" 
fi 
