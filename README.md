

### Step 1
Create nginx image that have static page with build number.

I have used the fastest way to perform it , since I was told there going to be issues with Jenkins and K8S cluster. So had no time to waste here.

Created a Dockerfile that taked `index.html` and updated replaced a specific string , based on docker ARG that going to be passed during the build.

There are plenty of ways to improve, using nginx config with server sub_filter etc...

### Step 2
Init Jenkins with default plugins and install Docker and Kubernetes plugins.
Building jenkins pipeline that just perform a build of Dockerfile.
`docker not found` error accured.
I have sshed to machine and execed into Jenkins docker to see that it has no docker sock or docker installation passed.

I have created a `docker-compose.yml` , that also stores jenkins home and mounts docker.sock and Docker bin.
`docker-compose up -d` and checked that it has `docker --version` up and running.


Re-configured jenkins again since it was a fresh installtion from myside again.
Added pipeline that takes Jenkinsfile from this repo.
Checked that building works.
Added dockerhub credentials.
Checked that push works.

### Step 3
Tried to add kubernetes as a cloud provider , but it didn't work with `ca.crt` , it did work with config file , but requirements said not to use it.

So I have found that there is a `Kubernetes CLI` plugin , that can perform kubectl actions using just SA-Token and k8s api url.

Added `kubectl` to jenkins machine and mounted it to docker using same `docker-compose.yaml`

Tried to add new SA but had no permission to get/add roles and rolebinding.
So used existing `candidate` SA , to get everything I need.

```
kubectl -n default get serviceaccount candidate -o go-template --template='{{range .secrets}}{{.name}}{{"\n"}}{{end}}'
```

got : `candidate-token-dqllv`

```
kubectl -n default get secrets candidate-token-dqllv -o go-template --template '{{index .data "token"}}' | base64 -d
```

Got a token and added it to Jenkins credentials as Secret Text.

Performed a check that kubectl apply works from Jenkins file.

Updating BUILD_NUMBER at `deployment.yaml` using same old sed.
Could be done with HELM, but it would require creating helm-chart and adding helm installation to Jenkins.


Fin. Total time 3h.