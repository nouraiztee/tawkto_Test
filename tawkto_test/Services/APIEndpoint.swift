//
//  APIEndpoint.swift
//  tawkto_test
//
//  Created by Nouraiz Taimour on 31/07/2024.
//

import Foundation

import Foundation

enum APIEndpoint {
    
    static let baseURL = "https://api.github.com"
    
    case getUsersList(since: Int)
    case getUserDetail(userName: String)
    
    private var path: String {
        switch self {
        case .getUsersList(_):
            return "/users"
        case .getUserDetail(let userName):
            return "/users/\(userName)"
        }
    }
    
    static func endpointURL(for endpoint: APIEndpoint) -> URL? {
        switch endpoint {
        case .getUserDetail(let userName):
            let endpointPath = endpoint.path
            if let url = URL(string: baseURL + endpointPath) {
                return url
            }else {
                return nil
            }
        case .getUsersList(let since):
            let endpointPath = endpoint.path
            var urlComponents = NSURLComponents(string: baseURL + endpointPath)!
            urlComponents.queryItems = [URLQueryItem(name: "since", value: "\(since)")]
            return urlComponents.url!
        }
    }
}
