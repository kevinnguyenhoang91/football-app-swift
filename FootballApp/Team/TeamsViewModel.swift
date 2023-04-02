//
//  MainViewModel.swift
//  FootballApp
//
//  Created by Kha Nguyễn on 30/03/2023.
//

import Foundation
import Combine
import UIKit
import CoreData
import FootballTeam

public class TeamsViewModel {
    @Published private(set) var teams: [Team]?
    @Published private(set) var teamViewModels: [TeamViewModel]?

    private let context: NSManagedObjectContext

    private var cancellables: Set<AnyCancellable> = []

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    public func fetchTeamsFromCoreData() {
        let fetchRequest: NSFetchRequest<TeamEntity> = TeamEntity.fetchRequest()
        do {
            let teamEntities = try context.fetch(fetchRequest)
            teams = teamEntities.map { Team(id: ($0.id?.uuidString)!, name: $0.name, logo: $0.logo) }

            if let teams = teams {
                teamViewModels = []
                for team in teams {
                    teamViewModels?.append(TeamViewModel(with: team))
                }
                if teams.isEmpty { fetchTeams() }
            }
        } catch {
            print("Error fetching teams from Core Data: \(error)")
        }
    }

    private func deleteTeamsInCoreData() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TeamEntity")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch let error {
            print("Error: \(error.localizedDescription)")
        }
    }

    private func saveTeamsToCoreData(_ teams: [Team]?) {
        teams?.forEach { team in
            let teamEntity = TeamEntity(context: context)
            teamEntity.id = UUID(uuidString: team.id)
            teamEntity.name = team.name
            teamEntity.logo = team.logo
        }

        do {
            try context.save()
        } catch {
            print("Error saving teams to Core Data: \(error)")
        }
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
                self?.deleteTeamsInCoreData()
                self?.saveTeamsToCoreData(teams)
            })
            .store(in: &cancellables)
    }
}

public class TeamViewModel {
    @Published private(set) var team: Team?

    public required init(with team: Team?) {
        self.team = team
    }
}
