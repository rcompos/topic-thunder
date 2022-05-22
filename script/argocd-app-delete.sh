#!/usr/bin/env bash
#
# Delete the ArgoCD application specified as argument
#
# ***  WARNING! USE CAUTION  ***
#
# Usage: DEPLOY_ENV=data-production-sol ./argocd-app-delete-all.sh app-of-apps
#

function usage(){
  echo -e "usage: DEPLOY_ENV=name-of-environment ${0} app-of-apps\n"
}

if [ "$#" -lt 1 ] || [ "$#" -gt 1 ] || [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
  usage
  exit
fi

if [[ -z "$DEPLOY_ENV" ]]; then
  echo "Environmental variable DEPLOY_ENV must be defined."
  exit 1
fi

cd ..

proj="$1"
echo "${proj}"
applist=`ls -1 "${proj}/templates" | perl -pe's/(\S+).yaml/$1/'`
for app in `echo "${applist}"`; do
  echo "  argocd app delete ${app}"
done

echo
read -p "Delete all applications from ArgoCD? [y|n] " -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
  echo "Exiting."
  exit 2
fi

echo
read -p "Are you sure? Type '${DEPLOY_ENV}': " -r
echo
if [[ ! $REPLY == "${DEPLOY_ENV}" ]]; then
  echo "Exiting."
  exit 3
fi

echo "${proj}"
applist=`ls -1 "${proj}/templates" | perl -pe's/(\S+).yaml/$1/'`
for app in `echo "${applist}"`; do
  echo "  argocd app delete ${app}"
  argocd app delete "${app}"
done
