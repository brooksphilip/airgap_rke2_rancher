# Rancher Version
RANCHER_RELEASE="v2.7.6"

# Working directories & TAR
TAR_DIR=./
DEST_DIRECTORY=/tmp/rancher-images
DEST_TAR=${TAR_DIR}rancher-images-${RANCHER_RELEASE}.tar.gz  # Change this to the location you want for your resulting TAR 

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

RANCHER_IMAGES=$(curl --silent -L https://github.com/rancher/rancher/releases/download/$RANCHER_RELEASE/rancher-images.txt)
for image in $RANCHER_IMAGES; do
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
tar -zcfv "$DEST_TAR" -C "$DEST_DIRECTORY" .

# Clean up working directory
rm -rf $DEST_DIRECTORY
