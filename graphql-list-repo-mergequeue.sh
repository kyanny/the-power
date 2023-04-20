.  ./.gh-api-examples.conf

# Wrap a graphql script for use with curl

# Use a bash "here" document and shell variables will be available:

read -r -d '' graphql_script <<- EOF
{
  organization(login: "$org") {
    repository(name: "$repo") {
      nameWithOwner
      mergeQueue {
        nextEntryEstimatedTimeToMerge
        entries {
          nodes {
            pullRequest {
              number
              title
            }
          }
        }
      }
    }
  }
}
EOF

echo $graphql_script

# Escape quotes and reformat script to a single line
graphql_script="$(echo ${graphql_script//\"/\\\"})"

echo $graphql_script

curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H 'Accept: application/vnd.github.audit-log-preview+json' \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        ${GITHUB_APIV4_BASE_URL} -d "{ \"query\": \"$graphql_script\"}"

