#!/bin/bash

#####################################################################################################
# Deploy all Docker containers to a local Docker compose network, and run the SPA locally if required
#####################################################################################################

#
# Ensure that we are in the folder containing this script
#
cd "$(dirname "${BASH_SOURCE[0]}")"

#
# First check prerequisites
#
if [ ! -f './license.json' ]; then
  echo 'Please provide a license.json file in the root folder in order to deploy the system'
  exit 1
fi

#
# Get the OAuth Agent and OAuth Proxy arguments provided
#
OAUTH_AGENT="$1"
OAUTH_PROXY="$2"

#
# Deploy security components by running the child script
#
if [ "$OAUTH_AGENT" == 'FINANCIAL' ]; then
  ./deployment/financial/deploy.sh $OAUTH_AGENT $OAUTH_PROXY
else
  ./deployment/standard/deploy.sh $OAUTH_AGENT $OAUTH_PROXY
fi
if [ $? -ne 0 ]; then
  echo 'Problem encountered building deployment resources'
  exit
fi
