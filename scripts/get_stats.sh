#!/bin/bash

SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
script_dir="$( cd -P "$( dirname "$SOURCE" )" && pwd )"

. ${script_dir}/repositories.sh

#Default variables
repositories=()
filename="hyperledger-source"
all_specified=FALSE

# Handle command line arguments
while [[ $# -gt 0 ]]
do
key="$1"

case $key in
    --fabric)
      if [[ "$all_specified" == FALSE ]] ; then
        repositories+=( "${fabric_repositories[@]}" )
        filename+="-fabric"
      fi
    ;;
    --sawtooth)
      if [[ "$all_specified" == FALSE ]] ; then
        repositories+=( "${sawtooth_repositories[@]}" )
        filename+="-sawtooth"
      fi
    ;;
    --iroha)
      if [[ "$all_specified" == FALSE ]] ; then
        repositories+=( "${iroha_repositories[@]}" )
        filename+="-iroha"
      fi
    ;;
    --burrow)
      if [[ "$all_specified" == FALSE ]] ; then
        repositories+=( "${burrow_repositories[@]}" )
        filename+="-burrow"
      fi
    ;;
    --indy)
      if [[ "$all_specified" == FALSE ]] ; then
        repositories+=( "${indy_repositories[@]}" )
        filename+="-indy"
      fi
    ;;
    --composer)
      if [[ "$all_specified" == FALSE ]] ; then
        repositories+=( "${composer_repositories[@]}" )
        filename+="-composer"
      fi
    ;;
    --cello)
      if [[ "$all_specified" == FALSE ]] ; then
        repositories+=( "${cello_repositories[@]}" )
        filename+="-cello"
      fi
    ;;
    --explorer)
      if [[ "$all_specified" == FALSE ]] ; then
        repositories+=( "${explorer_repositories[@]}" )
        filename+="-explorer"
      fi
    ;;
    --quilt)
      if [[ "$all_specified" == FALSE ]] ; then
        repositories+=( "${quilt_repositories[@]}" )
        filename+="-quilt"
      fi
    ;;
    --caliper)
      if [[ "$all_specified" == FALSE ]] ; then
        repositories+=( "${caliper_repositories[@]}" )
        filename+="-caliper"
      fi
    ;;
    --gerrit)
      if [[ "$all_specified" == FALSE ]] ; then
        repositories+=( "${gerrit_repositories[@]}" )
        filename+="-gerrit"
      fi
    ;;
    --github)
      if [[ "$all_specified" == FALSE ]] ; then
        repositories+=( "${github_repositories[@]}" )
        filename+="-github"
      fi
    ;;
    --interledger)
      if [[ "$all_specified" == FALSE ]] ; then
        repositories+=( "${interledger_repositories[@]}" )
        filename+="-interledger"
      fi
    ;;
    --all)
      all_specified=TRUE
      filename+="-all"
      repositories="${all_repositories[@]}"
    ;;
    --help)
      cat << EOM
        get_stats.sh [options]
        Get repo stats using gitstats

        Options:
          --fabric:     Get repo stats for Fabric repositories
          --sawtooth:   Get repo stats for Sawtooth repositories
          --iroha:      Get repo stats for Iroha repositories
          --burrow:     Get repo stats for Burrow repositories
          --indy:       Get repo stats for Indy repositories
          --composer:   Get repo stats for Composer repositories
          --cello:      Get repo stats for Cello repositories
          --explorer:   Get repo stats for Explorer repositories
          --quilt:      Get repo stats for Quilt repositories
          --caliper:    Get repo stats for Caliper repositories
          --gerrit:     Get repo stats for Gerrit repositories
          --github:     Get repo stats for Github repositories
          --all:        Get repo stats for all repositories

        NOTE: If no options are specified, it is as if you had specified --all
        NOTE: Multiple repository options can be specified to be included.
        NOTE: --all will override all commands for individual projects.
EOM
    exit;
    ;;
    *)
      echo "Unknown option $key"
      exit 1
    ;;
esac
shift # past argument or value
done

# if no repositories were specified, then act as if --all was specified
if [ "$repositories" == "" ]
then
  repositories="${all_repositories[@]}"
  filename+="-all"
fi

today=`date -u +%Y-%m-%d-%H-%M-%S`
mkdir -p /tmp/${filename}-${today}
cd /tmp/${filename}-${today}

for i in ${repositories[@]};
do
echo "Processing $i..."
git clone $i
BASE=`basename $i .git`
gitstats $BASE ~/public_html/$BASE
done

cd ..
