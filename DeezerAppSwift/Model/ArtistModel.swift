//
//  artistModel.swift
//  DeezerAppSwift
//
//  Created by furkan sakız on 4.08.2023.
//

import Foundation

struct ArtistModel: Codable {
    let data: [ArtistDataModel]
}

struct ArtistDataModel: Codable {
    let id: Int
    let name: String
    let picture_medium: String
}
