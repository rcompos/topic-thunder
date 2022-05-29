#!/usr/bin/env bash
set +x


kubectl -n argocd patch configmap/argocd-cm --type merge \
  -p '{ "data":{
    "ui.cssurl": "https://github.com/rcompos/topic-thunder/blob/main/argocd/my-styles.css",
    "ui.bannercontent": "Hello ArgoCD afficianado!",
    "ui.bannerurl": "blacklab.lan"
 }}'


