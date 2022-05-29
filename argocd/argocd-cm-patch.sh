#!/usr/bin/env bash
set +x

#    "ui.cssurl": "./custom/my-styles.css",

kubectl -n argocd patch configmap/argocd-cm --type merge \
  -p '{ "data":{
    "ui.cssurl": "http://topic-thunder.scandalizer.org/my-styles.css",
    "ui.bannercontent": "Hello ArgoCD afficianado!",
    "ui.bannerurl": "blacklab.lan"
 }}'


