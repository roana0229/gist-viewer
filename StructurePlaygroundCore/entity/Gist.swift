//
//  Gist.swift
//  StructurePlaygroundEntity
//
//  Created by roana0229 on 2020/04/01.
//

public struct Gist: Codable {
    public let cursor: String
    public let owner: String
    public let id: String
    public let url: String
    public let createdAt: String
    public let updatedAt: String
    public let pushedAt: String
    public let isPublic: Bool
    public let name: String
    public let description: String
    public let files: [GistFile]

    public init(cursor: String, owner: String, id: String, url: String, createdAt: String, updatedAt: String, pushedAt: String, isPublic: Bool, name: String, description: String, files: [GistFile]) {
        self.cursor = cursor
        self.owner = owner
        self.id = id
        self.url = url
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.pushedAt = pushedAt
        self.isPublic = isPublic
        self.name = name
        self.description = description
        self.files = files
    }
}
