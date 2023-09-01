//
//  LikesViewModel.swift
//  DeezerAppSwift
//
//  Created by furkan sakız on 17.08.2023.
//

import Foundation
import CoreData

class LikesViewModel {
    
    func fetchLikedSongs() -> [LikedModel] {
        let context = CoreDataStack.shared.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<LikedModel> = LikedModel.fetchRequest()
        
        do {
            let likedSongs = try context.fetch(fetchRequest)
            return likedSongs
        } catch {
            print("Fetching liked songs failed: \(error)")
            return []
        }
    }
    
    func playPreview(for song: LikedModel) {
        if let previewURL = URL(string: song.songPreview!) {
            AudioManager.shared.playAudio(from: previewURL)
        }
    }
    
    func stopPreview() {
        AudioManager.shared.stopAudio()
    }
    
    //MARK: - Liked Song Funcs
    func toggleLike(for likedSong: LikedModel) {
        let context = DeezerAppSwift.CoreDataStack.shared.persistentContainer.viewContext
        
        if isLiked(likedSong: likedSong) {
            
            removeLike(for: likedSong, context: context)
        }
        CoreDataStack.shared.saveContext()
    }
    
    func isLiked(likedSong: LikedModel) -> Bool {
        let context = CoreDataStack.shared.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<LikedModel> = LikedModel.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "songID == %lld", likedSong.songID)
        
        do {
            let result = try context.fetch(fetchRequest)
            return !result.isEmpty
        } catch {
            print("Error checking if liked: \(error)")
            return false
        }
    }
    
    func removeLike(for item: NSManagedObject, context: NSManagedObjectContext) {
        if let songID = item.value(forKey: "songID") as? Int64 {
            let fetchRequest: NSFetchRequest<NSManagedObject> = NSFetchRequest(entityName: item.entity.name ?? "")
            fetchRequest.predicate = NSPredicate(format: "songID == %lld", songID)
            
            do {
                let result = try context.fetch(fetchRequest)
                if let item = result.first {
                    context.delete(item)
                }
            } catch {
                print("Error removing item: \(error)")
            }
        }
    }
}
