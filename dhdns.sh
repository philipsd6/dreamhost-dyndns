#!/bin/bash

APIKEY="${DHDNS_APIKEY:?You must specify your Dreamhost API key in your environment}"
DNSRECORD="${DHDNS_DNSRECORD:?You must set the target DNS record in your environment}"

SCRIPTNAME=${0##*/}

# Logging functions
function log {
    logger -p local3.info -t $SCRIPTNAME "$*"
}

function error {
    logger -p local3.error -t $SCRIPTNAME "$*"
    >&2 echo "$*"
}

# Update the uuid variable
function uuidgen {
    uuid=$(</proc/sys/kernel/random/uuid)
}

# Format list of key=value arguments into url quoted arguments
function args {
    local IFS="&"
    echo "$*"
}

# Call the Dreamhost DNS API (list_records, remove_record, add_record)
function api {
    cmd="dns-${1:-list_records}"
    shift

    uuidgen

    args=$(args key=$APIKEY unique_id=$uuid cmd=$cmd $*)

    local IFS=$'\n'
    response=($(curl --silent "https://api.dreamhost.com/?$args"))
    if [[ ${response[0]} == "error" ]]; then
        error "cmd=$cmd $*: ${response[@]:1}"
        exit 1
    fi
    printf "%s\n" "${response[@]}"
}

# BEGIN
new_ip=$(curl --silent -4 https://icanhazip.com)
old_ip=$(api | awk -v dnsrecord=$DNSRECORD '$3 == dnsrecord {print $5}')

# No update is required if the IP addresses match
if [[ $old_ip == $new_ip ]]; then
    exit 0
fi

# If the old record exists then remove it
if [[ ! -z $old_ip ]]; then
    api remove_record record=$DNSRECORD type=A value=$old_ip
    log "Removed $DNSRECORD ($old_ip)"
fi

# Finally, add the new record
api add_record record=$DNSRECORD type=A value=$new_ip comment=$SCRIPTNAME+on+$(hostname -s)
log "Added $DNSRECORD ($new_ip)"

exit 0
