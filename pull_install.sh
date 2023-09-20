#set 
export RKE2_VERSION=1.24.16
export RANCHER_VERSION=2.7.6

function rhelrocky () {
    rm -rf artifacts
    #mkdir -p /etc/rancher/rke2
    #echo "system-default-registry: "${1}"" > /etc/rancher/rke2/config.yaml
    mkdir artifacts && cd artifacts
    #curl -OLs https://github.com/rancher/rke2/releases/download/v1.25.12%2Brke2r1/rke2-images.linux-amd64.tar.zst
    curl -OLs https://github.com/rancher/rke2/releases/download/v1.25.12%2Brke2r1/rke2.linux-amd64.tar.gz 
    curl -OLs https://github.com/rancher/rke2/releases/download/v1.25.12%2Brke2r1/sha256sum-amd64.txt
    curl -sfL https://get.rke2.io --output install.sh
}

function debianubuntu () {
        rm -rf artifacts
        #mkdir -p /etc/rancher/rke2
        #echo "system-default-registry: "${1}"" > /etc/rancher/rke2/config.yaml
        mkdir artifacts && cd artifacts
        #curl -OLs https://github.com/rancher/rke2/releases/download/v1.25.12%2Brke2r1/rke2-images.linux-amd64.tar.zst
        curl -OLs https://github.com/rancher/rke2/releases/download/v1.25.12%2Brke2r1/rke2.linux-amd64.tar.gz 
        curl -OLs https://github.com/rancher/rke2/releases/download/v1.25.12%2Brke2r1/sha256sum-amd64.txt
        curl -sfL https://get.rke2.io --output install.sh
}