#!/bin/bash

cleaned_count=0
listening_count=0
error_count=0

function log_error() {
    error_count=$((error_count+1))
    echo "ERROR: ${1}"
}

function log_info() {
    echo "INFO: ${1}"
}
function check_clean_listening() {
    listening=$(ss -ntlpH src ${1} | grep 'sshd' | wc -l)
    [ $? -ne 0 ] && log_error 'Failed to query listening ports with `ss`'
    if [ ${listening} -lt 1 ] ; then
        rm -f ${2}
        log_info "Cleaned up '${2}' due to missing listener socket"
        cleaned_count=$((listening_count+1))
    else
        listening_count=$((listening_count+1))
    fi
}

if [ -d /tmp/file_sd_configs ] ; then
    for file in $(find /tmp/file_sd_configs/ -iname "*.json") ; do
        socket=$(cat $file | jq --raw-output .[0].targets[0])
        check_clean_listening ${socket} ${file}
    done
fi

log_info "Finished - removed: ${cleaned_count}, listening: ${listening_count}"

exit ${error_count}
