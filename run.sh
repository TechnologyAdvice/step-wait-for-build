#!/bin/bash

if [ "$WERCKER_WAIT_FOR_BUILD_IS_DEPLOY" == true ]; then
    export WWFB_ENDPOINT_SUFFIX=deploys;
    export WWFB_MESSAGE='Dependent deploy complete'
else
    export WWFB_ENDPOINT_SUFFIX=builds;
    export WWFB_MESSAGE='Dependent build complete'
fi

WWFB_ENDPOINT="https://app.wercker.com/api/v3/applications/$WERCKER_WAIT_FOR_BUILD_OWNER/$WERCKER_WAIT_FOR_BUILD_APPLICATION/$WWFB_ENDPOINT_SUFFIX"

get_incomplete() {
    RESP=$(curl -s -H "Content-type: application/json" -H "Authorization: Bearer $WERCKER_WAIT_FOR_BUILD_TOKEN" "$WWFB_ENDPOINT")
    if [ "${RESP:0:1}" == "[" ]; then
        # shellcheck disable=SC2126
        EVENT_COUNT=$(echo "$RESP" | grep -o "{" | wc -w)
        DONE_COUNT=$(echo "$RESP" | grep -o "\"finished\"" | wc -w)
        echo $((EVENT_COUNT - DONE_COUNT))
    else
        echo "ERROR: Unexpected response: $RESP"
    fi
}

INCOMPLETE=$(get_incomplete)
if [ "${INCOMPLETE:0:5}" == "ERROR" ]; then
    echo "$INCOMPLETE"
    exit 1
fi
while [[ "$INCOMPLETE" -gt 1 ]]; do
    echo "$((INCOMPLETE - 1)) dependecies remaining"
    sleep 10;
    INCOMPLETE=$(get_incomplete)
    if [ "${INCOMPLETE:0:5}" == "ERROR" ]; then
        echo "$INCOMPLETE"
        exit 1
    fi
done

echo "$WWFB_MESSAGE"
