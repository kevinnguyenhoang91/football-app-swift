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

public class PreviousMatchCell: UICollectionViewCell {
    
    // MARK: - UI Elements
    
    private let homeLogoImageView: UIImageView = {
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
    
    private let awayLogoImageView: UIImageView = {
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
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .black
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private let vsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .black
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
        label.text = "VS"
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Initialization
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Setup
    
    private func setupUI() {
        layer.cornerRadius = 8
        layer.masksToBounds = true
        
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(homeLogoImageView)
        contentView.addSubview(awayLogoImageView)
        contentView.addSubview(dateLabel)
        contentView.addSubview(vsLabel)
        
        contentView.addSubview(glassImageView)
        glassImageView.translatesAutoresizingMaskIntoConstraints = false
        glassImageView.alpha = 0.5
        glassImageView.image = createGlassImage()
        glassImageView.isUserInteractionEnabled = false

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
    }
    
    // MARK: - Public Methods
    
    public func configure(with match: Match, teams: [Team]?) {
        let homeTeam = teams?.first { team in
            guard let name = team.name else { return false }
            return name == match.home
        }
        
        let awayTeam = teams?.first { team in
            guard let name = team.name else { return false }
            return name == match.away
        }
        
        if let homeLogoURL = homeTeam?.logo {
            homeLogoImageView.sd_setImage(with: homeLogoURL, placeholderImage: nil, options: [.progressiveLoad, .scaleDownLargeImages])
        }
        
        if let awayLogoURL = awayTeam?.logo {
            awayLogoImageView.sd_setImage(with: awayLogoURL, placeholderImage: nil, options: [.progressiveLoad, .scaleDownLargeImages])
        }
        
        homeLogoImageView.layer.borderWidth = 2.0
        homeLogoImageView.layer.borderColor = UIColor.red.withAlphaComponent(0.2).cgColor
        homeLogoImageView.backgroundColor = .red.withAlphaComponent(0.2)
        
        awayLogoImageView.layer.borderWidth = 2.0
        awayLogoImageView.layer.borderColor = UIColor.blue.withAlphaComponent(0.2).cgColor
        awayLogoImageView.backgroundColor = .blue.withAlphaComponent(0.2)
        
        if let winner = match.winner, let homeTeamName = homeTeam?.name, winner == homeTeamName {
            homeLogoImageView.layer.borderWidth = 5.0
            homeLogoImageView.layer.borderColor = UIColor.yellow.cgColor
            homeLogoImageView.backgroundColor = .red.withAlphaComponent(0.2)
        }
        
        if let winner = match.winner, let awayTeamName = awayTeam?.name, winner == awayTeamName {
            awayLogoImageView.layer.borderWidth = 5.0
            awayLogoImageView.layer.borderColor = UIColor.yellow.cgColor
            awayLogoImageView.backgroundColor = .blue.withAlphaComponent(0.2)
        }
        
        descriptionLabel.text = match.description
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Defines.displayDateFormatString
        dateLabel.text = dateFormatter.string(from: match.date)
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    private let glassImageView = UIImageView()
    
    private func createGlassImage() -> UIImage? {
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

public class UpcomingMatchCell: UICollectionViewCell {
    
    // MARK: - UI Elements
    
    private let homeLogoImageView: UIImageView = {
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
    
    private let awayLogoImageView: UIImageView = {
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
    
    private let vsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .black
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
        label.text = "VS"
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .black
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Initialization
    
    private var match: Match?
    private var homeTeam: Team?
    private var awayTeam: Team?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Setup
    
    private func setupUI() {
        layer.cornerRadius = 8
        layer.masksToBounds = true
            
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(homeLogoImageView)
        contentView.addSubview(awayLogoImageView)
        contentView.addSubview(dateLabel)
        contentView.addSubview(vsLabel)
        
        contentView.addSubview(glassImageView)
        glassImageView.translatesAutoresizingMaskIntoConstraints = false
        glassImageView.alpha = 0.5
        glassImageView.image = createGlassImage()
        glassImageView.isUserInteractionEnabled = false
        
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
    
    @objc public func handleTeamTap(_ sender: UITapGestureRecognizer) {
        guard let target = sender.view as? UIImageView else {
            return
        }
        var name = homeTeam?.name ?? ""
        var id = homeTeam?.id ?? ""
        if target === awayLogoImageView {
            name = awayTeam?.name ?? ""
            id = awayTeam?.id ?? ""
        }
        let alertController = UIAlertController(title: "Team \(name)", message: "Name: \(name)\nID: \(id)", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Done", style: .default, handler: nil)
        alertController.addAction(okAction)
        if let viewController = UIApplication.shared.keyWindow?.rootViewController {
            viewController.present(alertController, animated: true, completion: nil)
        }
    }
    
    // MARK: - Public Methods
    
    public func configure(with match: Match, teams: [Team]?) {
        let homeTeam = teams?.first { team in
            guard let name = team.name else { return false }
            return name == match.home
        }
        
        let awayTeam = teams?.first { team in
            guard let name = team.name else { return false }
            return name == match.away
        }
        
        self.match = match
        self.homeTeam = homeTeam
        self.awayTeam = awayTeam
                
        if let homeLogoURL = homeTeam?.logo {
            homeLogoImageView.sd_setImage(with: homeLogoURL, placeholderImage: nil, options: [.progressiveLoad, .scaleDownLargeImages])
        }
        
        if let awayLogoURL = awayTeam?.logo {
            awayLogoImageView.sd_setImage(with: awayLogoURL, placeholderImage: nil, options: [.progressiveLoad, .scaleDownLargeImages])
        }
        
        descriptionLabel.text = match.description
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Defines.displayDateFormatString
        dateLabel.text = dateFormatter.string(from: match.date)
        self.setNeedsLayout()
        self.layoutIfNeeded()
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    private let glassImageView = UIImageView()
    
    private func createGlassImage() -> UIImage? {
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
