//
//  API.swift
//  FootballApp
//
//  Created by Kha Nguyễn on 30/03/2023.
//

import Foundation
import Combine

public class TeamAPI {
    static let shared = TeamAPI()
    private init() {}
        
    public func getTeams() -> AnyPublisher<[Team], Error> {
        let url = URL(string: "\(Defines.baseURL)/teams")!
        return URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: TeamsResponse.self, decoder: JSONDecoder())
            .map{ $0.teams }
            .eraseToAnyPublisher()
    }
}
