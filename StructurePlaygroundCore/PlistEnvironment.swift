//
//  PlistEnvironment.swift
//  StructurePlayground
//
//  Created by roana0229 on 2020/04/13.
//

import Foundation

public enum PlistEnvironment: String {
    case githubApiToken = "GITHUB_TOKEN"

    public var value: String {
        guard let value = PlistEnvironment.infoDictionary[rawValue] as? String else {
            fatalError("Root URL not set in plist for this environment")
        }
        return value
    }

    private static let infoDictionary: [String: Any] = {
        guard let dict = Bundle.main.infoDictionary else {
            fatalError("Plist file not found")
        }
        return dict
    }()
}
