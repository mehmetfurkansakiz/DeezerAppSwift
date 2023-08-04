//
//  ArtistCollectionViewCell.swift
//  DeezerAppSwift
//
//  Created by furkan sakız on 4.08.2023.
//

import UIKit

class ArtistCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var artistImageView: UIImageView!
    @IBOutlet weak var artistNameLabel: UILabel!
    
    func configure(with artist: ArtistDataModel) {
        artistNameLabel.text = artist.name
        
        if let imageURL = URL(string: "https://api.deezer.com/artist/\(artist.id)/image") {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: imageURL) {
                    DispatchQueue.main.async {
                        self.artistImageView.image = UIImage(data: data)
                        
                        // Set up black border and rounded corners for artistImageView
                        self.artistImageView.layer.borderWidth = 2.0
                        self.artistImageView.layer.borderColor = UIColor.gray.cgColor
                        self.artistImageView.layer.cornerRadius = 8.0
                        self.artistImageView.layer.masksToBounds = true
                        
                        // Add a shadow to the artistNameLabel
                        self.artistNameLabel.layer.shadowColor = UIColor.black.cgColor
                        self.artistNameLabel.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
                        self.artistNameLabel.layer.shadowOpacity = 0.8
                        self.artistNameLabel.layer.shadowRadius = 2.0
                    }
                }
            }
        }
    }

}
