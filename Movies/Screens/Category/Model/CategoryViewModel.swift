//
//  CategoryViewModel.swift
//  Movies
//
//  Created by Ihor Myronishyn on 26.09.2023.
//

import Foundation
import Alamofire

@Observable final class CategoryViewModel {
    
    // MARK: - Properties
    
    var endpoint: Endpoint
    var movies: [Movie] = []
    var isLoading: Bool = false
    var error: Error?
    var page: Int = 1
    var totalPages: Int = 1
    
    // MARK: - Init
    
    init(endpoint: Endpoint = Endpoint(path: .empty, method: .query)) {
        self.endpoint = endpoint
    }
    
    // MARK: - List
    
    @MainActor
    func list() async {
        if page <= totalPages {
            isLoading = true
            
            var parameters: Parameters = endpoint.parameters ?? .language
            parameters["page"] = page
            
            endpoint.parameters = parameters
            Network.shared.request(endpoint: endpoint, decode: MovieListResponse.self) { [weak self] result, status in
                guard let self else { return }
                
                switch result {
                case .success(let response):
                    self.movies += response.results
                    self.page = response.page + 1
                    
                    if totalPages == 1 {
                        self.totalPages = response.totalPages
                    }
                case .failure(let failure):
                    self.error = failure
                }
                
                
                self.isLoading = false
            }
        }
    }
}
