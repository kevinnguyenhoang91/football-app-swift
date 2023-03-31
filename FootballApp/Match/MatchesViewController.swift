//
//  MatchesViewController.swift
//  FootballApp
//
//  Created by Kha Nguyễn on 30/03/2023.
//

import Foundation
import UIKit
import Combine


public class MatchesViewController: UICollectionViewController {
    private var cancellables = Set<AnyCancellable>()
    private var matchesViewModel = MatchesViewModel()
    private var teamsViewModel = TeamsViewModel()
        
    private let segmentedControl = UISegmentedControl(items: ["Upcoming", "Previous"])
    
    public override func viewDidLoad() {
        super.viewDidLoad()
                
        title = "Football Matches"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        
        collectionView.backgroundColor = .clear
        view.backgroundColor = .white
        
        view.addSubview(segmentedControl)
        segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged(_:)), for: .valueChanged)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], for: .normal)
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], for: .selected)

        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        segmentedControl.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        segmentedControl.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -40).isActive = true
        segmentedControl.heightAnchor.constraint(equalToConstant: 40).isActive = true

        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 10).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

        collectionView.register(PreviousMatchCell.self, forCellWithReuseIdentifier: "PreviousMatchCell")
        collectionView.register(UpcomingMatchCell.self, forCellWithReuseIdentifier: "UpcomingMatchCell")
        
        matchesViewModel.$matches
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.collectionView.reloadData()
            }
            .store(in: &cancellables)
        
        teamsViewModel.$teams
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.matchesViewModel.fetchMatches()
            }
            .store(in: &cancellables)
        
        teamsViewModel.fetchTeams()
    }
    
    @objc public func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        collectionView.reloadData()
    }
    
    public override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            return matchesViewModel.matches?.upcoming.count ?? 0
        case 1:
            return matchesViewModel.matches?.previous.count ?? 0
        default:
            return 0
        }
    }
    
    public override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UpcomingMatchCell", for: indexPath)
            
            if let matchCell = cell as? UpcomingMatchCell,
               let match = matchesViewModel.matches?.upcoming[indexPath.row] {
                matchCell.configure(with: match, teams: teamsViewModel.teams)
            }
            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PreviousMatchCell", for: indexPath)
            
            if let matchCell = cell as? PreviousMatchCell,
               let match = matchesViewModel.matches?.previous[indexPath.row] {
                matchCell.configure(with: match, teams: teamsViewModel.teams)
            }
            return cell
        
        default:
            return UICollectionViewCell()
        }
    }
}

extension MatchesViewController: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width - 20, height: 0)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}
