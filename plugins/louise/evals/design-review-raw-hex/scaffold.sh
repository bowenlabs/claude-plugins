#!/usr/bin/env bash
# Copies the fixture site into the run's empty workspace.
set -euo pipefail
cp -R "$(dirname "$0")/fixtures/site" ./site
