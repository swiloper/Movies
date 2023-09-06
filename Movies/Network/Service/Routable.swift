//
//  Routable.swift
//  Movies
//
//  Created by Ihor Myronishyn on 04.09.2023.
//

import Foundation
import Alamofire

protocol Routable: URLRequestConvertible {
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: HTTPHeaders? { get }
    var parameters: Parameters? { get }
    var encoding: ParameterEncoding { get }
}

extension Routable {
    func asURLRequest() throws -> URLRequest {
        let url = try EndpointPath.base.asURL().appendingPathComponent(path)
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        if let headers {
            request.headers = headers
        }
        
        return try encoding.encode(request, with: parameters)
    }
}
