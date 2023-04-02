//
//  Match.swift
//  FootballApp
//
//  Created by Kha Nguyễn on 30/03/2023.
//

import Foundation

public struct Match: Codable, Hashable {
    public var date: Date
    public var description: String
    public var home: String
    public var away: String
    public var winner: String?
    public var highlights: URL?

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
        description = try container.decode(String.self, forKey: .description).trimmingCharacters(in: .whitespacesAndNewlines)
        home = try container.decode(String.self, forKey: .home).trimmingCharacters(in: .whitespacesAndNewlines)
        away = try container.decode(String.self, forKey: .away).trimmingCharacters(in: .whitespacesAndNewlines)
        winner = try? container.decode(String.self, forKey: .winner).trimmingCharacters(in: .whitespacesAndNewlines)
        highlights = try? container.decode(URL.self, forKey: .highlights)

        let dateString = try container.decode(String.self, forKey: .date).trimmingCharacters(in: .whitespacesAndNewlines)

        let formatter = DateFormatter()
        formatter.dateFormat = MatchDefines.dateFormatString
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
        formatter.dateFormat = MatchDefines.dateFormatString
        let dateString = formatter.string(from: date)
        try container.encode(dateString, forKey: .date)
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(description)
        hasher.combine(home)
        hasher.combine(away)
        hasher.combine(winner)
        hasher.combine(highlights)
        hasher.combine(date)
    }
}

public struct Matches: Codable {
    public var previous: [Match]
    public var upcoming: [Match]

    public init(previous: [Match], upcoming: [Match]) {
        self.previous = previous
        self.upcoming = upcoming
    }
}

struct MatchesResponse: Codable {
    var matches: Matches
}
