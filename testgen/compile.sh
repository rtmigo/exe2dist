#!/bin/bash
set -e && cd "${0%/*}"


go env -w GO111MODULE=off
~/go/bin/gox -output="../test/samples/go_{{.OS}}_{{.Arch}}"