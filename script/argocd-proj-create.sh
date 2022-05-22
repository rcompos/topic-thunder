#!/usr/bin/env bash
#
# For all repo names starting with 'proj-', create the ArgoCD project.
# If an argument is received, create project [arg]
#
# Usage: DEPLOY_ENV=data-production-sol ./argocd-proj-create.sh
#

function usage(){
  echo -e "usage: DEPLOY_ENV=name-of-environment ${0} [project]\n"
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
    echo "argocd proj create -f ${proj}/env/${DEPLOY_ENV}/app-project.yaml"
  done
else # Argument received
  proj="$1"
  echo "argocd proj create -f ${proj}/env/${DEPLOY_ENV}/app-project.yaml"
fi

echo 
read -p "Create project(s) in ArgoCD? [y|n] " -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
  echo "Exiting."
  exit 2
fi

if [[ -z "$1" ]]; then  # No arguments
  for proj in `ls -d -1 proj-*`; do
    echo "argocd proj create -f ${proj}/env/${DEPLOY_ENV}/app-project.yaml"
    argocd proj create -f "${proj}/env/${DEPLOY_ENV}/app-project.yaml"
  done
else # Argument received
  proj="$1"
  echo "argocd proj create -f ${proj}/env/${DEPLOY_ENV}/app-project.yaml"
  argocd proj create -f "${proj}/env/${DEPLOY_ENV}/app-project.yaml" 
fi 
