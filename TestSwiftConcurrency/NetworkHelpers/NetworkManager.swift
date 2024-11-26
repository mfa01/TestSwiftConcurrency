//
//  NetworkManager.swift
//  TestSwiftConcurrency
//
//  Created by Mohammad Alabed on 24/11/2024.
//

import Foundation
import SwiftUI
import Combine

enum APIConstants: String {
    case imageListPath = "https://picsum.photos/v2/list"
    case imagePath = "https://picsum.photos/id/"
}

class NetworkManager {
    static var shared = NetworkManager()
    private var cancellables = Set<AnyCancellable>()
    
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

    private func combineDataTaskPublisher(url: URL) -> AnyPublisher<Data, Error> {
        URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
    
    func fetchDataWithCombine(url: URL, completion: @escaping (Result<Data, Error>) -> Void) {
        combineDataTaskPublisher(url: url).sink { completion in
            switch completion {
            case .finished:
                break
            case .failure(error):
                break
            }
        } receiveValue: { data in
            
        }

        combineDataTaskPublisher(url: url)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("Finished fetching data")
                case .failure(let error):
                    print("Error: \(error)")
                }
            }, receiveValue: { data in
                print("Data fetched: \(data)")
                completion(.success(data))
            })
            .store(in: &cancellables)
    }
    
    func fetchDataWithAsync(url: URL) async throws -> Data {
        let (data, _) = try await URLSession.shared.data(from: url)
        return data
    }

    func fetchDataWithGCD(url: URL, completion: @escaping (Result<Data, Error>) -> Void) {
        DispatchQueue.global(qos: .background).async {
            do {
                let data = try Data(contentsOf: url)
                DispatchQueue.main.async {
                    print("Data fetched: \(data)")
                    completion(.success(data))
                }
            } catch {
                DispatchQueue.main.async {
                    print("Error: \(error)")
                    completion(.failure(error))
                }
            }
        }
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

