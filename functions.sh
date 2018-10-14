#!/usr/bin/env bash

# T: turn off pseudo-tty to decrease cpu load on destination.
# o Compression=no: Turn off SSH compression.
# x: turn off X forwarding if it is on by default.

SSHPORT="${SSHPORT:-22}"
SSHOPT="-i ${SSHPASSFILE} -l ${SSHUSERNAME} -p ${SSHPORT} -T -o Compression=no -x"
