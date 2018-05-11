#!/bin/bash

set -e

# This script is meant to be run from the root of the repo, but this enables it
# to work from within `ruby` as well:
if [[ `pwd` != *"/ruby" ]]; then cd ruby; fi

# The -i is here just in case someone inserts an interactive debugging
#   breakpoint into any of the code under test (or the tests).
# The -t is needed so the output will be displayed in color.
docker run -it --rm `docker build -q .` cucumber
