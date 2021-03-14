#!/usr/bin/env bash

if [ ! -f "${ELISE_ROOT_DIR}/.vault.txt" ]; then
    echo "missing ansible-vault password file"
    exit 1

fi

/bin/bash
