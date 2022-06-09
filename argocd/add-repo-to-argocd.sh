#!/usr/bin/env bash
#
# Add Git repo to ArgoCD
#
# Usage: DEPLOY_ENV=data-production-sol ./add-repo-to-argocd.sh
#
set -x

GIT_REPO_ADD=${GIT_REPO_ADD}
GIT_USERNAME=${GIT_USERNAME}
GIT_PA_TOKEN=${GIT_PA_TOKEN}

if [[ -z "${GITLAB_PA_TOKEN}" ]]; then
  echo "Environmental variable GITLAB_PA_TOKEN must be defined."
  exit 1
fi

GIT_REPO_ADD="https://gitlab.corp.atieva.com/data/infrastructure/topic-thunder.git"

argocd repo add "${GIT_REPO_ADD}" --username "${GIT_USERNAME}" --password "${GIT_PA_TOKEN}"

