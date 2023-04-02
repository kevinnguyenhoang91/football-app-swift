//
//  MainViewModel.swift
//  FootballApp
//
//  Created by Kha Nguyễn on 30/03/2023.
//

import Foundation
import Combine
import CoreData
import FootballMatch

public class MatchesViewModel {
    @Published private(set) var matches: Matches?
    @Published private(set) var previousMatchViewModels: [MatchViewModel]?
    @Published private(set) var upcomingMatchViewModels: [MatchViewModel]?
    
    private let context: NSManagedObjectContext
    
    private var cancellables: Set<AnyCancellable> = []
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    public func fetchMatchesFromCoreData() {
        let fetchUpcomingRequest: NSFetchRequest<UpcomingMatchEntity> = UpcomingMatchEntity.fetchRequest()
        let fetchPreviousRequest: NSFetchRequest<PreviousMatchEntity> = PreviousMatchEntity.fetchRequest()
        do {
            let upcomingMatchEntities = try context.fetch(fetchUpcomingRequest)
            let upcomingMatches = upcomingMatchEntities.map { Match(description: $0.desc!, date: $0.date!, home: $0.home!, away: $0.away!, winner: $0.winner, highlights: $0.highlights) }
            let previousMatchEntities = try context.fetch(fetchPreviousRequest)
            let previousMatches = previousMatchEntities.map { Match(description: $0.desc!, date: $0.date!, home: $0.home!, away: $0.away!, winner: $0.winner, highlights: $0.highlights) }
                
            matches = Matches(previous: previousMatches, upcoming: upcomingMatches)
            
            if let matches = matches {
                previousMatchViewModels = []
                for match in matches.previous {
                    previousMatchViewModels?.append(MatchViewModel(with: match))
                }
                upcomingMatchViewModels = []
                for match in matches.upcoming {
                    upcomingMatchViewModels?.append(MatchViewModel(with: match))
                }
            }
            
            if upcomingMatches.isEmpty || previousMatches.isEmpty { fetchMatches() }
        } catch {
            print("Error fetching teams from Core Data: \(error)")
        }
    }
    
    private func deleteTeamsInCoreData() {
        let fetchUpcomingRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UpcomingMatchEntity")
        let deleteUpcomingRequest = NSBatchDeleteRequest(fetchRequest: fetchUpcomingRequest)
        
        let fetchPreviousRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "PreviousMatchEntity")
        let deletePreviousRequest = NSBatchDeleteRequest(fetchRequest: fetchPreviousRequest)

        do {
            try context.execute(deleteUpcomingRequest)
            try context.execute(deletePreviousRequest)
            try context.save()
        } catch let error {
            print("Error: \(error.localizedDescription)")
        }
    }
    
    private func saveMatchesToCoreData(_ matches: Matches?) {
        if let matches = matches {
            matches.upcoming.forEach { match in
                let upcomingEntity = UpcomingMatchEntity(context: context)
                upcomingEntity.desc = match.description
                upcomingEntity.home = match.home
                upcomingEntity.away = match.away
                upcomingEntity.winner = match.winner
                upcomingEntity.date = match.date
                upcomingEntity.highlights = match.highlights
            }
            
            matches.previous.forEach { match in
                let previousEntity = PreviousMatchEntity(context: context)
                previousEntity.desc = match.description
                previousEntity.home = match.home
                previousEntity.away = match.away
                previousEntity.winner = match.winner
                previousEntity.date = match.date
                previousEntity.highlights = match.highlights
            }
        }
        
        do {
            try context.save()
        } catch {
            print("Error saving teams to Core Data: \(error)")
        }
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
                self?.deleteTeamsInCoreData()
                self?.saveMatchesToCoreData(matches)
            })
            .store(in: &cancellables)
    }
}

public class MatchViewModel {
    @Published private(set) var match: Match?

    public required init(with match: Match?) {
        self.match = match
    }
}

extension MatchViewModel: Hashable {
    public static func == (lhs: MatchViewModel, rhs: MatchViewModel) -> Bool {
        return lhs.match == rhs.match
    }
    
    public func hash(into hasher: inout Hasher) {
        match?.hash(into: &hasher)
    }
}
