#!/usr/bin/env bash
set +x

#    "ui.cssurl": "./custom/my-styles.css",
#    "ui.cssurl": "http://topic-thunder.scandalizer.org/my-styles.css",
#    "ui.cssurl": "http://topic-thunder.scandalizer.org.s3-website.us-west-2.amazonaws.com/my-styles.css",
#    "ui.cssurl": "https://rcompos.github.io/my-styles.css",
#    "ui.bannerurl": "https://github.com/rcompos/topic-thunder"

kubectl -n argocd patch configmap/argocd-cm --type merge \
  -p '{ "data":{
    "statusbadge.enabled": "true",
    "ui.cssurl": "https://rcompos.github.io/my-styles.css",
    "ui.bannerpermanent": "true",
    "ui.bannercontent": "PRODUCTION TOPIC-THUNDER"
 }}'


