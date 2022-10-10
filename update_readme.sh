#!/bin/bash
set -e && cd "${0%/*}"

dart script/update_readme.dart
