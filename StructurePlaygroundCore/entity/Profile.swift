//
//  Profile.swift
//  StructurePlaygroundCore
//
//  Created by roana0229 on 2020/04/16.
//

public struct Profile: Codable {
    public let name: String
    public let login: String
    public let email: String
    public let url: String
    public let avatarUrl: String

    public init(name: String, login: String, email: String, url: String, avatarUrl: String) {
        self.name = name
        self.login = login
        self.email = email
        self.url = url
        self.avatarUrl = avatarUrl
    }
}
