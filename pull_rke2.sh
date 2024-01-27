#!/bin/bash
# RKE2 Version
RKE2_RELEASE="v1.24.12+rke2r1"

# Working directories & TAR
DEST_DIRECTORY=/tmp/rke2-images
DEST_TAR=../rke2/rke2-images-${RKE2_RELEASE}.tar.gz  # Change this to the location you want for your resulting TAR 

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

mkdir -p "$DEST_DIRECTORY"

RKE2_IMAGES=$(curl --silent -L https://github.com/rancher/rke2/releases/download/$RKE2_RELEASE/rke2-images-all.linux-amd64.txt)

for image in $RKE2_IMAGES; do
    source_image=$image
    dest_image="TARGET_REGISTRY/$image"
    
    # Create manifest to use during load
    img_id_num=$(mktemp -d XXXXXXXXXXXXXXXXXXXX)
    echo "$img_id_num|$dest_image" >> $DEST_DIRECTORY/manifest.txt
    
    # Save image locally
    mkdir $DEST_DIRECTORY/$img_id_num
    cosign save --dir "$DEST_DIRECTORY/$img_id_num" $source_image
    rm -rf $img_id_num
done

echo "Compressing Release"
# Compress directory
tar zcf "$DEST_TAR" -C "$DEST_DIRECTORY" .

# Clean up working directory
rm -rf $DEST_DIRECTORY
