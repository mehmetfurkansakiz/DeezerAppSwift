//
//  ArtistDetailViewController.swift
//  DeezerAppSwift
//
//  Created by furkan sakız on 5.08.2023.
//

import UIKit

class ArtistDetailViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    @IBOutlet weak var artistImage: UIImageView!
    @IBOutlet weak var artistNameTitle: UINavigationBar!
    @IBOutlet weak var albumCollectionView: UICollectionView!
    
    let artistDetailViewModel = ArtistDetailViewModel()
    var selectedArtist: ArtistDataModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        albumCollectionView.delegate = self
        albumCollectionView.dataSource = self
        albumCollectionView.showsVerticalScrollIndicator = false
        albumCollectionView.isUserInteractionEnabled = true
        
        if let artistID = selectedArtist?.id {
            fetchAlbums(for: artistID)
        }
        
        ImageLoader.shared.loadImage(from: selectedArtist!.picture_medium) { image in
            DispatchQueue.main.async {
                self.artistImage.image = image
                self.artistImage.contentMode = .scaleAspectFit
                self.artistImage.backgroundColor = .darkGray
            }
        }
        artistNameTitle.topItem?.title = selectedArtist?.name
    }
    
    func fetchAlbums(for artistID: Int) {
        artistDetailViewModel.fetchAlbums(for: artistID) { error in
            if let error = error {
                print("Album Data Fetch Error: \(error.localizedDescription)")
                return
            }
            
            DispatchQueue.main.async {
                self.albumCollectionView.reloadData()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return artistDetailViewModel.numberOfAlbum()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AlbumCell", for: indexPath) as! AlbumCollectionViewCell
        
        let album = artistDetailViewModel.albums[indexPath.row]
        cell.configure(with: album)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth = collectionView.frame.width // Cell Width
        let itemHeight: CGFloat = 100 // Cell Height
        
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    //MARK: - Album Detail Segue
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedAlbum = artistDetailViewModel.album(at: indexPath.item)
        performSegue(withIdentifier: "toAlbumDetailVC", sender: selectedAlbum)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toAlbumDetailVC", let selectedAlbum = sender as? AlbumDataModel {
            if let albumDetailVC = segue.destination as? AlbumDetailViewController {
                albumDetailVC.selectedAlbum = selectedAlbum
                
            }
        }
    }
    
    
    
}
