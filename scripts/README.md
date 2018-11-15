# Scripts
Contains a collection of scripts used to support the Hyperledger community.

## `get_commit_counts.sh`
Get the number of commits from all source repositories (as defined in `repositories.sh`). Will output the results at:
```
/tmp/hyperledger-commit-counts-<date>/commit-count.total
```

The results file is in the format of:
```
<repo>.count <count>
...
<repo>.count <count>
TOTAL: <total-count>
```

### Requirements
* `git`

### Usage
This script is used to get the number of commits that have occurred against all Hyperledger repositories
```
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
```

## `get_contributors.sh`
Pull a list of contributors from all source repositories (as defined in `repositories.sh`). Will output the results at:
```
/tmp/hyperledger-contributors-<date>/contributors
```

The results file is in the format of:
```
email|name
```

It is possible that a single person may have used multiple emails and/or names to contribute code. In that case, the email and/or name column will contain multiple values separated by a comma (,).

The `mailmap` file contains a number of [mappings](https://git-scm.com/docs/git-shortlog) that will ensure that the same contributor does not have multiple email addresses and/or names.

The `cleanup.sed` file will delete non-contributor entries (e.g., those created by tools) and ensure that the format is as specified above.

### Requirements
* `git`
* `sed`
* `awk`
* `sort`

### Usage
This script is used on a yearly basis to get a list of contributors in the past year for TSC election rolls.
```
get_contributors.sh [--since mm/dd/yyyy]]
Get contributors from all Hyperledger repositories.

Options:
  --since: Specify from which date to obtain contributors (mm/dd/yyyy).
           By default obtains contributors from the start of the repo.
  --until: Specify the date upto which to obtain contributors (mm/dd/yyyy).
           By default obtains contributors to the end of the repo.
  --help:  Shows this help message
```

## `create_tarballs.sh`
Creates a GZIP'd tarball of the latest source code for the specified repositories. It does this by cloning the source code from Gerrit or Github and then creating a GZIP'd tarball containing the checked out code. The tarball will be created in:

```
/tmp/hyperledger-source-<project-name>-<date>.tar.gz
```

A single project may contain multiple source repositories (as defined in `repositories.sh`). The tarball will contain all files from each of the repositories making up the project.

### Requirements
* `git`
* `gzip`
* `tar`

### Usage
This script is used for creating GZIP'd tarballs that can be used by the license scanning process.
```
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
  --gerrit:     Create a tarball containing Gerrit repositories
  --github:     Create a tarball containing Github repositories
  --all:        Create a tarball containing all repositories
  --no-tarball: Check out files only

NOTE: If no options are specified, it is as if you had specified --all
NOTE: Multiple repository options can be specified to be included in a
      single tarball.
NOTE: --all will override all commands for individual projects.
```
