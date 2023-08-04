//
//  genreModel.swift
//  DeezerAppSwift
//
//  Created by furkan sakız on 2.08.2023.
//

import Foundation

struct GenreModel: Codable {
    let data: [GenreDataModel]
}

struct GenreDataModel: Codable {
    let id: Int
    let name: String
    let picture_medium: String
}
