# airgap_rke2
![architecture](https://raw.githubusercontent.com/brooksphilip/airgap_rke2_rancher/main/img/arch2.png)
In this tourtorial we are going to airgap Rancher and RKE2. 

## Index

### Prereq's
* Private Registry in the Airgap
* Cosign
* Helm

### Steps
##### Pre-Work
1. Download Images and Tar them up
Utilize the scripts above in order to download and TAR up the appropriate Rancher, RKE2, and K3s images. 

Rancher Images 
```bash
./pull_rancher.sh
```
RKE2 Images
```bash
./pull_rke2.sh
```

2. Gather Install Scripts and Helm charts 

##### Transfer & upload
3. Tranfer them over the Airgap

4. Upload Images to your private registry

Utilize the push script to push images 
```bash
./push.sh <registry_URL> <registry_user> <registry_password> <images_tar>
```
##### Deploy
5. Now Lets Deploy RKE2

###### Ubuntu 


###### Rocky 
Verify the Following information as I will not be updating this as often as Rancher Offical documentation. 
Rancher Offical Docs 
```html
https://docs.rke2.io/install/airgap
``` 

Required Dependencies
```
Installing dependencies:
container-selinux
iptables
libnetfilter_conntrack
libnfnetlink
libnftnl
policycoreutils-python-utils
rke2-common
rke2-selinux
```

Pull Install script and checksums
```
#RKE2-Version=1.24.16
mkdir /root/rke2-artifacts && cd /root/rke2-artifacts/
curl -OLs https://github.com/rancher/rke2/releases/download/v1.21.5%2Brke2r2/rke2.linux-amd64.tar.gz
curl -OLs https://github.com/rancher/rke2/releases/download/v1.21.5%2Brke2r2/sha256sum-amd64.txt
curl -sfL https://get.rke2.io --output install.sh
```

6. Lets deploy Rancher
```
helm upgrade -i rancher rancher-harbor/rancher   --namespace cattle-system   --set hostname=rancher.airgap.rancher.lol   --set bootstrapPassword=admin --set global.cattle.psp.enabled=false --version=v2.7.6 --set useBundledSystemChart=true --set rancherImage=rancher.edge.rancher.lol/rancher/rancher --set systemDefaultRegistry=harbor.edge.rancher.lol
```


If you feel ballzy - YOLO
