//
//  ArtistDetailViewModel.swift
//  DeezerAppSwift
//
//  Created by furkan sakız on 5.08.2023.
//

import Foundation

class ArtistDetailViewModel {
    
    var albums = [AlbumDataModel]()
    
    func fetchAlbums(for artistID: Int, completion: @escaping (Error?) -> Void ) {
        let urlString = "https://api.deezer.com/artist/\(artistID)/albums"
        guard let url = URL(string: urlString) else {
            let error = NSError(domain: "Invalid Album URL", code: 0, userInfo: nil)
            completion(error)
            return
        }
        
        APIManager.shared.get(url: url, responseType: AlbumListModel.self) { result in
            switch result {
            case .success(let albumListModel):
                self.albums = albumListModel.data
                completion(nil)
            case .failure(let error):
                print("Failed to fetch albums: \(error)")
                completion(error)
            }
        }
    }
    
    func numberOfAlbum() -> Int {
        return albums.count
    }
    
    func album(at index: Int) -> AlbumDataModel {
        return albums[index]
    }
}
