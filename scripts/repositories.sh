#!/bin/bash

fabric_repositories=(
  https://gerrit.hyperledger.org/r/fabric
  https://gerrit.hyperledger.org/r/fabric-amcl
  https://gerrit.hyperledger.org/r/fabric-baseimage
  https://gerrit.hyperledger.org/r/fabric-ca
  https://gerrit.hyperledger.org/r/fabric-chaincode-evm
  https://gerrit.hyperledger.org/r/fabric-chaincode-java
  https://gerrit.hyperledger.org/r/fabric-chaincode-node
  https://gerrit.hyperledger.org/r/fabric-chaintool
  https://gerrit.hyperledger.org/r/fabric-docs
  https://gerrit.hyperledger.org/r/fabric-samples
  https://gerrit.hyperledger.org/r/fabric-sdk-go
  https://gerrit.hyperledger.org/r/fabric-sdk-java
  https://gerrit.hyperledger.org/r/fabric-sdk-node
  https://gerrit.hyperledger.org/r/fabric-sdk-py
  https://gerrit.hyperledger.org/r/fabric-sdk-rest
  https://gerrit.hyperledger.org/r/fabric-test
  https://gerrit.hyperledger.org/r/fabric-test-resources
  https://gerrit.hyperledger.org/r/homebrew-fabric
)

sawtooth_repositories=(
  https://github.com/hyperledger/sawtooth-ansible.git
  https://github.com/hyperledger/sawtooth-core.git
  https://github.com/hyperledger/sawtooth-explorer.git
  https://github.com/hyperledger/sawtooth-marketplace.git
  https://github.com/hyperledger/sawtooth-next-directory.git
  https://github.com/hyperledger/sawtooth-poet.git
  https://github.com/hyperledger/sawtooth-private-utxo.git
  https://github.com/hyperledger/sawtooth-raft.git
  https://github.com/hyperledger/sawtooth-rfcs.git
  https://github.com/hyperledger/sawtooth-sabre.git
  https://github.com/hyperledger/sawtooth-sdk-cxx.git
  https://github.com/hyperledger/sawtooth-sdk-dotnet.git
  https://github.com/hyperledger/sawtooth-sdk-go.git
  https://github.com/hyperledger/sawtooth-sdk-java.git
  https://github.com/hyperledger/sawtooth-sdk-javascript.git
  https://github.com/hyperledger/sawtooth-seth.git
  https://github.com/hyperledger/sawtooth-supply-chain.git
  https://github.com/hyperledger/sawtooth-website.git
  https://github.com/hyperledger/education-sawtooth-simple-supply.git
)

iroha_repositories=(
  https://github.com/hyperledger/iroha.git
  https://github.com/hyperledger/iroha-android.git
  https://github.com/hyperledger/iroha-api.git
  https://github.com/hyperledger/iroha-dotnet.git
  https://github.com/hyperledger/iroha-ed25519.git
  https://github.com/hyperledger/iroha-ios.git
  https://github.com/hyperledger/iroha-javascript.git
  https://github.com/hyperledger/iroha-network-tools.git
  https://github.com/hyperledger/iroha-python.git
  https://github.com/hyperledger/iroha-scala.git
)

burrow_repositories=(
  https://github.com/hyperledger/burrow.git
)

indy_repositories=(
  https://github.com/hyperledger/indy-agent.git
  https://github.com/hyperledger/indy-anoncreds.git
  https://github.com/hyperledger/indy-crypto.git
  https://github.com/hyperledger/indy-hipe.git
  https://github.com/hyperledger/indy-jenkins-pipeline-lib.git
  https://github.com/hyperledger/indy-node.git
  https://github.com/hyperledger/indy-plenum.git
  https://github.com/hyperledger/indy-post-install-automation.git
  https://github.com/hyperledger/indy-sdk.git
)

composer_repositories=(
  https://github.com/hyperledger/composer.git
  https://github.com/hyperledger/composer-atom-plugin.git
  https://github.com/hyperledger/composer-knowledge-wiki.git
  https://github.com/hyperledger/composer-sample-applications.git
  https://github.com/hyperledger/composer-sample-networks.git
  https://github.com/hyperledger/composer-sample-models.git
  https://github.com/hyperledger/composer-tools.git
  https://github.com/hyperledger/composer-vscode-plugin.git
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

caliper_repositories=(
  https://github.com/hyperledger/caliper.git
)

labs_repositories=(
  https://github.com/hyperledger-labs/z-mix.git
  https://github.com/hyperledger-labs/private-data-objects.git
  https://github.com/hyperledger-labs/SParts.git
  https://github.com/hyperledger-labs/fabric-chrome-extension.git
  https://github.com/hyperledger-labs/hyperledger-labs.github.io.git
  https://github.com/hyperledger-labs/crypto-lib.git
)

other_repositories=(
  https://github.com/hyperledger/ci-management.git
  https://github.com/hyperledger/education.git
  https://github.com/hyperledger/education-cryptomoji.git
  https://github.com/hyperledger/hyperledger.git
  https://github.com/hyperledger/hyperledger-rocket-chat-hubot.git
  https://github.com/hyperledger/hyperledger.github.io.git
  https://github.com/hyperledger/hyperledgerwp.git
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
  "${caliper_repositories[@]}"
)

# These two lines look backwards, but they are removing the pattern from the list of all repositories
github_repositories=( ${all_repositories[@]/*gerrit*/} )
gerrit_repositories=( ${all_repositories[@]/*github*/} )
