//
//  AlbumDetailCollectionViewCell.swift
//  DeezerAppSwift
//
//  Created by furkan sakız on 12.08.2023.
//

import UIKit

class AlbumDetailCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var songTitleLabel: UILabel!
    @IBOutlet weak var songDurationLabel: UILabel!
    @IBOutlet weak var albumImageView: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    
    func configure(with albumDetail: AlbumDetailDataModel, selectedAlbum: AlbumDataModel) {
        
        ImageLoader.shared.loadImage(from: selectedAlbum.cover_medium) { image in
            DispatchQueue.main.async {
                
                self.albumImageView.image = image
                
                // Set up black border and rounded corners for albumImageView
                self.albumImageView.layer.borderWidth = 2.0
                self.albumImageView.layer.borderColor = UIColor.gray.cgColor
                self.albumImageView.layer.cornerRadius = 8.0
                self.albumImageView.layer.masksToBounds = true
            }
        }
        
        songTitleLabel.text = albumDetail.title
        songDurationLabel.text = formatSongDuration(albumDetail.duration)
            
    }
    
    private func formatSongDuration(_ duration: Int) -> String {
        let minutes = duration / 60
        let seconds = duration % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
    
}
