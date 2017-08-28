#!/bin/bash

script_dir=`dirname $0`

if [[ "$script_dir" == "." ]]
then
  script_dir=$PWD
fi

. `dirname $0`/repositories.sh

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
