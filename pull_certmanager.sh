
# Cert Manager Chart Version
CERT_MANAGER_RELEASE=v1.9.1

# Working directories & TAR
DEST_DIRECTORY=/tmp/cert-manager-images
DEST_TAR=../certmanager/cert-manager-images${CERT_MANAGER_RELEASE}.tar.gz  # Change this to the location you want for your resulting TAR 


if [[ -d "$DEST_DIRECTORY" ]]; then
    echo "ERROR: Directory '$DEST_DIRECTORY' exists."
    echo "Change or delete it before running."
    exit 1
fi

if [[ -d "$DEST_TAR" ]]; then
    echo "ERROR: Directory '$DEST_TAR' exists."
    echo "Change or delete it before running."
    exit 1
fi

# cosign login -u $SOURCE_REGISTRY_USER -p $SOURCE_REGISTRY_PASS $SOURCE_REGISTRY
mkdir -p "$DEST_DIRECTORY"

# Add the cert manager repo (required Helm)
helm repo add jetstack https://charts.jetstack.io
helm repo update

# Grab the list of images and download them (requires docker, grep, sed, and awk)
for image in $(helm template jetstack/cert-manager --version $CERT_MANAGER_RELEASE | grep 'image:' | sed 's/"//g' | sed "s/'//g" | awk '{ print $2 }'); do
    # source_image=$(echo $image | sed "s/quay.io/$SOURCE_REGISTRY/g")
    source_image=$image
    dest_image=$(echo $image | sed "s/quay.io/TARGET_REGISTRY/g")
    
    # Create manifest to use during load
    img_id_num=$(mktemp -d XXXXXXXXXXXXXXXXXXXX)
    echo "$img_id_num|$dest_image" >> $DEST_DIRECTORY/manifest.txt
    
    # Save image locally
    mkdir $DEST_DIRECTORY/$img_id_num
    cosign save --dir "$DEST_DIRECTORY/$img_id_num" $source_image
    rm -rf $img_id_num
done

# Compress directory
tar zcf "$DEST_TAR" -C "$DEST_DIRECTORY" .

# Clean up working directory
rm -rf $DEST_DIRECTORY