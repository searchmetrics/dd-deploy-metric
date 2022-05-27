#!/bin/bash

#
# Requirements: 
#   DD_API_KEY
#   SERVICE
#   PROJECT
#   BU



usage()
{
   # Display Help
   echo "Send an event to datadog"
   echo
   echo "Syntax: dd-event-script.sh <event type> <title> <text>"
   echo "Arguments:"
   echo "<alert type>   type of the event (info, warning, error, success)"
   echo "<title>        title of the event"
   echo "<text>         text to add to the event."
   echo
   echo "Additional tags may be added by adding environment variables:"
   echo " - \$GITHUB_REPOSITORY: Github repo of the project"
   echo " - \$GITHUB_REF: Github branch or reference"
   echo " - \$SERVICE: Name of the service"
   echo " - \$PROJECT: Name of the project related to this event"
   echo " - \$BU: Name of the BU responsible for monitoring the events"
}

if [ $# -ne 3 ]
then
  usage
  exit 1
fi

if [[ "$1" =~ ^(info|warning|error|success)$ ]]; then
    ALERT_TYPE=$1
else
    echo "Alert type must be one of info, warning, error, success (was: $1)"
    exit 1
fi

TITLE=$2
TEXT=$3

TIME_NOW="$(date +%s)"
TAGS=$(cat <<-END
        "git_repo:${GITHUB_REPOSITORY}",
        "branch:${GITHUB_REF}",
        "service:${SERVICE}",
        "project:${PROJECT}",
        "bu:${BU}"
END
)
curl -X POST "https://api.datadoghq.com/api/v1/events" \
-H "Content-Type: application/json" \
-H "DD-API-KEY: ${DD_API_KEY}" \
-d @- << EOF
{
  "text": "${TEXT}",
  "title": "${TITLE}",
  "alert_type": "${ALERT_TYPE}",
  "date_happened": ${TIME_NOW},
  "tags": [ ${TAGS} ]
}
EOF

