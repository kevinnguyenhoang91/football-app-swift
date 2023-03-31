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
    private var matchesViewModel = MatchesViewModel(context: Defines.context)
    private var teamsViewModel = TeamsViewModel(context: Defines.context)
        
    private var refreshControl = UIRefreshControl()
    
    private let segmentedControl = UISegmentedControl(items: ["Upcoming", "Previous"])
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(refreshCollectionView), for: .valueChanged)
                
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

        collectionView.register(MatchCell.self, forCellWithReuseIdentifier: "MatchCell")
        matchesViewModel.fetchMatchesFromCoreData()
        teamsViewModel.fetchTeamsFromCoreData()
        collectionView.reloadData()
    }
    
    @objc func refreshCollectionView() {
        // Perform any necessary data fetching or reloading here
        collectionView.reloadData()
        refreshControl.endRefreshing()
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
            return matchesViewModel.upcomingMatchViewModels?.count ?? 0
        case 1:
            return matchesViewModel.previousMatchViewModels?.count ?? 0
        default:
            return 0
        }
    }
    
    public override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MatchCell", for: indexPath)
        if let cell = cell as? MatchCell {
            var matchViewModel: MatchViewModel?
            switch segmentedControl.selectedSegmentIndex {
            case 0:
                matchViewModel = matchesViewModel.upcomingMatchViewModels?[indexPath.row]
                break
            case 1:
                matchViewModel = matchesViewModel.previousMatchViewModels?[indexPath.row]
                break
            default:
                break
            }
            
            if let matchViewModel = matchViewModel {
                cell.configure(with: matchViewModel, teamsViewModel: teamsViewModel)
            }
        }
        return cell
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
