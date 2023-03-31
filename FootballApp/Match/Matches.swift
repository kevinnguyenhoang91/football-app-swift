//
//  Match.swift
//  FootballApp
//
//  Created by Kha Nguyễn on 30/03/2023.
//

import Foundation

public struct Match: Codable {
    var date: Date
    var description: String
    var home: String
    var away: String
    var winner: String?
    var highlights: URL?
    
    enum CodingKeys: String, CodingKey {
        case description
        case date
        case home
        case away
        case winner
        case highlights
    }
    
    public init(description: String, date: Date, home: String, away: String, winner: String?, highlights: URL?) {
        self.description = description
        self.date = date
        self.home = home
        self.away = away
        self.winner = winner
        self.highlights = highlights
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        description = try container.decode(String.self, forKey: .description)
        home = try container.decode(String.self, forKey: .home)
        away = try container.decode(String.self, forKey: .away)
        winner = try? container.decode(String.self, forKey: .winner)
        highlights = try? container.decode(URL.self, forKey: .highlights)

        let dateString = try container.decode(String.self, forKey: .date)

        let formatter = DateFormatter()
        formatter.dateFormat = Defines.dateFormatString
        date = formatter.date(from: dateString) ?? Date()
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(description, forKey: .description)
        try container.encode(home, forKey: .home)
        try container.encode(away, forKey: .away)
        try? container.encode(winner, forKey: .winner)
        try? container.encode(highlights, forKey: .highlights)
        
        let formatter = DateFormatter()
        formatter.dateFormat = Defines.dateFormatString
        let dateString = formatter.string(from: date)
        try container.encode(dateString, forKey: .date)
    }
}

public struct Matches: Codable {
    var previous: [Match]
    var upcoming: [Match]
}

struct MatchesResponse: Codable {
    var matches: Matches
}
