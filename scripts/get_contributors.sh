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
filename="hyperledger-contributors"
since=""
until=""
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
    --all)
      all_specified=TRUE
      filename+="-all"
      repositories="${all_repositories[@]}"
    ;;
    --since)
      since="$2"
      shift # past argument or value. 2nd shift below
      ;;
    --until)
      until="$2"
      shift # past argument or value. 2nd shift below
      ;;
    --help)
      cat << EOM
        get_contributors.sh [--since mm/dd/yyyy] [--until mm/dd/yyyy]
        Get contributors from Hyperledger repositories.

        Options:
          --fabric:   Include Fabric repositories
          --sawtooth: Include Sawtooth repositories
          --iroha:    Include Iroha repositories
          --burrow:   Include Burrow repositories
          --indy:     Include Indy repositories
          --composer: Include Composer repositories
          --cello:    Include Cello repositories
          --explorer: Include Explorer repositories
          --quilt:    Include Quilt repositories
          --caliper:  Include Caliper repositories
          --gerrit:   Include Gerrit repositories
          --github:   Include Github repositories
          --all:      Include all repositories (default)
          --since:    Includes commits more recent than this date (mm/dd/yyyy).
                      By default starts from the start of the repo.
          --until:    Includes commits older than this date (mm/dd/yyyy).
                      By default ends at the end of the repo.
          --help:     Shows this help message
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
git log --format='%aE|%aN' ${since:+--since=${since}} ${until:+--until=${until}} > ${outbase}.gitlog

# Replace duplicate emails with preferred email
sed -f ${script_dir}/email-replacement.sed -f ${script_dir}/name-replacement.sed ${outbase}.gitlog > ${outbase}.contributors

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

#rm -fr ${outdir}/source

echo "since=${since:+${since}} through until=${until:+${until}}" > ${outdir}/arguments
