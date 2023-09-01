//
//  LikesViewController.swift
//  DeezerAppSwift
//
//  Created by furkan sakız on 17.08.2023.
//

import UIKit

class LikesViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    @IBOutlet weak var likesCollectionView: UICollectionView!
    
    var likedSongs: [LikedModel] = []
    let likesViewModel = LikesViewModel()
    var currentlyPlayingIndexPath: IndexPath? // To keep of currently playing song
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        likesCollectionView.delegate = self
        likesCollectionView.dataSource = self
        likesCollectionView.showsVerticalScrollIndicator = false
        likesCollectionView.isUserInteractionEnabled = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        likedSongs = likesViewModel.fetchLikedSongs()
        likesCollectionView.reloadData()
        
        likesViewModel.stopPreview()
        
        currentlyPlayingIndexPath = nil
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return likedSongs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LikesCell", for: indexPath) as! LikesCollectionViewCell
        
        let likedSong = likedSongs[indexPath.row]
        cell.configure(with: likedSong)
        
        let isLiked = likesViewModel.isLiked(likedSong: likedSong)
           cell.configureLikeButton(isLiked: isLiked)
        
        cell.likeButton.tag = indexPath.row // Like Button Tag
        
        let isPlaying = indexPath == currentlyPlayingIndexPath
        cell.configurePlayButton(isPlaying: isPlaying)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(likesViewTapped(_:)))
        cell.contentView.addGestureRecognizer(tapGesture)
        
        return cell
    }
    
    @objc func likesViewTapped(_ sender: UITapGestureRecognizer) {
        
        if let tappedCell = sender.view?.superview as? LikesCollectionViewCell, let indexPath = likesCollectionView.indexPath(for: tappedCell) {
            
            if currentlyPlayingIndexPath == indexPath {
                likesViewModel.stopPreview()
                currentlyPlayingIndexPath = nil
                tappedCell.configurePlayButton(isPlaying: false)
            } else {
                if let previousPlayingIndexPath = currentlyPlayingIndexPath, let previousPlayingCell = likesCollectionView.cellForItem(at: previousPlayingIndexPath) as? LikesCollectionViewCell {
                    previousPlayingCell.configurePlayButton(isPlaying: false)
                }
                currentlyPlayingIndexPath = indexPath
                tappedCell.configurePlayButton(isPlaying: true)
                
                let likedSongs = likesViewModel.fetchLikedSongs()
                let selectedSong = likedSongs[indexPath.row]
                likesViewModel.playPreview(for: selectedSong)
                
                // Stop the audio after 30 seconds
                DispatchQueue.main.asyncAfter(deadline: .now() + 30) {
                    if tappedCell.playButton.isHidden == false {
                        AudioManager.shared.stopAudio()
                        tappedCell.configurePlayButton(isPlaying: false)
                    }
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let itemWidth = collectionView.frame.width // Cell Weight
        
        let itemHeight: CGFloat = 120 // Cell Height
        
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    @IBAction func likeButtonTapped(_ sender: UIButton) {
        
        let buttonTag = sender.tag
        let indexPath = IndexPath(row: buttonTag, section: 0)
        
        let likedSong = likedSongs[indexPath.row]
        
        likesViewModel.toggleLike(for: likedSong)
        
        if let cell = likesCollectionView.cellForItem(at: indexPath) as? LikesCollectionViewCell {
            let isLiked = likesViewModel.isLiked(likedSong: likedSong)
            cell.configureLikeButton(isLiked: isLiked)
        }
        
        likedSongs = likesViewModel.fetchLikedSongs()
        likesCollectionView.reloadData()
    }
}
