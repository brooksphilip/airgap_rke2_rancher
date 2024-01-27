#Cert-Manager
helm repo add jetstack https://charts.jetstack.io
helm pull jetstack/cert-manager --version v1.11.0

#Rancher
helm repo add rancher-latest https://releases.rancher.com/server-charts/latest
helm pull rancher-latest/rancher

#NeuVector

#Longhorn