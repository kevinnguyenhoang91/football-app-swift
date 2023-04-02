//
//  TeamDetailViewController.swift
//  FootballApp
//
//  Created by Kha Nguyễn on 02/04/2023.
//

import Foundation
import UIKit
import SDWebImage
import FootballTeam

public class TeamDetailViewController: UIViewController {

    public var teamViewModel: TeamViewModel?

    private let logoImageView = UIImageView()
    private let nameLabel = UILabel()
    private let descriptionLabel = UILabel()

    public override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        // Add a close button to the view
        let closeButton = UIButton(type: .system)
        closeButton.setTitle("Close", for: .normal)
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        view.addSubview(closeButton)

        // Add constraints for the close button
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        ])

        // Configure the logo image view
        if let logo = teamViewModel?.team?.logo {
            logoImageView.sd_setImage(with: logo, placeholderImage: nil, options: [.progressiveLoad, .scaleDownLargeImages])
        }
        logoImageView.contentMode = .scaleAspectFit
        view.addSubview(logoImageView)

        // Configure the name label
        nameLabel.text = teamViewModel?.team?.name
        nameLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        nameLabel.textAlignment = .center
        view.addSubview(nameLabel)
        
        // Configure the description label
        descriptionLabel.text = "- Team ID: \(teamViewModel?.team?.id ?? "")\n- Wins: 10\n- Lose: 5"
        descriptionLabel.numberOfLines = 0
        descriptionLabel.font = UIFont.systemFont(ofSize: 16)
        descriptionLabel.textAlignment = .left
        view.addSubview(descriptionLabel)

        // Add constraints for the UI elements
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: 240),
            logoImageView.heightAnchor.constraint(equalToConstant: 240),

            nameLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 16),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            descriptionLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 22),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        ])
    }
    
    @objc public func closeButtonTapped() {
        dismiss(animated: true)
    }

}
