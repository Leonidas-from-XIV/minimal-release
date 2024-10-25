#!/usr/bin/env bash

set -euo pipefail

token=$(cat .access-token)

echo Auth token is $token

owner="Leonidas-from-XIV"
repo="github-api-testing"
ref="heads/main"

url="https://api.github.com/repos/${owner}/${repo}/git/ref/${ref}"
echo $url

current_commit=$(curl -L \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer ${token}" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  "${url}")

echo $current_commit | jq .
