#!/bin/bash
set -x

bash ./testgame/scripts/build.sh
if [ $? -eq 0 ]
then
  echo "Successfully built testgame"
else
  echo "Could not build" >&2
  cd "../.."
  set +x
  exit 2
fi

bash ./testgame/scripts/run.sh
if [ $? -eq 0 ]
then
  echo "Successfully ran"
else
  echo "Could not run" >&2
  cd "../.."
  set +x
  exit 3
fi
