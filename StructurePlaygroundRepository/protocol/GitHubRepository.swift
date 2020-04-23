//
//  GitHubRepository.swift
//  StructurePlaygroundRepository
//
//  Created by roana0229 on 2020/04/01.
//

import Combine
import GitHubAPI
import StructurePlaygroundCore

public protocol GitHubRepository {
    func getGists(cursor: String?) -> AnyPublisher<GistListResponse, Error>
    func getProfile() -> AnyPublisher<ProfileResponse, Error>
}
