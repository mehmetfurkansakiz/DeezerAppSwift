//
//  GenreCollectionViewCell.swift
//  DeezerAppSwift
//
//  Created by furkan sakız on 2.08.2023.
//

import UIKit

class GenreCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var genreImageView: UIImageView!
    @IBOutlet weak var genreNameLabel: UILabel!
    
    func configure(with genre: GenreDataModel) {
        genreNameLabel.text = genre.name
        
        ImageLoader.shared.loadImage(from: genre.picture_medium) { image in
            DispatchQueue.main.async {
                self.genreImageView.image = image
                
                // Set up black border and rounded corners for genreImageView
                self.genreImageView.layer.borderWidth = 2.0
                self.genreImageView.layer.borderColor = UIColor.gray.cgColor
                self.genreImageView.layer.cornerRadius = 8.0
                self.genreImageView.layer.masksToBounds = true
                
                // Add a shadow to the genreNameLabel
                self.genreNameLabel.layer.shadowColor = UIColor.black.cgColor
                self.genreNameLabel.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
                self.genreNameLabel.layer.shadowOpacity = 0.8
                self.genreNameLabel.layer.shadowRadius = 2.0
            }
        }
    }
}
