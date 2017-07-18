#!/bin/bash

script_dir=`dirname $0`

if [[ "$script_dir" == "." ]]
then
  script_dir=$PWD
fi

. `dirname $0`/repositories.sh

#Default variables
repositories="${all_repositories[@]}" 
filename="hyperledger-commit-counts"
since=""

# Handle command line arguments
while [[ $# -gt 0 ]]
do
key="$1"

case $key in
    --since)
      since="$2"
      shift # past argument or value. 2nd shift below
      ;;
    --help)
      cat << EOM
        get_commit-counts.sh [--since mm/dd/yyyy]]
        Get commit count from all Hyperledger repositories.

        Options:
          --since: Specify from which date to obtain contributors (mm/dd/yyyy).
                   By default obtains contributors from the start of the repo.
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
mkdir -p ${outdir}/source
cd ${outdir}/source

for i in ${repositories[@]};
do
  echo "Processing $i..."
  git clone $i
  repo=`basename -s .git $i`
  cd ${repo}
  
  outbase=${outdir}/${repo}
  
  # Get count of commits
  git rev-list HEAD --count > ${outbase}.count
  
  cd ..
done

cd ..

count=0
for f in *.count
do
  c=`cat $f`
  echo $f $c >> commit-count.total
  count=$((count+c))
done

echo "TOTAL=$count" >> commit-count.total

cat commit-count.total

rm -fr ${outdir}/source
