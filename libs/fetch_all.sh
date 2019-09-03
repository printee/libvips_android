#!/bin/bash

set -e
cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1

execute=true
while read line; do
  if [[ ${line:0:1} == "#" ]]; then
    if $execute; then ${line:1}; fi
  else
    if ! test -e $line; then
      execute=true
    else
      execute=false
    fi
  fi
done < .gitignore
