#!/bin/bash
set -e && cd "${0%/*}"

dart script/update_constants.dart
dart script/update_readme.dart
git add .
git commit -m "!!master !!release" --allow-empty
git push