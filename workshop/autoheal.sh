#!/bin/bash
export INSTALL_REGISTRY_USERNAME=tapworkshopoperators
export INSTALL_REGISTRY_PASSWORD=password-registry
export INSTALL_REGISTRY_HOSTNAME=tapworkshopoperators.azurecr.io
sudo tanzu secret registry delete tap-registry --namespace tap-install -y
sudo tanzu secret registry add tap-registry   --username ${INSTALL_REGISTRY_USERNAME} --password ${INSTALL_REGISTRY_PASSWORD}   --server ${INSTALL_REGISTRY_HOSTNAME}   --export-to-all-namespaces --yes --namespace tap-install
sleep 60
sudo tanzu package installed update tap -f ~/tap-values.yaml -n tap-install
