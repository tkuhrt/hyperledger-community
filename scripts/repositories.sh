#!/bin/bash

fabric_repositories=(
  https://gerrit.hyperledger.org/r/fabric
  https://gerrit.hyperledger.org/r/fabric-baseimage
  https://gerrit.hyperledger.org/r/fabric-ca
  https://gerrit.hyperledger.org/r/fabric-chaintool
  https://gerrit.hyperledger.org/r/fabric-docs
  https://gerrit.hyperledger.org/r/fabric-samples
  https://gerrit.hyperledger.org/r/fabric-sdk-go
  https://gerrit.hyperledger.org/r/fabric-sdk-java
  https://gerrit.hyperledger.org/r/fabric-sdk-node
  https://gerrit.hyperledger.org/r/fabric-sdk-py
  https://gerrit.hyperledger.org/r/fabric-test-resources
  https://gerrit.hyperledger.org/r/homebrew-fabric
  https://gerrit.hyperledger.org/r/fabric-test
  https://gerrit.hyperledger.org/r/fabric-chaincode-node
  https://gerrit.hyperledger.org/r/fabric-sdk-rest
  https://gerrit.hyperledger.org/r/fabric-chaincode-java
  https://gerrit.hyperledger.org/r/fabric-docs
)

sawtooth_repositories=(
  https://github.com/hyperledger/sawtooth-core.git
  https://github.com/hyperledger/sawtooth-supply-chain.git
)

iroha_repositories=(
  https://github.com/hyperledger/iroha.git
  https://github.com/hyperledger/iroha-javascript.git
  https://github.com/hyperledger/iroha-ametsuchi.git
  https://github.com/hyperledger/iroha-scala.git
  https://github.com/hyperledger/iroha-ios.git
  https://github.com/hyperledger/iroha-android.git
  https://github.com/hyperledger/iroha-network-tools.git
  https://github.com/hyperledger/iroha-python.git
  https://github.com/hyperledger/iroha-dotnet.git
)

burrow_repositories=(
  https://github.com/hyperledger/burrow.git
)

indy_repositories=(
  https://github.com/hyperledger/indy-plenum.git
  https://github.com/hyperledger/indy-node.git
  https://github.com/hyperledger/indy-sdk.git
  https://github.com/hyperledger/indy-anoncreds.git
  https://github.com/hyperledger/indy-crypto.git
)

composer_repositories=(
  https://github.com/hyperledger/composer.git
  https://github.com/hyperledger/composer-sample-networks.git
  https://github.com/hyperledger/composer-sample-models.git
  https://github.com/hyperledger/composer-vscode-plugin.git
  https://github.com/hyperledger/composer-atom-plugin.git
  https://github.com/hyperledger/composer-sample-applications.git
  https://github.com/hyperledger/composer-tools.git
)

cello_repositories=(
  https://gerrit.hyperledger.org/r/cello
  https://gerrit.hyperledger.org/r/cello-analytics
  https://gerrit.hyperledger.org/r/cello-k8s-operator
)

explorer_repositories=(
  https://gerrit.hyperledger.org/r/blockchain-explorer
)

quilt_repositories=(
  https://github.com/hyperledger/quilt
  https://github.com/hyperledger/quilt-crypto-conditions
)

all_repositories=(
  "${fabric_repositories[@]}"
  "${sawtooth_repositories[@]}"
  "${iroha_repositories[@]}"
  "${burrow_repositories[@]}"
  "${indy_repositories[@]}"
  "${composer_repositories[@]}"
  "${cello_repositories[@]}"
  "${explorer_repositories[@]}"
  "${quilt_repositories[@]}"
)

# These two lines look backwards, but they are removing the pattern from the list of all repositories
github_repositories=( ${all_repositories[@]/*gerrit*/} )
gerrit_repositories=( ${all_repositories[@]/*github*/} )

