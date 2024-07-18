# airgap_rke2
![architecture](https://raw.githubusercontent.com/brooksphilip/airgap_rke2_rancher/main/img/arch2.svg)
In this tourtorial we are going to airgap Rancher and RKE2. 

## Index
TODO

---

### Prereq's
* Private Image and Chart Registry in the Airgap I reccomend [Harbor](https://goharbor.io/)
* [Cosign](https://github.com/sigstore/cosign)
* [Helm](https://helm.sh/docs/intro/install/)

### Steps
##### Pre-Work
1. Download Images and Tar them up
Utilize the scripts above in order to download and TAR up the appropriate Rancher, RKE2, and K3s images. 

Use Hauler 

2. Gather Install Scripts and Helm charts 

##### Transfer & upload
3. Tranfer them over the Airgap

Use Hauler 

4. Upload Images to your private registry

Use Hauler 

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
```

Install the rke2 rpms in the following order
```
rke2-selinux
rke2-common
rke2-server
```

Create your config.yaml
```
echo 'system-default-registry: "registry.example.com:5000"' > /etc/rancher/rke2/config.yaml
```

Enable and start the service 
```
systemctl enable rke2-server --now
```

6. Lets deploy Rancher
```
helm upgrade -i rancher rancher-harbor/rancher   --namespace cattle-system   --set hostname=rancher.airgap.rancher.lol   --set bootstrapPassword=admin --set global.cattle.psp.enabled=false --version=v2.7.6 --set useBundledSystemChart=true --set rancherImage=rancher.edge.rancher.lol/rancher/rancher --set systemDefaultRegistry=harbor.edge.rancher.lol
```


If you feel ballzy - YOLO
