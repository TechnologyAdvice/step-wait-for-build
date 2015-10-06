#!/bin/bash

if [ "$WERCKER_WAIT_FOR_BUILD_IS_DEPLOY" == true ]; then
    export WWFB_ENDPOINT_SUFFIX=deploys;
    export WWFB_MESSAGE='Dependent deploy complete'
else
    export WWFB_ENDPOINT_SUFFIX=builds;
    export WWFB_MESSAGE='Dependent build complete'
fi

WWFB_ENDPOINT="https://app.wercker.com/api/v3/applications/$WERCKER_WAIT_FOR_BUILD_OWNER/$WERCKER_WAIT_FOR_BUILD_APPLICATION/$WWFB_ENDPOINT_SUFFIX"

function get_status { curl -s -H "Content-type: application/json" -H "Authorization: Bearer $WERCKER_WAIT_FOR_BUILD_TOKEN" "$WWFB_ENDPOINT" | "$WERCKER_STEP_ROOT/jq" '.[0] | .status'; }

WWFB_STATUS=$(get_status)
while [ "$WWFB_STATUS" != "\"finished\"" ]; do echo "$WWFB_STATUS"; sleep 10; WWFB_STATUS=$(get_status); done;
echo "$WWFB_MESSAGE";
