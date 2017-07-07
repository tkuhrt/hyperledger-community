#!/bin/bash

. `dirname $0`/repositories.sh

#Default variables
repositories="${all_repositories[@]}" 
filename="hyperledger-contributors"
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
        get_contributors.sh [--since mm/dd/yyyy]]
        Get contributors from all Hyperledger repositories.

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

# Get emails and names of contributors of commits from the git log
git log --format='%aE|%aN' ${since:+--since=${since}} > ${outbase}.gitlog

# Replace duplicate emails with preferred email
sed -f ~/scripts/email-replacement.sed -f ~/scripts/name-replacement.sed ${outbase}.gitlog > ${outbase}.contributors

# Sort contributors based on email (1st key) ignoring case
LC_ALL=C sort -i -t "|" -k 1 -u -f ${outbase}.contributors > ${outbase}.sorted

# Get unique contributors based on email (1st key) ignoring case
#awk '!arr[tolower($1)]++' ${outbase}.sorted > ${outbase}.uniq-contributors
awk 'BEGIN { FS = "|" }
     tolower($1)!=key { if (key != "") print out; key=tolower($1); out=$0; next }
     { out=out","$2 }
     END { print out }' ${outbase}.sorted > ${outbase}.uniq-contributors

cd ..
done

#LC_ALL=C sort -i -t , -k 1 -u -f ${outdir}/*.uniq-contributors | awk '!arr[tolower($1)]++' > ${outdir}/contributors

LC_ALL=C sort -i -t "|" -k 1 -u -f ${outdir}/*.sorted | awk 'BEGIN { FS = "|" }
  tolower($1)!=key { if (key != "") print out; key=tolower($1); out=$0; next }
  { out=out","$2 }
  END { print out }' > ${outdir}/uniq-emails

LC_ALL=C sort -i -t "|" -k 2 -f ${outdir}/uniq-emails | awk 'BEGIN { FS = "|" }
  tolower($2)!=key { if (key != "") print out; key=tolower($2); out=$0; next }
  {out=$1","out }
  END { print out }' > ${outdir}/contributors

rm -fr ${outdir}/source
