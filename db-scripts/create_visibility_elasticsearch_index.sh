#!/bin/sh
if [ "$1" = "" ]
then
  echo "You need to specify an environment"
  exit
fi

SCRIPT_NAME=$( basename $0 )
SCRIPT_DIR="$( cd "$( dirname "$0" )" && pwd )"
PRJ_DIR="$( cd "${SCRIPT_DIR}/.." && pwd )"
PRJ_NAME=$( basename ${PRJ_DIR} )

echo "** Running $SCRIPT_NAME in project $PRJ_NAME **"

env="${1:-}"

if [ -f "$PRJ_DIR/.envs/$env" ]; then
    source "$PRJ_DIR/.envs/$env"
else
    echo "Environment file not found"
    exit
fi

export ES_SCHEME=https
export ES_HOST=$TEMPORAL_ES_HOSTS
export ES_PORT=443
export ES_SERVER="$ES_HOST:$ES_PORT"
export ES_USER=$TEMPORAL_ES_MASTER_USERNAME
export ES_PWD=$TEMPORAL_ES_MASTER_PASSWORD
export ES_VERSION=v7
export ES_VIS_INDEX=temporal_visibility_v1

echo "$ES_SERVER"
echo "$ES_HOST"

TEMPORAL_REPO_HOME="/Users/pomoni/bee/temporal" # Absolute Path to the temporal repo, change it to your repo path

# Change to the directory specified by TEMPORAL_REPO_DIR
cd "$TEMPORAL_REPO_HOME" || { echo "Failed to change directory to $TEMPORAL_REPO_HOME"; exit 1; }

SETTINGS_URL="${ES_SERVER}/_cluster/settings"
SETTINGS_FILE=${TEMPORAL_REPO_HOME}/schema/elasticsearch/visibility/cluster_settings_${ES_VERSION}.json
TEMPLATE_URL="${ES_SERVER}/_template/temporal_visibility_v1_template"
SCHEMA_FILE=${TEMPORAL_REPO_HOME}/schema/elasticsearch/visibility/index_template_${ES_VERSION}.json
INDEX_URL="${ES_SERVER}/${ES_VIS_INDEX}"

echo "Creating elastic search settings"
curl --fail --user "${ES_USER}":"${ES_PWD}" -X PUT "${SETTINGS_URL}" -H "Content-Type: application/json" --data-binary "@${SETTINGS_FILE}" --write-out "\n"

echo "Creating elastic search schema"
curl --fail --user "${ES_USER}":"${ES_PWD}" -X PUT "${TEMPLATE_URL}" -H 'Content-Type: application/json' --data-binary "@${SCHEMA_FILE}" --write-out "\n"

echo "Creating elastic search index"
curl --user "${ES_USER}":"${ES_PWD}" -X PUT "${INDEX_URL}" --write-out "\n"


