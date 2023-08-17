//
//  AlbumDetailModel.swift
//  DeezerAppSwift
//
//  Created by furkan sakız on 13.08.2023.
//

import Foundation

struct AlbumDetailModel : Codable {
    let data: [AlbumDetailDataModel]
}

struct AlbumDetailDataModel: Codable {
    let id: Int
    let title: String
    let duration: Int
}
