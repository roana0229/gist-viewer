//
//  GitHubAPI.swift
//  GitHubAPI
//
//  Created by roana0229 on 2020/04/09.
//

import Alamofire
import Combine
import StructurePlaygroundCore

public enum GitHubAPIError: Error {
    case error(message: String)
}

public struct GitHubAPI {
    public static func getGists(token: String, cursor: String?) -> AnyPublisher<GistListResponse, Error> {
        let afterQuery: String = {
            if let c = cursor {
                return "after: \"\(c)\", "
            } else {
                return ""
            }
        }()
        return GitHubAPI.requestGraphQL(GistListResponse.self, token: token, query: """
          query {
            viewer {
              gists(first: 10, \(afterQuery)orderBy: {field: CREATED_AT, direction: DESC}, privacy: ALL) {
                totalCount
                edges {
                  cursor
                  node {
                    owner {
                      login
                    }
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
                      encoding
                      isImage
                      text
                    }
                  }
                }
              }
            }
          }
        """)
    }

    public static func getProfile(token: String) -> AnyPublisher<ProfileResponse, Error> {
        GitHubAPI.requestGraphQL(ProfileResponse.self, token: token, query: """
          query {
            viewer {
              name
              login
              email
              url
              avatarUrl(size: 512)
            }
          }
        """)
    }

    private static func requestGraphQL<RESPONSE: Codable>(_ type: RESPONSE.Type, token: String, query: String) -> AnyPublisher<RESPONSE, Error> {
        Deferred {
            Future<RESPONSE, Error> { promise in
                let headers: HTTPHeaders = [.authorization(bearerToken: token)]
                AF.request("https://api.github.com/graphql", method: .post, parameters: ["query": query], encoding: JSONEncoding.default, headers: headers).response { response in
                    guard let data = response.data else {
                        promise(.failure(GitHubAPIError.error(message: "empty reponse")))
                        return
                    }
                    guard let response = try? JSONDecoder().decode(type.self, from: data) else {
                        promise(.failure(GitHubAPIError.error(message: String(data: data, encoding: .utf8) ?? "empty error")))
                        return
                    }
                    promise(.success(response))
                }
            }
        }.eraseToAnyPublisher()
    }
}
