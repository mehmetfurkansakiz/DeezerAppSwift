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
    
    func configureNavTitleLogo(title: String,imageName: String) -> UIView {
        
        let titleView = UIView()
        
        let label = UILabel()
        label.text = title
        label.sizeToFit()
        label.center = titleView.center
        label.textAlignment = NSTextAlignment.center
        
        let image = UIImageView()
        image.image = UIImage(named: imageName)
        
        let imageAspect = image.image!.size.width / image.image!.size.height
        
        let imageX = label.frame.origin.x - label.frame.size.height * imageAspect
        let imageY = label.frame.origin.y
        
        let imageWidth = label.frame.size.height * imageAspect
        let imageHeight = label.frame.size.height
        
        image.frame = CGRect(x: imageX, y: imageY, width: imageWidth, height: imageHeight)
        
        image.contentMode = UIView.ContentMode.scaleAspectFit
        
        titleView.addSubview(label)
        titleView.addSubview(image)
        
        titleView.sizeToFit()
        
        return titleView
    }
    
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
