//
//  ArtistDetailCollectionViewCell.swift
//  DeezerAppSwift
//
//  Created by furkan sakız on 6.08.2023.
//

import UIKit

class AlbumCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var albumImageView: UIImageView!
    @IBOutlet weak var albumNameLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    
    
    func configure(with album: AlbumDataModel) {
        
        ImageLoader.shared.loadImage(from: album.cover_medium) { coverImage in
            DispatchQueue.main.async {
                self.albumImageView.image = coverImage
                
                // Set up black border and rounded corners for albumImageView
                self.albumImageView.layer.borderWidth = 2.0
                self.albumImageView.layer.borderColor = UIColor.gray.cgColor
                self.albumImageView.layer.cornerRadius = 8.0
                self.albumImageView.layer.masksToBounds = true
            }
        }
        
        albumNameLabel.text = album.title
        releaseDateLabel.text = album.release_date
    }
}
