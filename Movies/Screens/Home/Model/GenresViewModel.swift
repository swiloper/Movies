//
//  GenresViewModel.swift
//  Movies
//
//  Created by Ihor Myronishyn on 05.09.2023.
//

import Foundation

@Observable final class GenresViewModel {
    
    // MARK: - Properties
    
    var items: [Genre] = []
    var isLoading: Bool = false
    var error: Error?
    
    // MARK: - List
    
    func list() {
        isLoading = true
        let endpoint = Endpoint(path: EndpointPath.genres, method: .get, headers: .default, parameters: .language)
        Network.shared.request(endpoint: endpoint, decode: GenreListResponse.self) { [weak self] result, status in
            guard let self else { return }
            
            switch result {
            case .success(let response):
                self.items = response.genres
            case .failure(let failure):
                self.error = failure
            }
            
            self.isLoading = false
        }
    }
    
    // MARK: - Name
    
    func name(id: Int) -> String? {
        guard let result = items.first(where: { $0.id == id }) else { return nil }
        return result.name
    }
}
