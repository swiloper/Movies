//
//  Network.swift
//  Movies
//
//  Created by Ihor Myronishyn on 04.09.2023.
//

import Foundation
import Alamofire

protocol Networking {
    func request<T: Decodable>(endpoint: Endpoint, decode decodable: T.Type, completion: @escaping (Result<T, Error>, Int) -> Void)
}

enum NetworkError: Error {
    case decoding
}

final class Network: Networking {
    
    // MARK: - Init
    
    private init() {
        // Nothing.
    }
    
    // MARK: - Shared
    
    static let shared = Network()
    
    // MARK: - Request
    
    func request<T: Decodable>(endpoint: Endpoint, decode decodable: T.Type, completion: @escaping (Result<T, Error>, Int) -> Void) {
        AF.request(endpoint)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: T.self) { data in
                if let request = data.request, let data = data.data, let jsonDescription = data.pretty {
                    print("Request: \(request)")
                    print("Response: \(jsonDescription)")
                    print(String.empty)
                }
                
                if let response = data.response {
                    switch data.result {
                    case .success:
                        if let result = data.value {
                            completion(.success(result), response.statusCode)
                        } else {
                            completion(.failure(NetworkError.decoding), response.statusCode)
                        }
                    case .failure(let error):
                        completion(.failure(error), response.statusCode)
                    }
                }
            }
    }
}
