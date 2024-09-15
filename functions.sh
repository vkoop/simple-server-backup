#!/usr/bin/env bash

# T: turn off pseudo-tty to decrease cpu load on destination.
# o Compression=no: Turn off SSH compression.
# x: turn off X forwarding if it is on by default.

SSHPORT="${SSHPORT:-22}"

SSHOPT=""

if [ -n "${SSHPASSFILE}" ]; then
    SSHOPT="-i ${SSHPASSFILE}"
fi


SSHOPT="${SSHOPT} -l ${SSHUSERNAME} -p ${SSHPORT} -T -o Compression=no -x"
