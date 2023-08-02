//
//  GenreViewController.swift
//  DeezerAppSwift
//
//  Created by furkan sakız on 27.07.2023.
//

import UIKit

class GenreViewController: UICollectionViewController {
    
    let genreViewModel = GenreViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "GenreCell")
        
        fetchGenres()
    }
    
    func fetchGenres() {
        genreViewModel.fetchGenres { error in
            if let error = error {
                print("Genre Data Fetch Error: \(error.localizedDescription)")
                return
            }
            
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
    }
    

}
