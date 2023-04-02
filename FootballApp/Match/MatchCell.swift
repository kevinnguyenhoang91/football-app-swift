//
//  MatchCell.swift
//  FootballApp
//
//  Created by Kha Nguyễn on 30/03/2023.
//

import Foundation
import UIKit
import Combine
import SDWebImage
import FootballTeam
import FootballMatch

public protocol MatchableCell {
    func configure(with matchViewModel: MatchViewModel?, teamsViewModel: TeamsViewModel?)
}

fileprivate protocol InternalMatchableCell {
    var homeLogoImageView: UIImageView { get }
    var awayLogoImageView: UIImageView { get }
    var descriptionLabel: UILabel { get }
    var vsLabel: UILabel { get }
    var dateLabel: UILabel { get }
    var glassImageView: UIImageView { get }
    
    func setupUI()
}

public class MatchCell: UICollectionViewCell {
    
    fileprivate lazy var homeLogoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.layer.borderWidth = 2.0
        imageView.layer.borderColor = UIColor.red.withAlphaComponent(0.2).cgColor
        imageView.backgroundColor = .red.withAlphaComponent(0.2)
        imageView.layer.cornerRadius = 10.0
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    fileprivate lazy var awayLogoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.layer.borderWidth = 2.0
        imageView.layer.borderColor = UIColor.blue.withAlphaComponent(0.2).cgColor
        imageView.backgroundColor = .blue.withAlphaComponent(0.2)
        imageView.layer.cornerRadius = 10.0
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    fileprivate lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .black
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    fileprivate lazy var vsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .black
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
        label.text = "VS"
        return label
    }()
    
    fileprivate lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    fileprivate lazy var glassImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.alpha = 0.5
        imageView.isUserInteractionEnabled = false
        return imageView
    }()
    
    private var matchViewModel: MatchViewModel?
    private var teamsViewModel: TeamsViewModel?
    private var homeTeamViewModel: TeamViewModel? {
        guard let match = matchViewModel?.match else { return nil }
        return teamsViewModel?.teamViewModels?.first(where: { $0.team?.name ?? "" == match.home })
    }
    private var awayTeamViewModel: TeamViewModel? {
        guard let match = matchViewModel?.match else { return nil }
        return teamsViewModel?.teamViewModels?.first(where: { $0.team?.name ?? "" == match.away })
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MatchCell: MatchableCell {
    
    fileprivate func clearUI() {
        homeLogoImageView.image = nil
        awayLogoImageView.image = nil
        descriptionLabel.text = nil
        dateLabel.text = nil
        
        homeLogoImageView.layer.borderWidth = 2.0
        homeLogoImageView.layer.borderColor = UIColor.red.withAlphaComponent(0.2).cgColor
        homeLogoImageView.backgroundColor = .red.withAlphaComponent(0.2)
        
        awayLogoImageView.layer.borderWidth = 2.0
        awayLogoImageView.layer.borderColor = UIColor.blue.withAlphaComponent(0.2).cgColor
        awayLogoImageView.backgroundColor = .blue.withAlphaComponent(0.2)
    }
    
    public func configure(with matchViewModel: MatchViewModel?, teamsViewModel: TeamsViewModel?) {
        clearUI()
        self.matchViewModel = matchViewModel
        self.teamsViewModel = teamsViewModel
        
        guard let match = matchViewModel?.match,
              let homeTeam = homeTeamViewModel?.team,
              let awayTeam = awayTeamViewModel?.team  else {
            return
        }
        
        if let homeLogoURL = homeTeam.logo {
            homeLogoImageView.sd_setImage(with: homeLogoURL, placeholderImage: nil, options: [.progressiveLoad, .scaleDownLargeImages])
        }
        
        if let awayLogoURL = awayTeam.logo {
            awayLogoImageView.sd_setImage(with: awayLogoURL, placeholderImage: nil, options: [.progressiveLoad, .scaleDownLargeImages])
        }
        
        if let winner = match.winner,
           let homeTeamName = homeTeam.name,
           winner == homeTeamName {
            homeLogoImageView.layer.borderWidth = 5.0
            homeLogoImageView.layer.borderColor = UIColor.yellow.cgColor
            homeLogoImageView.backgroundColor = .red.withAlphaComponent(0.2)
        }
        
        if let winner = match.winner,
           let awayTeamName = awayTeam.name,
           winner == awayTeamName {
            awayLogoImageView.layer.borderWidth = 5.0
            awayLogoImageView.layer.borderColor = UIColor.yellow.cgColor
            awayLogoImageView.backgroundColor = .blue.withAlphaComponent(0.2)
        }
        
        descriptionLabel.text = match.description
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Defines.displayDateFormatString
        dateLabel.text = dateFormatter.string(from: match.date)

        glassImageView.image = createGlassImage()
    }
    
    @objc public func handleTeamTap(_ sender: UITapGestureRecognizer) {
        guard let target = sender.view as? UIImageView,
              let _ = matchViewModel?.match,
              let _ = homeTeamViewModel?.team,
              let _ = awayTeamViewModel?.team  else {
            return
        }
            
        let teamVC = TeamDetailViewController()
        teamVC.teamViewModel = homeTeamViewModel
        
        if target === awayLogoImageView {
            teamVC.teamViewModel = awayTeamViewModel
        }
        
        if let viewController = UIApplication.shared.keyWindow?.rootViewController {
            viewController.present(teamVC, animated: true, completion: nil)
        }
    }
}

extension MatchCell: InternalMatchableCell {
    fileprivate func setupUI() {
        layer.cornerRadius = 8
        layer.masksToBounds = true
        
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(homeLogoImageView)
        contentView.addSubview(awayLogoImageView)
        contentView.addSubview(dateLabel)
        contentView.addSubview(vsLabel)
        contentView.addSubview(glassImageView)
        contentView.backgroundColor = .lightGray.withAlphaComponent(0.3)

        NSLayoutConstraint.activate([
            
            glassImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            glassImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            glassImageView.widthAnchor.constraint(equalToConstant: contentView.bounds.width),
            glassImageView.heightAnchor.constraint(equalTo: contentView.heightAnchor),
            
            homeLogoImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            homeLogoImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            homeLogoImageView.widthAnchor.constraint(equalToConstant: floor(contentView.bounds.width/2.0) - 50),
            homeLogoImageView.heightAnchor.constraint(equalTo: homeLogoImageView.widthAnchor),
            
            awayLogoImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            awayLogoImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            awayLogoImageView.widthAnchor.constraint(equalToConstant: floor(contentView.bounds.width/2.0) - 50),
            awayLogoImageView.heightAnchor.constraint(equalTo: awayLogoImageView.widthAnchor),
            
            descriptionLabel.topAnchor.constraint(equalTo: homeLogoImageView.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            descriptionLabel.widthAnchor.constraint(equalToConstant: contentView.bounds.width - 20),
            
            dateLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 8),
            dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            dateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            dateLabel.widthAnchor.constraint(equalToConstant: contentView.bounds.width - 20),
            
            vsLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            vsLabel.centerYAnchor.constraint(equalTo: homeLogoImageView.centerYAnchor),
        ])
        
        homeLogoImageView.isUserInteractionEnabled = true
        awayLogoImageView.isUserInteractionEnabled = true
                
        homeLogoImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTeamTap(_:))))
        awayLogoImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTeamTap(_:))))
    }
    
    fileprivate func createGlassImage() -> UIImage? {
        let size = CGSize(width: 100, height: 100) // adjust the size as desired
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        let colors = [UIColor.white.cgColor, UIColor.white.withAlphaComponent(0.3).cgColor]
        let locations: [CGFloat] = [0.0, 1.0]
        let gradient = CGGradient(colorsSpace: nil, colors: colors as CFArray, locations: locations)
        let startPoint = CGPoint(x: 0, y: 0)
        let endPoint = CGPoint(x: 0, y: size.height)
        context.drawLinearGradient(gradient!, start: startPoint, end: endPoint, options: [])
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
