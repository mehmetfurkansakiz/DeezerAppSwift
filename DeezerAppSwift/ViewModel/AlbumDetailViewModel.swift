//
//  AlbumDetailViewModel.swift
//  DeezerAppSwift
//
//  Created by furkan sakız on 13.08.2023.
//

import Foundation
import CoreData

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
    
    //MARK: - Liked Song Funcs
    func toggleLike(for albumDetail: AlbumDetailDataModel,for selectedAlbum: AlbumDataModel) {
        let context = CoreDataStack.shared.persistentContainer.viewContext
        
        if isLiked(album: albumDetail, context: context) {
            removeLike(for: albumDetail, context: context)
        } else {
            addLike(for: albumDetail, for: selectedAlbum, context: context)
        }
        
        CoreDataStack.shared.saveContext()
    }
    
    func isLiked(album: AlbumDetailDataModel, context: NSManagedObjectContext) -> Bool {
        let fetchRequest: NSFetchRequest<LikedModel> = LikedModel.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "songID == %lld", album.id)
        
        do {
            let result = try context.fetch(fetchRequest)
            return !result.isEmpty
        } catch {
            print("Error checking if liked: \(error)")
            return false
        }
    }
    
    func addLike(for albumDetail: AlbumDetailDataModel, for selectedAlbum: AlbumDataModel, context: NSManagedObjectContext) {
        let likedSong = LikedModel(context: context)
        
        likedSong.songID = Int64(albumDetail.id)
        likedSong.songTitle = albumDetail.title
        likedSong.songDuration = Int32(albumDetail.duration)
        likedSong.songImage = selectedAlbum.cover_medium
        
    }
    
    func removeLike(for albumDetail: AlbumDetailDataModel, context: NSManagedObjectContext) {
        let fetchRequest: NSFetchRequest<LikedModel> = LikedModel.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "songID == %lld", albumDetail.id)
        
        do {
            let result = try context.fetch(fetchRequest)
            if let likedSong = result.first {
                context.delete(likedSong)
            }
        } catch {
            print("Error removing like at albumDetailPage: \(error)")
        }
    }
    
    //MARK: - LoadImageData
    func loadImageData(from urlString: String, completion: @escaping (Data?) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let data = data {
                completion(data)
            } else {
                completion(nil)
            }
        }.resume()
    }
    
}
