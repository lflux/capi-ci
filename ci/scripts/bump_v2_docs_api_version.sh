#!/usr/bin/env bash
set -e -x

function setup_git_user() {
  git config user.name 'CAPI CI'
  git config user.email 'cf-capi-eng+ci@pivotal.io'
}

function bump_v2_docs() {
  sed -i -e 's/^\(.*api_version.*"\).*\(",\)$/\1'"$VERSION"'\2/' docs/v2/info/get_info.html
}

function get_v2_version_from_cc() {
  VERSION=$(cat config/version_v2)
}

function commit_docs() {
  git add docs/v2/info/get_info.html
  git commit -m "Bump v2 API docs version ${VERSION}"
}

function move_cc_to_output_location() {
  mv capi-release/src/cloud_controller_ng cloud_controller_ng_bumped_docs
}

function main() {
  pushd capi-release/src/cloud_controller_ng
    setup_git_user
    get_v2_version_from_cc
    bump_v2_docs
    commit_docs
  popd
  move_cc_to_output_location

  cat docs/v2/info/get_info.html
}

main
