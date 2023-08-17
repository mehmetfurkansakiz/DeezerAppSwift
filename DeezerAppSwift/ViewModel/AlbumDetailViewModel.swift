//
//  AlbumDetailViewModel.swift
//  DeezerAppSwift
//
//  Created by furkan sakız on 13.08.2023.
//

import Foundation

class AlbumDetailViewModel {
    
    var album = [AlbumDetailDataModel]()
    
    func fetchAlbum(for albumID: Int, completion: @escaping (Error?) -> Void ) {
        let urlString = "https://api.deezer.com/album/\(albumID)/tracks"
        guard let url = URL(string: urlString) else {
            let error = NSError(domain: "Invalid Album Detail URL", code: 0, userInfo: nil)
            completion(error)
            return
        }
        
        APIManager.shared.get(url: url, responseType: AlbumDetailModel.self) { result in
            switch result {
            case .success(let albumDetailModel):
                self.album = albumDetailModel.data
                completion(nil)
            case .failure(let error):
                print("Failed to fetch album: \(error)")
                completion(error)
            }
        }
    }
    
    func numberOfAlbum() -> Int {
        return album.count
    }
    
    func album(at index: Int) -> AlbumDetailDataModel {
        return album[index]
    }
}
