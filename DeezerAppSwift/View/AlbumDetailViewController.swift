//
//  AlbumDetailViewController.swift
//  DeezerAppSwift
//
//  Created by furkan sakız on 12.08.2023.
//

import UIKit
import CoreData

class AlbumDetailViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var albumDetailCollectionView: UICollectionView!
    @IBOutlet weak var albumDetailNavigationItem: UINavigationItem!
    
    let albumDetailViewModel = AlbumDetailViewModel()
    var selectedAlbum : AlbumDataModel?
    var currentlyPlayingIndexPath: IndexPath? // To keep of currently playing song
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        albumDetailCollectionView.delegate = self
        albumDetailCollectionView.dataSource = self
        albumDetailCollectionView.showsVerticalScrollIndicator = false
        albumDetailCollectionView.isUserInteractionEnabled = true
        
        if let albumID = selectedAlbum?.id {
            fetchAlbum(for: albumID)
        }
        
        albumDetailNavigationItem.title = selectedAlbum?.title
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        albumDetailCollectionView.reloadData()
        
        albumDetailViewModel.stopPreview()
        
        currentlyPlayingIndexPath = nil
    }
    
    func fetchAlbum(for albumID: Int) {
        albumDetailViewModel.fetchAlbum(for: albumID) { error in
            if let error = error {
                print("Album Detail Data Fetch Error: \(error.localizedDescription)")
                return
            }
            
            DispatchQueue.main.async {
                self.albumDetailCollectionView.reloadData()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return albumDetailViewModel.numberOfAlbum()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AlbumDetailCell", for: indexPath) as! AlbumDetailCollectionViewCell
        
        let albumDetail = albumDetailViewModel.album[indexPath.row]
        cell.configure(with: albumDetail, selectedAlbum: selectedAlbum!)
        
        let isLiked = albumDetailViewModel.isLiked(album: albumDetail, context: CoreDataStack.shared.persistentContainer.viewContext)
        cell.configureLikeButton(isLiked: isLiked)
        cell.likeButton.tag = indexPath.row  // Like Button Tag
        
        let isPlaying = indexPath == currentlyPlayingIndexPath
        cell.configurePlayButton(isPlaying: isPlaying)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(albumDetailViewTapped(_:)))
        cell.contentView.addGestureRecognizer(tapGesture)
        
        return cell
    }
    
    @objc func albumDetailViewTapped(_ sender: UITapGestureRecognizer) {
        
        if let tappedCell = sender.view?.superview as? AlbumDetailCollectionViewCell,
           let indexPath = albumDetailCollectionView.indexPath(for: tappedCell) {
            
            if currentlyPlayingIndexPath == indexPath {
                albumDetailViewModel.stopPreview()
                currentlyPlayingIndexPath = nil
                tappedCell.configurePlayButton(isPlaying: false)
            } else {
                if let previousPlayingIndexPath = currentlyPlayingIndexPath, let previousPlayingCell = albumDetailCollectionView.cellForItem(at: previousPlayingIndexPath) as? AlbumDetailCollectionViewCell {
                    previousPlayingCell.configurePlayButton(isPlaying: false)
                }
                currentlyPlayingIndexPath = indexPath
                tappedCell.configurePlayButton(isPlaying: true)
                
                let albumDetail = albumDetailViewModel.album[indexPath.row]
                albumDetailViewModel.playPreview(for: albumDetail)
                
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
        
        let albumDetail = albumDetailViewModel.album(at: indexPath.row)
        albumDetailViewModel.toggleLike(for: albumDetail, for: selectedAlbum!)
        
        if let cell = albumDetailCollectionView.cellForItem(at: indexPath) as? AlbumDetailCollectionViewCell {
            let isLiked = albumDetailViewModel.isLiked(album: albumDetail, context: CoreDataStack.shared.persistentContainer.viewContext)
            cell.configureLikeButton(isLiked: isLiked)
        }
    }
}
