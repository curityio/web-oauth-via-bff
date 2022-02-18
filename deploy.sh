#!/bin/bash

#####################################################################
# A script to spin up Docker images with their deployed configuration
#####################################################################

if [ "$1" == 'financial' ]; then
  DEPLOYMENT_SCENARIO='financial'
else
  DEPLOYMENT_SCENARIO='standard'
fi

#
# These can be edited to use different test domains
# For the financial scenario, to simplify certificates, IDSVR_DOMAIN must be a subdomain of BASE_DOMAIN
#
export BASE_DOMAIN='example.com'
export WEB_SUBDOMAIN='www'
export API_SUBDOMAIN='api'
export IDSVR_DOMAIN='login.example.com'

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
# Check that the build script has been run
#
if [ ! -d 'resources' ]; then
  echo 'Please run the build script before running the deployment script'
  exit 1
fi

#
# Copy in the license file
#
cp ./license.json "./resources/$DEPLOYMENT_SCENARIO/idsvr/"

#
# Deploy resources by running the child script
#
cd "./resources/$DEPLOYMENT_SCENARIO"
./deploy.sh
if [ $? -ne 0 ]; then
  echo 'Problem encountered building deployment resources'
  exit
fi
