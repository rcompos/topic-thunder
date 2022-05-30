#!/usr/bin/env bash
set +x

#    "ui.cssurl": "./custom/my-styles.css",
#    "ui.cssurl": "http://topic-thunder.scandalizer.org/my-styles.css",
#    "ui.cssurl": "http://topic-thunder.scandalizer.org.s3-website.us-west-2.amazonaws.com/my-styles.css",
#    "ui.cssurl": "https://rcompos.github.io/my-styles.css",

kubectl -n argocd patch configmap/argocd-cm --type merge \
  -p '{ "data":{
    "ui.cssurl": "https://rcompos.github.io/my-styles.css",
    "ui.bannercontent": "Hello ArgoCD afficianado!",
    "ui.bannerurl": "https://github.com/rcompos/topic-thunder"
 }}'


