//
//  GitHubRepository.swift
//  StructurePlaygroundRepository
//
//  Created by roana0229 on 2020/04/01.
//

import Combine
import Foundation
import GitHubAPI
import StructurePlaygroundCore

public struct GitHubRepositoryFactory {
    public static func make(personalAccessToken: String) -> GitHubRepository {
        GitHubRepositoryImpl(personalAccessToken: personalAccessToken)
    }
}

struct GitHubRepositoryImpl: GitHubRepository {
    let personalAccessToken: String

    fileprivate init(personalAccessToken: String) {
        self.personalAccessToken = personalAccessToken
    }

    func getGists(cursor: String?) -> AnyPublisher<GistListResponse, Error> {
        GitHubAPI.getGists(token: personalAccessToken, cursor: cursor)
    }

    func getProfile() -> AnyPublisher<ProfileResponse, Error> {
        GitHubAPI.getProfile(token: personalAccessToken)
    }
}
