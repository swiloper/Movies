//
//  MoviesViewModel.swift
//  Movies
//
//  Created by Ihor Myronishyn on 04.09.2023.
//

import Foundation

final class MoviesViewModel: ObservableObject {
    
    // MARK: - Properties
    
    @Published var loading: [Category] = []
    @Published var error: Error?
    @Published var categories: [Category : [Movie]] = {
        var initial: [Category : [Movie]] = [:]
        Category.allCases.forEach({ initial[$0] = [] })
        return initial
    }()
    
    // MARK: - List
    
    func list() {
        for category in Category.allCases {
            loading.append(category)
            let endpoint = Endpoint(path: EndpointPath.category(category.rawValue), method: .get, headers: .default, parameters: .language)
            Network.shared.request(endpoint: endpoint, decode: MovieListResponse.self) { [weak self] result, status in
                guard let self else { return }
                
                switch result {
                case .success(let response):
                    self.categories[category] = response.results
                case .failure(let failure):
                    self.error = failure
                }
                
                self.loading.removeAll(where: { $0 == category })
            }
        }
    }
}
