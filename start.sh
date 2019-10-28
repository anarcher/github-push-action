#!/bin/sh
set -e

INPUT_BRANCH=${INPUT_BRANCH:-master}
INPUT_FORCE=${INPUT_FORCE:-false}
INPUT_DIRECTORY=${INPUT_DIRECTORY:-'.'}
INPUT_PULL=${INPUT_PULL:-false}
_FORCE_OPTION=''
REPOSITORY=${INPUT_REPOSITORY:-$GITHUB_REPOSITORY}

echo "Push to branch $INPUT_BRANCH";
[ -z "${INPUT_GITHUB_TOKEN}" ] && {
    echo 'Missing input "github_token: ${{ secrets.GITHUB_TOKEN }}".';
    exit 1;
};

if ${INPUT_FORCE}; then
    _FORCE_OPTION='--force'
fi

cd ${INPUT_DIRECTORY}

remote_repo="https://${GITHUB_ACTOR}:${INPUT_GITHUB_TOKEN}@github.com/${REPOSITORY}.git"

if ${INPUT_PULL}; then
    echo "Pull from branch $INPUT_BRANCH before pushing";
    git config --global user.email "github-action@example.com"
    git config --global user.name "github-action"
    git pull "${remote_repo}" ${INPUT_BRANCH} --allow-unrelated-histories;
fi
git push "${remote_repo}" HEAD:${INPUT_BRANCH} --follow-tags $_FORCE_OPTION;
