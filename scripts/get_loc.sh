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
repositories="${all_repositories[@]}"
filename="hyperledger-loc"
since=""

# Handle command line arguments
while [[ $# -gt 0 ]]
do
key="$1"

case $key in
    --help)
      cat << EOM
        get_loc.sh
        Get the lines of code from all Hyperledger repositories.

        Options:
          --help:  Shows this help message
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

today=`date -u +%Y-%m-%d-%H-%M-%S`
outdir=/tmp/${filename}-${today}
outfile=${outdir}/loc.csv
mkdir -p ${outdir}/source
cd ${outdir}/source

cat "Repository,Number of Files,Lines of Code" > ${outfile}

for i in ${repositories[@]};
do
echo "Processing $i..."
git clone $i
repo=`basename -s .git $i`
cd ${repo}

hash=`git hash-object -t tree /dev/null`
out=`git diff --shortstat $hash | sed -e "s/ files changed, /,/" -e "s/ insertions.*$//"`
echo "$repo,$out" >> ${outfile}

cd ..
done

rm -fr ${outdir}/source
