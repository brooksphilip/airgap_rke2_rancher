#!/bin/bash
# Remote Registry
TARGET_REGISTRY="$1"

# Set these if your target registry requires authentication.
TARGET_REGISTRY_USER="$2"
TARGET_REGISTRY_PASSWORD="$3"

# Source and Working Files
SOURCE_TAR=$1
WORKING_DIR="../workingdir/images"  # Change this if desired/necessary

if [[ ! -f "$SOURCE_TAR" ]]; then
    echo "ERROR: Tarball '$SOURCE_TAR' not found."
    exit 1
fi

if [[ -d "$WORKING_DIR" ]]; then
    echo "ERROR: Working directory '$WORKING_DIR' exists."
    echo "Remove it or change the value."
    exit 1
fi

if [[ ! -z $TARGET_REGISTRY_USER ]] && [[ ! -z $TARGET_REGISTRY_PASSWORD ]]; then
    cosign login -u $TARGET_REGISTRY_USER -p $TARGET_REGISTRY_PASSWORD $TARGET_REGISTRY
fi

mkdir -p "$WORKING_DIR"
tar zxf "$SOURCE_TAR" -C "$WORKING_DIR"

for image in $(cat $WORKING_DIR/manifest.txt); do
    echo "image"
    echo "$image"
    IFS="|" read -r img_id source_image <<< "${image}"
    echo "source image"
    echo "$source_image"
    dest_image=$(echo $source_image | sed "s|TARGET_REGISTRY|$TARGET_REGISTRY|g")
    echo "====>pushing $dest_image"
    cosign load --dir "$WORKING_DIR/$img_id" $dest_image
done

rm -rf $WORKING_DIR