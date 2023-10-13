//
//  SearchViewModel.swift
//  Movies
//
//  Created by Ihor Myronishyn on 09.10.2023.
//

import Foundation
import Alamofire

final class SearchViewModel: ObservableObject {
    
    // MARK: - Properties
    
    @Published var keyword: String = .empty
    @Published var results: [Movie] = []
    
    var isLoading: Bool = false
    var error: Error?
    var lastQuery: String = .empty
    
    var page: Int = 1
    var totalPages: Int = 1
    
    // MARK: - List
    
    @MainActor
    func list() async {
        if page <= totalPages {
            isLoading = true
            
            var parameters: Parameters = .language
            parameters["query"] = keyword
            
            if page != 1, lastQuery == keyword {
                parameters["page"] = page
            }
            
            let endpoint = Endpoint(path: EndpointPath.search(), method: .get, headers: .default, parameters: parameters)
            Network.shared.request(endpoint: endpoint, decode: MovieListResponse.self) { [weak self] result, status in
                guard let self else { return }
                
                switch result {
                case .success(let response):
                    if self.lastQuery == self.keyword {
                        self.results += response.results
                    } else {
                        self.results = response.results
                    }
                    
                    self.page = response.page + 1
                    
                    if totalPages == 1 {
                        self.totalPages = response.totalPages
                    }
                case .failure(let failure):
                    self.error = failure
                }
                
                self.isLoading = false
                self.lastQuery = self.keyword
            }
        }
    }
    
    // MARK: - Reset
    
    func reset() {
        results = []
        isLoading = false
        lastQuery = .empty
        page = 1
        totalPages = 1
    }
}
