# ArgoCD Deployment Automation

Automated deployment of ArgoCD applications in a Kubernetes cluster. Bootstrap all applications in cluster reliably and repeatably.

### ArgoCD CLI Login


Login to ArgoCD server with appropriate privileges. Substitute your server host URL, username and password. The ArgoCD admin password is store in AWS Secrets Manager.

```
argocd login argocd.sandbox.dev.data.pdx.atieva.com --username admin --password my_very_secret_password
```

Note: If login fails, see alternate CLI login method at end of document.

------------------------------

### Create Repositories

Create ArgoCD repositories if they don't already exist.  This only needs to be done once. The ArgoCD repositories hold the URL and credentials for Git repos.

From the web UI, create all the necessary Git repos for your deployments.

```
Manage your repositories, projects, settings (gears icon) > Repositories > Connect to your git repo using any of the allowed methods.
```

------------------------------

### App-of-Apps

By convention, the scripts expect all Helm charts starting with 'proj-' to be ArgoCD app-of-apps.  The name of the ArgoCD project and associated app-of-apps will be the same.

The app-of-apps pattern can be used to deploy a set of applications.

https://argoproj.github.io/argo-cd/operator-manual/cluster-bootstrapping/

An app-of-apps have a directory structure like so.

```
proj-vehicle-pipeline
├── Chart.yaml
├── README.md
├── env
│   ├── data-production-sol
│   │   ├── app-project.yaml
│   │   ├── application.yaml
│   │   └── values.yaml
│   └── data-sandbox-sandbox
│       ├── app-project.yaml
│       ├── application.yaml
│       └── values.yaml
└── templates
    └── app.yaml
```

The files under the environment directories have the following purpose:

| File             | Description                               |
|----------------- | ----------------------------------------- |
| app-project.yaml | ArgoCD AppProject YAML                    |
| application.yaml | ArgoCD Application YAML                   |
| values.yaml      | ArgoCD App-of-apps Helm Chart values file |

------------------------------

### Deploy Environment

Specify the environment to target when using the deploymnent scripts.
Set the environmental variable DEPLOY_ENV to the name of the environment to deploy to. The variable may be exported or specified along with each command invocation (recommended).

For an app-of-apps, the deployment environments are named as directories under the directory env.

Example directory structure of deployment environments for app-of-apps proj-infra.

```
proj-infra
└── env
    ├── adda-development-polaris
    ├── adda-production-larawag
    ├── cybersec-development-hamal
    ├── cybersec-production-kochab
    ├── data-development-core
    ├── data-production-sol
    ├── data-sandbox-sandbox
    └── data-staging-naos
```

------------------------------

### Applications to Deploy

In the app-of-apps values files (i.e. proj-infra/env/data-sandbox-sandbox/values.yaml), the applications are specified by including them in the apps list.

In this example, the app-of-apps proj-infra includes the following applications.

* velero
* elasticsearch

```
spec:
  project: proj-infra
  destination:
    server: https://kubernetes.default.svc
    namePrefix: ""
  source:
    repoURL: https://gitlab.corp.atieva.com/data/infrastructure/infra-charts.git
    targetRevision: dev

valueFiles:
  - values-data-sandbox.yaml

# Application Definitions
#
# apps: 
#   appNickname:                      # Go conforming name (camelCase)
#     name: name-of-app               # Canonical app name (required)
#     values: values-my-env.yaml      # Values file (optional)
#     namespace: custom-namespace     # Namespace (optional)
#     repo: https://gitlab.corp.atieva.com/data/my-repo.git   # Git chart repo (optional)
#     path: path/to/my-chart          # Path under chart repo (optional)
#     targetRev: my/branch            # Git branch (optional)
#     ignoreDiffs: true               # Ignore CRD diffs

apps:
  velero:
    name: velero
    values: ""
    namespace: ""
    repo: ""
    path: ""
    targetRev: ""
    ignoreDiffs: true
  elasticsearch:
    name: elasticsearch
    values: ""
    namespace: "es-cloud-logger"
    repo: ""
    path: ""
    targetRev: ""
    ignoreDiffs: true
```

------------------------------

### Create Projects

Create ArgoCD project. Supply the name of the app-of-apps Helm chart as argument.  Sustitute the actual ArgoCD project name for \<app-of-apps\>.

```
DEPLOY_ENV=data-production-sol ./argocd-proj-create.sh <proj-my-apps>
```

------------------------------

### Create App-of-apps

Create ArgoCD app-of-apps. Supply an argument to create applications for specified app-of-app only.  Sustitute the actual ArgoCD app-of-app name for \<app-of-apps\>.

```
DEPLOY_ENV=data-production-sol ./argocd-app-of-apps-create.sh <app-of-apps>
```

------------------------------

### Sync App-of-apps

Sync all ArgoCD app-of-apps.  Supply an argument to sync applications for specified app-of-app only.  Sustitute the actual ArgoCD app-of-app name for \<app-of-apps\>.

```
DEPLOY_ENV=data-production-sol ./argocd-app-of-apps-sync.sh <app-of-apps>
```

------------------------------

### Sync Applications

Sync all ArgoCD applications in an app-of-apps.  Supply app-of-app name as argument to deploy applications for specified ArgoCD app-of-app only.  Sustitute the actual app-of-app name for \<app-of-apps\>.

```
DEPLOY_ENV=data-production-sol ./argocd-app-sync.sh <app-of-apps>
```

------------------------------

### Working with individual apps

After the app-of-apps are created, there may be a need to sync or delete individual applications.  Some ArgoCD CLI examples are included here.

List all ArgoCD applications currently deployed.

```
argocd app list
```

Sync an appliations by name. Sustitute the actual app-of-app name for \<my-app\>.

```
argocd app sync <my-app>
```

Delete an appliations by name. Sustitute the actual app-of-app name for \<my-app\>.

```
argocd app delete <my-app>
```

------------------------------

### Alternate CLI Login

Optional: Attempt the following login if your ArgoCD login is thwarted by Dex.

##### Retrieve ArgoCD Web Token

From Chrome web browser, login to ArgoCD server. The following url is used as an example.

https://argocd.sandbox.dev.data.pdx.atieva.com

View > Developer > Developer Tools > Application > Storage > Cookies > argocd.token

Copy the argocd.token value and save as file argocd-cookie.txt.

```
export ARGOCD_COOKIE=`cat ~/path/to/argocd-cookie.txt`
```

##### CLI Login with token as cookie.

Login to ArgoCD server from the command-line.

```
argocd -H "Cookie: AWSELBAuthSessionCookie-0 ${ARGOCD_COOKIE}" --grpc-web login argocd.sandbox.dev.data.pdx.atieva.com --username admin --pasword my_very_secret_password
```


