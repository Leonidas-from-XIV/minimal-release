#!/usr/bin/env bash
set -euo pipefail

client_id="Iv23lihr9zJsZwCzFOC2"
grant_type="refresh_token"
refresh_token=$(cat .refresh-token)

access_token_response=$(curl -X POST https://github.com/login/oauth/access_token -d "client_id=${client_id}&grant_type=${grant_type}&refresh_token=${refresh_token}")
echo $access_token_response

access_token=$(echo $access_token_response | rg "access_token=([^&]+)" -or '$1')
refresh_token=$(echo $access_token_response | rg "refresh_token=([^&]+)" -or '$1')

echo "${access_token}" > .access-token
echo "${refresh_token}" > .refresh-token
