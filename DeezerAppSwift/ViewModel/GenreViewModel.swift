//
//  genreViewModel.swift
//  DeezerAppSwift
//
//  Created by furkan sakız on 2.08.2023.
//

import Foundation


class GenreViewModel {
    
    var genres = [GenreDataModel]()
    
    func fetchGenres(completion: @escaping (Error?) -> Void) {
        let urlString = "https://api.deezer.com/genre"
        
        guard let url = URL(string: urlString) else {
            let error = NSError(domain: "Invalid Genre URL", code: 0, userInfo: nil)
            completion(error)
            return
        }
        
        APIManager.shared.get(url: url, responseType: GenreModel.self) { result in
            switch result {
            case .success(let genreModel):
                self.genres = genreModel.data
                completion(nil)
                
            case .failure(let error):
                print("Failed to fetch genres: \(error)")
                completion(error)
                
            }
        }
    }
    
    func numberOfGenres() -> Int {
        return genres.count
    }
    
    func genre(at index: Int) -> GenreDataModel {
        return genres[index]
    }
}
