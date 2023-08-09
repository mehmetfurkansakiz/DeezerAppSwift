//
//  ArtistDetailModel.swift
//  DeezerAppSwift
//
//  Created by furkan sakız on 5.08.2023.
//

import Foundation

struct AlbumListModel: Codable {
    let data: [AlbumDataModel]
}

struct AlbumDataModel: Codable {
    let id: Int
    let title: String
    let cover_medium: String
    let release_date: String
}
