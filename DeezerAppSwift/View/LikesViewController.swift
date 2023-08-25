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
        
        return cell
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
