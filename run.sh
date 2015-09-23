#!/bin/bash

ENDPOINT="https://app.wercker.com/api/v3/applications/$WERCKER_WAIT_FOR_BUILD_OWNER/$WERCKER_WAIT_FOR_BUILD_APPLICATION/builds"

function get_status { curl -s -H "Content-type: application/json" -H "Authorization: Bearer $WERCKER_WAIT_FOR_BUILD_TOKEN" $ENDPOINT | ./jq '.[0] | .status'; }

STATUS=$(get_status)
while [ $STATUS != "\"finished\"" ]; do echo $STATUS; sleep 10; STATUS=$(get_status); done;
echo "Dependent Build complete";
