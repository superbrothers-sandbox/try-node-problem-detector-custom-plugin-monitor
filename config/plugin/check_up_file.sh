#!/usr/bin/env bash

set -e -o pipefail; [[ -n "$DEBUG" ]] && set -x

readonly OK=0
readonly NONOK=1
readonly UNKNOWN=2

readonly UP_FILE="/custom-data/up"

if [[ -f "$UP_FILE" ]]; then
  echo "$UP_FILE exists"
  exit $OK
fi

echo "$UP_FILE does not exist"
exit $NONOK
# vim: ai ts=2 sw=2 et sts=2 ft=sh
