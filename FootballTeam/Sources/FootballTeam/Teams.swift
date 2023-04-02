//
//  Team.swift
//  FootballApp
//
//  Created by Kha Nguyễn on 30/03/2023.
//

import Foundation

public struct Team: Codable {
    public let id: String
    public let name: String?
    public let logo: URL?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case logo
    }
    
    public init(id: String, name: String?, logo: URL?) {
        self.id = id
        self.name = name
        self.logo = logo
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id).trimmingCharacters(in: .whitespacesAndNewlines)
        name = try? container.decode(String.self, forKey: .name).trimmingCharacters(in: .whitespacesAndNewlines)
        logo = try? container.decode(URL.self, forKey: .logo)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try? container.encode(name, forKey: .name)
        try? container.encode(logo, forKey: .logo)
    }
}

struct TeamsResponse: Codable {
    let teams: [Team]
}
