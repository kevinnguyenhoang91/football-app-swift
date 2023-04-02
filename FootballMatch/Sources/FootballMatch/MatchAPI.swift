//
//  API.swift
//  FootballApp
//
//  Created by Kha Nguyễn on 30/03/2023.
//

import Foundation
import Combine

public class MatchAPI {
    public static let shared = MatchAPI()
    private init() {}
        
    public func getMatches() -> AnyPublisher<Matches, Error> {
        let url = URL(string: "\(MatchDefines.baseURL)/teams/matches")!
        return URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: MatchesResponse.self, decoder: JSONDecoder())
            .map { $0.matches }
            .eraseToAnyPublisher()
    }
}
