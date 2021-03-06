#!/bin/bash
set -eu

function setup_bosh_env_vars() {
  echo "Setting env vars..."
  pushd "bbl-state/${BBL_STATE_DIR}"
    bblver="$(bbl -v | cut -d' ' -f2 | cut -d'.' -f1)"
    if [ $bblver -eq "6" ]; then
      eval "$(bbl print-env)"
    else
      export BOSH_CA_CERT="$(bbl director-ca-cert)"
      export BOSH_ENVIRONMENT=$(bbl director-address)
      export BOSH_CLIENT=$(bbl director-username)
      export BOSH_CLIENT_SECRET=$(bbl director-password)
    fi
  popd
}

function update_bosh_cloud_config() {
  echo "Updating bosh cloud-config on ${BOSH_ENVIRONMENT}..."
  pushd "bbl-state/${BBL_STATE_DIR}"
    bosh -n update-cloud-config <(bbl cloud-config) \
      -o ../../capi-ci/cf-deployment-operations/temporary/credhub-lb-cloud-properties.yml
  popd
}

function main() {
  setup_bosh_env_vars
  update_bosh_cloud_config
  echo "Done"
}

main
