#!/usr/bin/env bash

client_id="Iv23lihr9zJsZwCzFOC2"
device_code_response=$(curl -X POST https://github.com/login/device/code -d "client_id=${client_id}")
#device_code_response="device_code=8d01d1a9eae05a6695b17d7ad7acc119120fac8a&expires_in=899&interval=5&user_code=B030-82D8&verification_uri=https%3A%2F%2Fgithub.com%2Flogin%2Fdevice"
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
access_token=$(echo $access_token_response | rg "access_token=([^&]+)" -or '$1')

echo "Access token is \"${access_token}\""

echo "${access_token}" > .access-token
