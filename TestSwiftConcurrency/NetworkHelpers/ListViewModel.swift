//
//  ListViewModel.swift
//  TestSwiftConcurrency
//
//  Created by Mohammad Alabed on 24/11/2024.
//

import Foundation

class ListViewModel: ObservableObject {
    @Published var images: [ImageModel] = []
    var page = 0
    var pageSize = 10
    
    func fetchImages(completion: @escaping (_ success: Bool, _ images: [ImageModel], _ error: CustomError?) -> Void) {
        guard let url = URL(string: APIConstants.imageListPath.rawValue+"?page=\(page)&limit=\(pageSize)") else {
            completion(false, [], CustomError.invalidURL)
            return
        }
        NetworkManager.shared.fetchDataWithCompletion(url: url) { result in
            switch result {
            case .success(let data):
                do {
                    let objects = try? JSONDecoder().decode([ImageModel].self, from: data)
                    DispatchQueue.main.async {
                        self.images.append(contentsOf: objects ?? [])
                        completion(true, self.images, nil)
                    }
                } catch {
                    completion(false, [], CustomError.decodingError)
                }
                self.page += 1
            case .failure(let failure):
                completion(false, [], CustomError.networkFailure(description: failure.localizedDescription))
            }
        }
    }
    
    func fetchDataWithCompine(completion: @escaping (_ success: Bool, _ images: [ImageModel], _ error: CustomError?) -> Void) {
        guard let url = URL(string: APIConstants.imageListPath.rawValue+"?page=\(page)&limit=\(pageSize)") else {
            completion(false, [], CustomError.invalidURL)
            return
        }
        NetworkManager.shared.fetchDataWithCombine(url: url) { result in
            switch result {
            case .success(let data):
                do {
                    let objects = try? JSONDecoder().decode([ImageModel].self, from: data)
                    DispatchQueue.main.async {
                        self.images.append(contentsOf: objects ?? [])
                        completion(true, self.images, nil)
                    }
                } catch {
                    completion(false, [], CustomError.decodingError)
                }
                self.page += 1
            case .failure(let failure):
                completion(false, [], CustomError.networkFailure(description: failure.localizedDescription))
            }
        }
    }
    
    func fetchDataWithAsync(completion: @escaping (_ success: Bool, _ images: [ImageModel], _ error: CustomError?) -> Void) {
        guard let url = URL(string: APIConstants.imageListPath.rawValue+"?page=\(page)&limit=\(pageSize)") else {
            completion(false, [], CustomError.invalidURL)
            return
        }
        NetworkManager.shared.fetchDataWithCombine(url: url) { result in
            Task {
                do {
                    let data = try await NetworkManager.shared.fetchDataWithAsync(url: url)
                    let objects = try? JSONDecoder().decode([ImageModel].self, from: data)
                    DispatchQueue.main.async {
                        self.images.append(contentsOf: objects ?? [])
                        completion(true, self.images, nil)
                    }
                } catch {
                    completion(false, [], CustomError.decodingError)
                }
                self.page += 1
            }
        }
    }
    
    func fetchDataWithGCD(completion: @escaping (_ success: Bool, _ images: [ImageModel], _ error: CustomError?) -> Void) {
        guard let url = URL(string: APIConstants.imageListPath.rawValue+"?page=\(page)&limit=\(pageSize)") else {
            completion(false, [], CustomError.invalidURL)
            return
        }
        NetworkManager.shared.fetchDataWithGCD(url: url) { result in
            Task {
                do {
                    let data = try await NetworkManager.shared.fetchDataWithAsync(url: url)
                    let objects = try? JSONDecoder().decode([ImageModel].self, from: data)
                    DispatchQueue.main.async {
                        self.images.append(contentsOf: objects ?? [])
                        completion(true, self.images, nil)
                    }
                } catch {
                    completion(false, [], CustomError.decodingError)
                }
                self.page += 1
            }
        }
    }
}
