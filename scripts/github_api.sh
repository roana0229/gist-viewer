#!/bin/bash -eu

data=$(curl -H "Authorization: token $GITHUB_TOKEN" -s -d @- https://api.github.com/graphql << GQL
{ "query": "
  query {
    viewer {
      name
      login
      email
      url
      gists(first: 20, orderBy: {field: CREATED_AT, direction: DESC}, privacy: ALL) {
        totalCount
        edges {
          cursor
          node {
            id
            url
            createdAt
            updatedAt
            pushedAt
            isPublic
            name
            description
            files {
              name
              encodedName
              isImage
              encoding
              text
            }
          }
        }
      }
    }
  }
" }
GQL
)

echo $data