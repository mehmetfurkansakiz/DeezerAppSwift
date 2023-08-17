//
//  AlbumDetailViewController.swift
//  DeezerAppSwift
//
//  Created by furkan sakız on 12.08.2023.
//

import UIKit

class AlbumDetailViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {

    @IBOutlet weak var albumDetailCollectionView: UICollectionView!
    
    let albumDetailViewModel = AlbumDetailViewModel()
    var selectedAlbum : AlbumDataModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        albumDetailCollectionView.delegate = self
        albumDetailCollectionView.dataSource = self
        albumDetailCollectionView.showsVerticalScrollIndicator = false
        albumDetailCollectionView.isUserInteractionEnabled = true
        
        if let albumID = selectedAlbum?.id {
            fetchAlbum(for: albumID)
        }
    }
    
    func fetchAlbum(for albumID: Int) {
        albumDetailViewModel.fetchAlbum(for: albumID) { error in
            if let error = error {
                print("Album Detail Data Fetch Error: \(error.localizedDescription)")
                return
            }
            
            DispatchQueue.main.async {
                self.albumDetailCollectionView.reloadData()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return albumDetailViewModel.numberOfAlbum()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AlbumDetailCell", for: indexPath) as! AlbumDetailCollectionViewCell
        
        let albumDetail = albumDetailViewModel.album[indexPath.row]
        cell.configure(with: albumDetail, selectedAlbum: selectedAlbum!)
        
//        ImageLoader.shared.loadImage(from: selectedAlbum!.cover_medium) { image in
//            cell.albumImageView.image = image
//        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let itemWidth = collectionView.frame.width // Cell Weight
        
        let itemHeight: CGFloat = 120 // Cell Height
        
        return CGSize(width: itemWidth, height: itemHeight)
    }

}
