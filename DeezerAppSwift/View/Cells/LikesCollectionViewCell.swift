//
//  LikesCollectionViewCell.swift
//  DeezerAppSwift
//
//  Created by furkan sakız on 17.08.2023.
//

import UIKit

class LikesCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var songTitleLabel: UILabel!
    @IBOutlet weak var songDurationLabel: UILabel!
    @IBOutlet weak var albumImageView: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    
    func configure(with likedSong: LikedModel) {
        songTitleLabel.text = likedSong.songTitle
        songDurationLabel.text = formatSongDuration(Int(likedSong.songDuration))
        
        if let imageUrlString = likedSong.songImage, let imageURL = URL(string: imageUrlString) {
            URLSession.shared.dataTask(with: imageURL) { data, response, error in
                if let error = error {
                    print("Error downloading image in LikedPage: \(error)")
                    return
                }
                
                if let image = UIImage(data: data!) {
                    DispatchQueue.main.async {
                        self.albumImageView.image = image
                    }
                }
            }.resume()
        }
        
        // Set up black border and rounded corners for albumImageView
        self.albumImageView.layer.borderWidth = 2.0
        self.albumImageView.layer.borderColor = UIColor.gray.cgColor
        self.albumImageView.layer.cornerRadius = 8.0
        self.albumImageView.layer.masksToBounds = true
        
        // Set up gray border for the cell
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor.gray.cgColor
        self.layer.cornerRadius = 8.0
        self.layer.masksToBounds = true
        
    }
    
    func formatSongDuration(_ duration: Int) -> String {
        let minutes = duration / 60
        let seconds = duration % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
    
    func configureLikeButton(isLiked: Bool) {
        if isLiked {
            likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        } else {
            likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
        }
    }
}
