#!/bin/sh

# This script needs to work in Alpine Linux without bash.

set -e

# This script is meant to be run from the root of the repo, but this enables it
# to work from within `ruby` as well:
# I found the suggestion to use case here: https://stackoverflow.com/a/2830416/7012
case `pwd` in
  *ruby) echo "" ;;
  *)      cd ruby ;;
esac

# The -i is here just in case someone inserts an interactive debugging
#   breakpoint into any of the code under test (or the tests).
# The -t is needed so the output will be displayed in color.
docker run -it --rm `docker build -q .` cucumber
