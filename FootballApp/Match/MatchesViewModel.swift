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
    @Published private(set) var previousMatchViewModels: [MatchViewModel]?
    @Published private(set) var upcomingMatchViewModels: [MatchViewModel]?
    
    private var cancellables: Set<AnyCancellable> = []
    
    public override init() {
        super.init()
    }
    
    public func fetchMatches() {
        MatchAPI.shared.getMatches()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] matches in
                self?.previousMatchViewModels = []
                for match in matches.previous {
                    self?.previousMatchViewModels?.append(MatchViewModel(with: match))
                }
                self?.upcomingMatchViewModels = []
                for match in matches.upcoming {
                    self?.upcomingMatchViewModels?.append(MatchViewModel(with: match))
                }
                self?.matches = matches
            })
            .store(in: &cancellables)
    }
}

public class MatchViewModel: NSObject {
    @Published private(set) var match: Match?

    public required init(with match: Match?) {
        super.init()
        self.match = match
    }
}
