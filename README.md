# airgap_rke2

In this tourtorial we are going to airgap Rancher and RKE2. 

### Prereq's
* Private Registry in the Airgap
* Cosign
* Helm

### Steps
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

3. Tranfer them over the Airgap

4. Upload Images to your private registry

Utilize the push script to push images 
```bash
./push.sh <registry_URL> <registry_user> <registry_password> <images_tar>
```

5. Now Lets Deploy RKE2

##### Ubuntu 


##### Rocky 
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