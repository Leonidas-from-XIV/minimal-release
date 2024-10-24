#!/usr/bin/env bash

token=$(cat .access-token)

echo Auth token is $token

owner="Leonidas-from-XIV"
repo="github-api-testing"
branch="main"

current_commit=$(curl -L \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer ${TOKEN}" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  "https://api.github.com/repos/${owner}/${repo}/git/ref/${branch}")

echo $current_commit
