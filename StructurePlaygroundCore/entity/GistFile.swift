//
//  GistFile.swift
//  StructurePlaygroundEntity
//
//  Created by roana0229 on 2020/04/01.
//

public struct GistFile: Codable {
    public let name: String
    public let encodedName: String
    public let encoding: String?
    public let isImage: Bool
    public let text: String?

    public init(name: String, encodedName: String, encoding: String?, isImage: Bool, text: String?) {
        self.name = name
        self.encodedName = encodedName
        self.encoding = encoding
        self.isImage = isImage
        self.text = text
    }
}
