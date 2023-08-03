//
//  GenreViewController.swift
//  DeezerAppSwift
//
//  Created by furkan sakız on 27.07.2023.
//

import UIKit

class GenreViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    @IBOutlet weak var genreCollectionView: UICollectionView!
    
    let genreViewModel = GenreViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        genreCollectionView.delegate = self
        genreCollectionView.dataSource = self
        
        fetchGenres()
        
        genreCollectionView.showsVerticalScrollIndicator = false
    }
    
    func fetchGenres() {
        genreViewModel.fetchGenres { error in
            if let error = error {
                print("Genre Data Fetch Error: \(error.localizedDescription)")
                return
            }
            
            DispatchQueue.main.async {
                self.genreCollectionView.reloadData()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return genreViewModel.numberOfGenres()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GenreCell", for: indexPath) as! GenreCollectionViewCell
        cell.backgroundColor = .white
        
        let genre = genreViewModel.genre(at: indexPath.row)
        cell.genreNameLabel.text = genre.name
        cell.configure(with: genre)
        
        if let imageURL = URL(string: genre.picture_medium) {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: imageURL) {
                    DispatchQueue.main.async {
                        cell.genreImageView.image = UIImage(data: data)
                        
                        // Set up black border and rounded corners for genreImageView
                        cell.genreImageView.layer.borderWidth = 2.0
                        cell.genreImageView.layer.borderColor = UIColor.gray.cgColor
                        cell.genreImageView.layer.cornerRadius = 8.0
                        cell.genreImageView.layer.masksToBounds = true
                        
                        // Add a shadow to the genreNameLabel
                        cell.genreNameLabel.layer.shadowColor = UIColor.black.cgColor
                        cell.genreNameLabel.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
                        cell.genreNameLabel.layer.shadowOpacity = 0.8
                        cell.genreNameLabel.layer.shadowRadius = 2.0
                    }
                }
            }
        }
        
        return cell
    }
}
