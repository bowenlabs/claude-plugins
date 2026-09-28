#!/usr/bin/env bash
# Copies the seeded doc into the run's empty workspace.
set -euo pipefail
cp -R "$(dirname "$0")/fixtures/docs" ./docs
