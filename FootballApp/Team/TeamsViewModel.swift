//
//  MainViewModel.swift
//  FootballApp
//
//  Created by Kha Nguyễn on 30/03/2023.
//

import Foundation
import Combine
import UIKit

public class TeamsViewModel: NSObject {
    @Published private(set) var teams: [Team]?
    @Published private(set) var teamViewModels: [TeamViewModel]?

    private var cancellables: Set<AnyCancellable> = []
    
    public override init() {
        super.init()
    }
    
    public func fetchTeams() {
        TeamAPI.shared.getTeams()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] teams in
                self?.teamViewModels = []
                for team in teams {
                    self?.teamViewModels?.append(TeamViewModel(with: team))
                }
                self?.teams = teams
            })
            .store(in: &cancellables)
    }
}

public class TeamViewModel: NSObject {
    @Published private(set) var team: Team?

    public required init(with team: Team?) {
        super.init()
        self.team = team
    }
}
