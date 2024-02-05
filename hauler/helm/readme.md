# Helm

## Collection and Packaging


```bash
# pull the manifest
curl -#OL https://raw.githubusercontent.com/zackbradys/rancher-airgap/v2.0.0/hauler/helm/rancher-airgap-helm.yaml

# sync to the store
hauler store sync --files rancher-airgap-helm.yaml

# save to tarball
hauler store save --filename rancher-airgap-helm.tar.zst
```

## Across the Airgap

```bash
# coming soon
```

## Loading and Distribution

```bash
# coming soon
```