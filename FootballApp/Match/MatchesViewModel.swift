//
//  MainViewModel.swift
//  FootballApp
//
//  Created by Kha Nguyễn on 30/03/2023.
//

import Foundation
import Combine

public class MatchesViewModel: NSObject {
    @Published private(set) var matches: Matches?
    
    private var cancellables: Set<AnyCancellable> = []
    
    public override init() {
        super.init()
    }
    
    public func fetchMatches() {
        MatchAPI.shared.getMatches()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] matches in
                self?.matches = matches
            })
            .store(in: &cancellables)
    }
}

public class MatchViewModel: NSObject {
    @Published private(set) var match: Match?
    @Published private(set) var homeTeam: Team?
    @Published private(set) var awayTeam: Team?

    public required init(with match: Match?, homeTeam: Team?, awayTeam: Team?) {
        super.init()
        self.match = match
        self.homeTeam = homeTeam
        self.awayTeam = awayTeam
    }
}
