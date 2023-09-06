//
//  GenreViewModel.swift
//  DeezerAppSwift
//
//  Created by furkan sakız on 2.08.2023.
//

import Foundation
import UIKit


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
    
    func configureNavTitleLogo(title: String,imageName: String) -> UIView {
        
        let titleView = UIView()
        
        let label = UILabel()
        label.text = title
        label.sizeToFit()
        label.center = titleView.center
        label.textAlignment = NSTextAlignment.center
        
        let image = UIImageView()
        image.image = UIImage(named: imageName)
        
        let imageAspect = image.image!.size.width / image.image!.size.height
        
        let imageX = label.frame.origin.x - label.frame.size.height * imageAspect
        let imageY = label.frame.origin.y
        
        let imageWidth = label.frame.size.height * imageAspect
        let imageHeight = label.frame.size.height
        
        image.frame = CGRect(x: imageX, y: imageY, width: imageWidth, height: imageHeight)
        
        image.contentMode = UIView.ContentMode.scaleAspectFit
        
        titleView.addSubview(label)
        titleView.addSubview(image)
        
        titleView.sizeToFit()
        
        return titleView
    }
    
    func numberOfGenres() -> Int {
        return genres.count
    }
    
    func genre(at index: Int) -> GenreDataModel {
        return genres[index]
    }
}
