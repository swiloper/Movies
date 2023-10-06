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
            
            var parameters: Parameters = .language
            parameters["page"] = page
            
            let endpoint = Endpoint(path: EndpointPath.category(category.rawValue), method: .get, headers: .default, parameters: parameters)
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
