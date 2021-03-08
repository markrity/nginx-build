kubectl -n default create serviceaccount jenkins-robot

kubectl -n default create rolebinding jenkins-robot-binding --clusterrole=cluster-admin --serviceaccount=default:jenkins-robot

kubectl -n default get serviceaccount jenkins-robot -o go-template --template='{{range .secrets}}{{.name}}{{"\n"}}{{end}}'

jenkins-robot-token-n5kjk


kubectl -n default get secrets jenkins-robot-token-n5kjk -o go-template --template '{{index .data "token"}}' | base64 -d