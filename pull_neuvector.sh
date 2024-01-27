#!/bin/bash
# NeuVector Chart Version
NEUVECTOR_RELEASE=v2.7.1

# Working directories & TAR
DEST_DIRECTORY=../workingdir/neuvector-images
DEST_TAR=../neuvector/neuvector-images-${NEUVECTOR_RELEASE}.tar.gz  # Change this to the location you want for your resulting TAR 


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

cosign login -u $SOURCE_REGISTRY_USER -p $SOURCE_REGISTRY_PASS $SOURCE_REGISTRY
mkdir -p "$DEST_DIRECTORY"

# Add the neuvector repo (required Helm)
helm repo add neuvector https://neuvector.github.io/neuvector-helm
helm repo update

# Grab the list of images and download them (requires docker, grep, sed, and awk)
for image in $(helm template neuvector neuvector/core --version $NEUVECTOR_RELEASE | grep 'image:' | sed 's/"//g' | sed "s/'//g" | awk '{ print $2 }'); do
    source_image=$(echo $image | sed "s/docker.io/$SOURCE_REGISTRY/g")
    dest_image=$(echo $image | sed "s/docker.io/TARGET_REGISTRY/g")
    
    # Create manifest to use during load
    img_id_num=$(mktemp -d XXXXXXXXXXXXXXXXXXXX)
    echo "$img_id_num|$dest_image" >> $DEST_DIRECTORY/manifest.txt
    
    # Save image locally
    mkdir $DEST_DIRECTORY/$img_id_num
    cosign save --dir "$DEST_DIRECTORY/$img_id_num" $source_image
    rm -rf $img_id_num
done

# Compress directory
echo "Compressing Images"
tar zcf "$DEST_TAR" -C "$DEST_DIRECTORY" .

# Clean up working directory
rm -rf $DEST_DIRECTORY

echo "Complete"