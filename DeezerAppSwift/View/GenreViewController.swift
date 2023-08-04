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
        genreCollectionView.showsVerticalScrollIndicator = false
        genreCollectionView.isUserInteractionEnabled = true
        
        // Fetch genres
        fetchGenres()
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
        
        let genre = genreViewModel.genre(at: indexPath.row)
        cell.configure(with: genre)
        
        return cell
    }
    
    //MARK: - Segue
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedGenre = genreViewModel.genre(at: indexPath.item)
        performSegue(withIdentifier: "toArtistVC", sender: selectedGenre)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toArtistVC", let selectedGenre = sender as? GenreDataModel {
            if let artistVC = segue.destination as? ArtistViewController {
                artistVC.selectedGenre = selectedGenre
            }
        }
    }
}
