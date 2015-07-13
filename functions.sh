#!/bin/bash

# T: turn off pseudo-tty to decrease cpu load on destination.
# c arcfour: use the weakest but fastest SSH encryption. Must specify "Ciphers arcfour" in sshd_config on destination.
# o Compression=no: Turn off SSH compression.
# x: turn off X forwarding if it is on by default.
SSHOPT="-i ${SSHPASSFILE} -l ${SSHUSERNAME} -p 22 -T -c arcfour -o Compression=no -x"
