#!/usr/bin/env bash

SCRIPT_DIR=$(dirname -- "$(readlink -f -- "$BASH_SOURCE")")

$SCRIPT_DIR/watch.sh '*.pi sample*' bash -c "\"time picat -log part$1.pi < $2\""
