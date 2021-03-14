#!/usr/bin/env bash

if [ ! -f "${ELISE_ROOT_DIR}/.vault.txt" ]; then
    echo "ah, ah, ah, you didn't say the magic word..."
    exit 1

fi

/bin/bash
