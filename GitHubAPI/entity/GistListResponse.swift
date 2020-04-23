//
//  GistListResponse.swift
//  StructurePlaygroundCore
//
//  Created by roana0229 on 2020/04/09.
//
import StructurePlaygroundCore
/*
 {
   "data": {
     "viewer": {
       "gists": {
         "totalCount": 99,
         "edges": [
           {
             "cursor": "START_CURSOR_UUID",
             "node": {
               "id": "GIST_UUID",
               "url": "https://gist.github.com/GIST_NAME",
               "createdAt": "2017-09-20T10:06:45Z",
               "updatedAt": "2017-09-20T10:06:45Z",
               "pushedAt": "2017-09-20T10:06:45Z",
               "isPublic": false,
               "name": "GIST_NAME",
               "description": "hoge",
               "files": [
                 {
                   "name": "fuga",
                   "encoding": "UTF-8",
                   "isImage": false,
                   "text": "piyp"
                 }
               ]
             }
           },
           ...
         ]
       }
     }
   }
 }
 */
public struct GistListResponse: Codable {
    private enum RootKeys: String, CodingKey {
        case data
    }

    private enum DataKeys: String, CodingKey {
        case viewer
    }

    private enum ViewerKeys: String, CodingKey {
        case gists
    }

    private enum GistsKeys: String, CodingKey {
        case totalCount, edges
    }

    private enum EdgesKeys: String, CodingKey {
        case cursor, node
    }

    private enum NodeKeys: String, CodingKey {
        case id, url, createdAt, updatedAt, pushedAt, isPublic, name, description, files
    }

    private enum FilesKeys: String, CodingKey {
        case name, encoding, isImage, text
    }

    public let gistCount: Int
    public let gists: [Gist]

    public init(from decoder: Decoder) throws {
        let root = try decoder.container(keyedBy: RootKeys.self)
        let data = try root.nestedContainer(keyedBy: DataKeys.self, forKey: .data)
        let viewer = try data.nestedContainer(keyedBy: ViewerKeys.self, forKey: .viewer)
        let gists = try viewer.nestedContainer(keyedBy: GistsKeys.self, forKey: .gists)
        let edges = try gists.decode([Edges].self, forKey: .edges)
        gistCount = try gists.decode(Int.self, forKey: .totalCount)
        self.gists = edges.map { edge in
            Gist(cursor: edge.cursor,
                 owner: edge.node.owner.login,
                 id: edge.node.id,
                 url: edge.node.url,
                 createdAt: edge.node.createdAt,
                 updatedAt: edge.node.updatedAt,
                 pushedAt: edge.node.pushedAt,
                 isPublic: edge.node.isPublic,
                 name: edge.node.name,
                 description: edge.node.description ?? "",
                 files: edge.node.files.map {
                     GistFile(name: $0.name, encodedName: $0.encodedName, encoding: $0.encoding, isImage: $0.isImage, text: $0.text)
                 })
        }
    }
}

private struct Gists: Codable {
    let totalCount: Int
    let edges: [Edges]
}

private struct Edges: Codable {
    private enum RootKeys: String, CodingKey {
        case cursor, node
    }

    let cursor: String
    let node: Node

    public init(from decoder: Decoder) throws {
        let root = try decoder.container(keyedBy: RootKeys.self)
        cursor = try root.decode(String.self, forKey: .cursor)
        node = try root.decode(Node.self, forKey: .node)
    }
}

private struct Node: Codable {
    private enum RootKeys: String, CodingKey {
        case owner, id, url, createdAt, updatedAt, pushedAt, isPublic, name, description, files
    }

    let owner: Owner
    let id: String
    let url: String
    let createdAt: String
    let updatedAt: String
    let pushedAt: String
    let isPublic: Bool
    let name: String
    let description: String?
    let files: [Files]

    public init(from decoder: Decoder) throws {
        let root = try decoder.container(keyedBy: RootKeys.self)
        owner = try root.decode(Owner.self, forKey: .owner)
        id = try root.decode(String.self, forKey: .id)
        url = try root.decode(String.self, forKey: .url)
        createdAt = try root.decode(String.self, forKey: .createdAt)
        updatedAt = try root.decode(String.self, forKey: .updatedAt)
        pushedAt = try root.decode(String.self, forKey: .pushedAt)
        isPublic = try root.decode(Bool.self, forKey: .isPublic)
        name = try root.decode(String.self, forKey: .name)
        description = try root.decodeIfPresent(String.self, forKey: .description)
        files = try root.decode([Files].self, forKey: .files)
    }
}

private struct Owner: Codable {
    let login: String
}

private struct Files: Codable {
    private enum RootKeys: String, CodingKey {
        case name, encodedName, encoding, isImage, text
    }

    let name: String
    let encodedName: String
    let encoding: String?
    let isImage: Bool
    let text: String?

    public init(from decoder: Decoder) throws {
        let root = try decoder.container(keyedBy: RootKeys.self)
        name = try root.decode(String.self, forKey: .name)
        encodedName = try root.decode(String.self, forKey: .encodedName)
        encoding = try root.decodeIfPresent(String.self, forKey: .encoding)
        isImage = try root.decode(Bool.self, forKey: .isImage)
        text = try root.decodeIfPresent(String.self, forKey: .text)
    }
}
