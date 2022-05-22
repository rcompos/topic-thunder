#!/usr/bin/env bash
#
# For all repo names starting with 'proj-', create the ArgoCD application.
#
# Usage: DEPLOY_ENV=data-production-sol ./argocd-app-create.sh
#

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

cd ..

if [[ -z "$1" ]]; then  # No arguments
  for proj in `ls -d -1 proj-*`; do
    echo "${proj}"
    applist=`ls -1 ${proj}/templates | perl -pe's/(\S+).yaml/$1/'`
    for app in `echo "${applist}"`; do
      echo "  argocd app sync ${app}"
    done
  done
else # Argument received
  proj="$1"
  applist=`ls -1 ${proj}/templates | perl -pe's/(\S+).yaml/$1/'`
  for app in `echo "${applist}"`; do
    echo "  argocd app sync ${app}"
  done
fi

echo
read -p "Sync all applications for project(s) ArgoCD? [y|n] " -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
  echo "Exiting."
  exit 2
fi

if [[ -z "$1" ]]; then  # No arguments
  for proj in `ls -d -1 proj-*`; do
    echo "${proj}"
    applist=`ls -1 ${proj}/templates | perl -pe's/(\S+).yaml/$1/'`
    for app in `echo "${applist}"`; do
      echo "  argocd app sync ${app}"
      argocd app sync "${app}"
    done
  done
else # Argument received
  proj="$1"
  echo "${proj}"
  applist=`ls -1 ${proj}/templates | perl -pe's/(\S+).yaml/$1/'`
  for app in `echo "${applist}"`; do
    echo "  argocd app sync ${app}"
    argocd app sync "${app}"
  done
fi