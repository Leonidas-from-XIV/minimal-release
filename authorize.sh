#!/usr/bin/env bash

set -euo pipefail

client_id="Iv23lihr9zJsZwCzFOC2"
device_code_response=$(curl -X POST https://github.com/login/device/code -d "client_id=${client_id}")
echo $device_code_response

function urldecode() { : "${*//+/ }"; echo -e "${_//%/\\x}"; }

device_code=$(echo $device_code_response | rg "device_code=([-a-zA-Z0-9]+)" -or '$1')
echo device code $device_code
user_code=$(echo $device_code_response | rg "user_code=([-a-zA-Z0-9]*)" -or '$1')
echo user code $user_code
verification_uri=$(echo $device_code_response | rg "verification_uri=([^&]+)" -or '$1')
verification_uri=$(urldecode $verification_uri)
echo verification $verification_uri
interval=$(echo $device_code_response | rg "interval=([0-9]+)" -or '$1')
echo interval $interval

echo "Enter \"${user_code}\" at the site that opens after you press enter"
read
xdg-open "${verification_uri}"

echo "Press enter when done"
read

grant_type="urn:ietf:params:oauth:grant-type:device_code"
access_token_response=$(curl -X POST https://github.com/login/oauth/access_token -d "client_id=${client_id}&device_code=${device_code}&grant_type=${grant_type}")
echo $access_token_response
access_token=$(echo $access_token_response | rg "access_token=([^&]+)" -or '$1')
refresh_token=$(echo $access_token_response | rg "refresh_token=([^&]+)" -or '$1')

echo "Access token is \"${access_token}\""

echo "${access_token}" > .access-token
echo "${refresh_token}" > .refresh-token
