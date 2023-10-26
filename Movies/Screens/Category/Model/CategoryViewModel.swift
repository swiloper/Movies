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

    var movies: [Movie] = []
    var isLoading: Bool = false
    var error: Error?
    var page: Int = 1
    var totalPages: Int = 1
    
    // MARK: - List
    
    @MainActor
    func list(category: Category) async {
        if page <= totalPages {
            isLoading = true
            
            var path: String = EndpointPath.category(category.id) 
            var parameters: Parameters = .language
            
            if case .discover(let genre) = category {
                path = EndpointPath.discover()
                parameters["with_genres"] = genre.id
            }
            
            parameters["page"] = page
            
            Network.shared.request(endpoint: Endpoint(path: path, method: .get, headers: .default, parameters: parameters), decode: MovieListResponse.self) { [weak self] result, status in
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
