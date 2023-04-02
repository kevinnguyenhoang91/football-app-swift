//
//  WatchHighlightsViewController.swift
//  FootballApp
//
//  Created by Kha Nguyễn on 02/04/2023.
//

import Foundation
import UIKit
import AVFoundation


public class WatchHighlightsViewController: UIViewController {

    private var player: AVPlayer?
    private var playerLayer: AVPlayerLayer?

    public var matchViewModel: MatchViewModel?

    public override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        guard let hightlights = matchViewModel?.match?.highlights else { return }

        // Set up AVPlayer
        player = AVPlayer(url: hightlights)

        // Set up AVPlayerLayer
        playerLayer = AVPlayerLayer(player: player)
        playerLayer?.videoGravity = .resizeAspect
        playerLayer?.frame = view.bounds
        view.layer.addSublayer(playerLayer!)
        
        // Add play controls
        let playButton = UIButton(type: .system)
        playButton.setTitle("Play/Pause", for: .normal)
        playButton.addTarget(self, action: #selector(playButtonTapped), for: .touchUpInside)
        view.addSubview(playButton)

        // Add constraints for the play button
        playButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            playButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            playButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 200),
        ])
        
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
        
        let descriptionTitle = UILabel()
        descriptionTitle.font = .boldSystemFont(ofSize: 24)
        descriptionTitle.numberOfLines = 0
        descriptionTitle.textAlignment = .center
        descriptionTitle.text = matchViewModel?.match?.description
        view.addSubview(descriptionTitle)

        // Add constraints for the close button
        descriptionTitle.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            descriptionTitle.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: 32),
            descriptionTitle.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            descriptionTitle.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 10)
        ])
        
        player?.play()
    }

    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        // Update playerLayer frame when view bounds change
        playerLayer?.frame = view.bounds
    }

    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        // Pause video when view disappears
        player?.pause()
    }
    
    @objc public func playButtonTapped() {
        player?.play()
    }
    
    @objc public func closeButtonTapped() {
        dismiss(animated: true)
    }

    deinit {
        // Remove playerLayer from superlayer when view is deallocated
        playerLayer?.removeFromSuperlayer()
    }
}
