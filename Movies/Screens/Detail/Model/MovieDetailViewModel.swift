//
//  MovieDetailViewModel.swift
//  Movies
//
//  Created by Ihor Myronishyn on 22.09.2023.
//

import Foundation

final class MovieDetailViewModel: ObservableObject {
    
    // MARK: - Properties
    
    @Published var isLoading: Bool = false
    @Published var error: Error?
    @Published var movie: Movie?
    
    // MARK: - Detail
    
    func detail(for id: Int) async {
        await MainActor.run {
            self.isLoading = true
            let endpoint = Endpoint(path: EndpointPath.movie(id), method: .get, headers: .default, parameters: .language)
            Network.shared.request(endpoint: endpoint, decode: Movie.self) { [weak self] result, status in
                guard let self else { return }
                
                switch result {
                case .success(let response):
                    self.movie = response
                case .failure(let failure):
                    self.error = failure
                }
                
                self.isLoading = false
            }
        }
    }
}
