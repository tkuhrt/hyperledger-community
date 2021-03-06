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
tarball=TRUE
output_dir=/tmp

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
    --ursa)
      if [[ "$all_specified" == FALSE ]] ; then
        repositories+=( "${ursa_repositories[@]}" )
        filename+="-ursa"
      fi
    ;;
    --grid)
      if [[ "$all_specified" == FALSE ]] ; then
        repositories+=( "${grid_repositories[@]}" )
        filename+="-grid"
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
    --all)
      all_specified=TRUE
      filename+="-all"
      repositories="${all_repositories[@]}"
    ;;
    --no-tarball)
      tarball=FALSE
    ;;
    --output-dir)
      output_dir=$2
      shift # past argument or value. 2nd shift below
    ;;
    --help)
      cat << EOM
        create_tarball.sh [options]
        Create a tarball of the latest source in the specified repositories.

        Options:
          --fabric:     Create a tarball containing Fabric repositories
          --sawtooth:   Create a tarball containing Sawtooth repositories
          --iroha:      Create a tarball containing Iroha repositories
          --burrow:     Create a tarball containing Burrow repositories
          --indy:       Create a tarball containing Indy repositories
          --composer:   Create a tarball containing Composer repositories
          --cello:      Create a tarball containing Cello repositories
          --explorer:   Create a tarball containing Explorer repositories
          --quilt:      Create a tarball containing Quilt repositories
          --caliper:    Create a tarball containing Caliper repositories
          --ursa:       Create a tarball containing Ursa repositories
          --grid:       Create a tarball containing Grid repositories
          --gerrit:     Create a tarball containing Gerrit repositories
          --github:     Create a tarball containing Github repositories
          --all:        Create a tarball containing all repositories
          --no-tarball: Check out files only
          --output-dir <dir>: Where should output be placed. (Default: /tmp)
          --help:       Shows this help message

        NOTE: If no options are specified, it is as if you had specified --all
        NOTE: Multiple repository options can be specified to be included in a
              single tarball.
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
today_date_only=`date -u +%Y-%m-%d`
mkdir -p /tmp/${filename}-${today}
cd /tmp/${filename}-${today}

for i in ${repositories[@]};
do
echo "Processing $i..."
git clone $i
done

cd ..
if [[ "$tarball" == TRUE ]] ; then
  tar czvf ${filename}-${today}.tar.gz --exclude .git ${filename}-${today}
  rm -fr ${filename}-${today}
fi

mkdir -p "${output_dir}"/${today_date_only}/tarballs
mv ${filename}-${today}.tar.gz "${output_dir}"/${today_date_only}/tarballs
