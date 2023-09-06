//
//  Endpoint.swift
//  Movies
//
//  Created by Ihor Myronishyn on 04.09.2023.
//

import Foundation
import Alamofire

struct Endpoint: Routable {
    var path: String
    var method: HTTPMethod
    var headers: HTTPHeaders?
    var parameters: Parameters?
    var encoding: ParameterEncoding = URLEncoding.default
}

extension HTTPHeaders {
    static let `default`: HTTPHeaders = [.accept("application/json"), .authorization(bearerToken: EndpointPath.token)]
}

extension Parameters {
    static let language: Parameters = ["language": "en"]
}
