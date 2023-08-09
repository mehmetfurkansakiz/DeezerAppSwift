//
//  APIManager.swift
//  DeezerAppSwift
//
//  Created by furkan sakız on 2.08.2023.
//

import Foundation


class APIManager {
    static let shared = APIManager()
    
    private init() {}
    
    func get<T: Decodable>(url: URL, responseType: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let data = data {
                
                do {
                    let decoder = JSONDecoder()
                    let result = try decoder.decode(T.self, from: data)
                    completion(.success(result))
                } catch {
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
}
