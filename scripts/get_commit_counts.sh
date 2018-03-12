#!/bin/bash
set -x

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
filename="hyperledger-commit-counts"
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
        get_commit-counts.sh [--since mm/dd/yyyy] [--until mm/dd/yyyy]
        Get commit count from Hyperledger repositories.

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
          --gerrit:   Include Gerrit repositories
          --github:   Include Github repositories
          --all:      Include all repositories (default)
          --since:    Since which date to obtain contributors (mm/dd/yyyy).
                      By default obtains contributors from start of the repo.
          --until:    Until which date to obtain contributors (mm/dd/yyyy).
                      By default obtains contributors until the end of commits.
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

  # Get count of commits
  git rev-list HEAD --count ${since:+--since=${since}} ${until:+--until=${until}} > ${outbase}.count

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
