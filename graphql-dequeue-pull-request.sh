.  ./.gh-api-examples.conf

# Wrap a graphql script for use with curl

# Use a bash "here" document and shell variables will be available:

pull_request_id=$(./graphql-get-pull-request-id.sh | jq '.data.repository.pullRequest.id')

read -r -d '' graphql_script <<- EOF
mutation {
  dequeuePullRequest(input: { id: $pull_request_id }) {
    clientMutationId
    mergeQueueEntry {
      position
      estimatedTimeToMerge
      pullRequest{
        title
        number
      }      
    }
  }
}

EOF

# Escape quotes and reformat script to a single line
graphql_script="$(echo ${graphql_script//\"/\\\"})"


curl ${curl_custom_flags} \
     -H "Accept: application/vnd.github.v3+json" \
     -H 'Accept: application/vnd.github.audit-log-preview+json' \
     -H "Authorization: Bearer ${GITHUB_TOKEN}" \
        ${GITHUB_APIV4_BASE_URL} -d "{ \"query\": \"$graphql_script\"}"

