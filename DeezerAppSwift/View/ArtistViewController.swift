//
//  ArtistViewController.swift
//  DeezerAppSwift
//
//  Created by furkan sakız on 4.08.2023.
//

import UIKit

class ArtistViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    @IBOutlet weak var artistCollectionView: UICollectionView!
    
    let artistViewModel = ArtistViewModel()
    var selectedGenre: GenreDataModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        artistCollectionView.delegate = self
        artistCollectionView.dataSource = self
        artistCollectionView.showsVerticalScrollIndicator = false
        artistCollectionView.isUserInteractionEnabled = true
        
        // Fetch artists
        if let genreID = selectedGenre?.id {
            fetchArtists(for: genreID)
        }
    }
    
    func fetchArtists(for genreID: Int) {
        artistViewModel.fetchArtists(for: genreID) { error in
            if let error = error {
                print("Artist Data Fetch Error: \(error.localizedDescription)")
                return
            }

            DispatchQueue.main.async {
                self.artistCollectionView.reloadData()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return artistViewModel.numberOfArtists()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ArtistCell", for: indexPath) as! ArtistCollectionViewCell
        
        let artist = artistViewModel.artists[indexPath.row]
        cell.configure(with: artist)
        
        return cell
    }
    
    //MARK: - Artist Detail Segue
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedArtist = artistViewModel.artist(at: indexPath.item)
        performSegue(withIdentifier: "toArtistDetailVC", sender: selectedArtist)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toArtistDetailVC", let selectedArtist = sender as? ArtistDataModel {
            if let artistDetailVC = segue.destination as? ArtistDetailViewController {
                artistDetailVC.selectedArtist = selectedArtist
            }
        }
    }
    

}
