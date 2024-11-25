//
//  NetworkManager.swift
//  TestSwiftConcurrency
//
//  Created by Mohammad Alabed on 24/11/2024.
//

import Foundation
import SwiftUI

enum APIConstants: String {
    case imageListPath = "https://picsum.photos/v2/list"
    case imagePath = "https://picsum.photos/id/"
}

class NetworkManager {
    static var shared = NetworkManager()
    func fetchDataWithCompletion(url: URL, completion: @escaping (Result<Data, Error>) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
            } else if let data = data {
                completion(.success(data))
            }
        }
        task.resume()
    }
    
    func downloadImage(id: String, completion: @escaping (_ image: Image?, _ error: CustomError?) -> Void) {
        guard let url = URL(string: APIConstants.imagePath.rawValue + "\(id)/100/100") else {
            completion(nil, CustomError.invalidURL)
            return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(nil, CustomError.networkFailure(description: error.localizedDescription))
                return
            }
            
            guard let data = data, let uiImage = UIImage(data: data) else {
                completion(nil, CustomError.networkFailure(description: "Failed to load image"))
                return
            }
            
            completion(Image(uiImage: uiImage), nil)
        }.resume()
    }
}

enum CustomError: Error {
    case invalidURL
    case networkFailure(description: String)
    case decodingError
    case unknownError
}

