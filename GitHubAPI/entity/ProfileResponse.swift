//
//  ProfileResponse.swift
//  StructurePlaygroundCore
//
//  Created by roana0229 on 2020/04/16.
//
import StructurePlaygroundCore
/*
 {
   "data": {
     "viewer": {
       "name": "Kaoru Tsutsumishita",
       "login": "roana0229",
       "email": "roana.enter@gmail.com",
       "url": "https://github.com/roana0229",
     }
   }
 }
 */
public struct ProfileResponse: Codable {
    private enum RootKeys: String, CodingKey {
        case data
    }

    private enum DataKeys: String, CodingKey {
        case viewer
    }

    private enum ViewerKeys: String, CodingKey {
        case name, login, email, url, avatarUrl
    }

    public let profile: Profile

    public init(from decoder: Decoder) throws {
        let root = try decoder.container(keyedBy: RootKeys.self)
        let data = try root.nestedContainer(keyedBy: DataKeys.self, forKey: .data)
        let viewer = try data.nestedContainer(keyedBy: ViewerKeys.self, forKey: .viewer)

        let name = try viewer.decode(String.self, forKey: .name)
        let login = try viewer.decode(String.self, forKey: .login)
        let email = try viewer.decode(String.self, forKey: .email)
        let url = try viewer.decode(String.self, forKey: .url)
        let avatarUrl = try viewer.decode(String.self, forKey: .avatarUrl)
        profile = Profile(name: name, login: login, email: email, url: url, avatarUrl: avatarUrl)
    }
}
