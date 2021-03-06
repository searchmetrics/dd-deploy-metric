#!/bin/bash

#
# Requirements: 
#   DD_CLIENT_API_KEY
#   SERVICE
#   PROJECT
#   BU


TIME_NOW="$(date +%s)"
# am running on travis-ci platform?
if [[ "x-$TRAVIS" == "x-true" ]]
then
    METRIC_TAGS=\"ci_platform:travis\",\"git_repo:$TRAVIS_REPO_SLUG\",\"branch:$TRAVIS_BRANCH\",\"build_id:$TRAVIS_BUILD_ID\",\"service:$SERVICE\",\"project:$PROJECT\",\"bu:$BU\"
else
    METRIC_TAGS=\"ci_platform:github_actions\",\"git_repo:$GITHUB_REPOSITORY\",\"branch:$GITHUB_REF\",\"build_id:$GITHUB_RUN_ID\",\"service:$SERVICE\",\"project:$PROJECT\",\"bu:$BU\"
fi

curl -X POST "https://api.datadoghq.com/api/v1/series?api_key=${DD_CLIENT_API_KEY}" \
-H "Content-Type: application/json" \
-d @- << EOF
{
  "series": [
    {
      "metric": "sm_internals.deploy",
      "points": [
        [
          "${TIME_NOW}",
          "1.0"
        ]
      ],
      "tags": [ ${METRIC_TAGS} ],
      "type": "count"
    }
  ]
}
EOF
