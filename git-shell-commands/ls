#!/usr/bin/env sh

source "$(dirname "$0")/pre-script"

for repo in $(/usr/bin/find -maxdepth 2 -type d -name "*.git"); do echo $repo | cut -c3- | rev | cut -c5- | rev; done | sort

