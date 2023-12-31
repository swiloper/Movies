//
//  MovieDetailViewModel.swift
//  Movies
//
//  Created by Ihor Myronishyn on 22.09.2023.
//

import Foundation
import Alamofire

@Observable final class MovieDetailViewModel {
    
    // MARK: - Properties
    
    var movie: Movie?
    var isLoading: Bool = false
    var error: Error?
    
    // MARK: - Detail
    
    func detail(for id: Int) async {
        await MainActor.run {
            self.isLoading = true
            
            var parameters: Parameters = .language
            parameters["append_to_response"] = "credits"
            
            let endpoint = Endpoint(path: EndpointPath.movie(id), method: .get, headers: .default, parameters: parameters)
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
