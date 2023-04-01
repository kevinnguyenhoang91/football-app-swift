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

    private var dataSource: UICollectionViewDiffableDataSource<Int, MatchViewModel>!

    public override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(refreshCollectionView), for: .valueChanged)

        title = "Football Matches"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]

        collectionView.backgroundColor = .clear
        view.backgroundColor = .white

        dataSource = UICollectionViewDiffableDataSource<Int, MatchViewModel>(collectionView: collectionView) { [weak self] collectionView, indexPath, item in

            guard let self = self else { return UICollectionViewCell() }

            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MatchCell", for: indexPath)
            if let cell = cell as? MatchCell {
                DispatchQueue.main.async {
                    cell.configure(with: item, teamsViewModel: self.teamsViewModel)
                }
            }
            return cell
        }

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
        
        matchesViewModel.$matches
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.updateData()
            }
            .store(in: &cancellables)
    }
    
    private func updateData() {
        var snapshot = NSDiffableDataSourceSnapshot<Int, MatchViewModel>()
        snapshot.appendSections([0])
        switch self.segmentedControl.selectedSegmentIndex {
        case 0:
            snapshot.appendItems(self.matchesViewModel.upcomingMatchViewModels ?? [])
            break
        case 1:
            snapshot.appendItems(self.matchesViewModel.previousMatchViewModels ?? [])
            break
        default:
            break
        }
        self.dataSource.apply(snapshot, animatingDifferences: true)
    }

    @objc func refreshCollectionView() {
        matchesViewModel.fetchMatches()
        teamsViewModel.fetchTeams()
        refreshControl.endRefreshing()
    }

    @objc public func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        updateData()
    }

    public override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
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
