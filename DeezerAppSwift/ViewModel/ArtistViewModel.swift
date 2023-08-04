//
//  artistViewModel.swift
//  DeezerAppSwift
//
//  Created by furkan sakız on 4.08.2023.
//

import Foundation


class ArtistViewModel {
    
    var artists = [ArtistDataModel]()
    
    func fetchArtists(for genreID: Int, completion: @escaping (Error?) -> Void) {
        let urlString = "https://api.deezer.com/genre/\(genreID)/artists"
        guard let url = URL(string: urlString) else {
            let error = NSError(domain: "Invalid Artist URL", code: 0, userInfo: nil)
            completion(error)
            return
        }
        
        APIManager.shared.get(url: url, responseType: ArtistModel.self) { result in
            switch result {
            case .success(let artistModel):
                self.artists = artistModel.data
                completion(nil)
            case .failure(let error):
                print("Failed to fetch artists: \(error)")
                completion(error)
            }
        }
    }
    
    func numberOfArtists() -> Int {
        return artists.count
    }
    
    // for selectedArtist
    func artist(at index: Int) -> ArtistDataModel {
        return artists[index]
    }
}
