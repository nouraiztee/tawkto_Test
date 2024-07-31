//
//  NetworkServices.swift
//  tawkto_test
//
//  Created by Nouraiz Taimour on 31/07/2024.
//

import Foundation

enum NetworkError: Error {
    case invalidResponse
    case invalidURL
    case genericError(message: String)
    
    func getErrorMessages() -> (errorTitle: String, errorMessage: String) {
        var errorTitle = ""
        var errorMessage = ""
        switch self {
        case .invalidURL:
            errorTitle = "Invalid URL"
            errorMessage = "Please enter a valid URL."
        case .invalidResponse:
            errorTitle = "Invalid Response"
            errorMessage = "Please make a valid request"
        case .genericError(message: let message):
            errorTitle = "Oops."
            errorMessage = message
        }
        return (errorTitle, errorMessage)
    }
}

protocol NetworkServices {
    func callGetAPI<T: Decodable>(forURL url: URL, withresponseType:T.Type, completion: @escaping (Result<T, NetworkError>) -> ())
}

struct NetworkManager: NetworkServices {
    static let shared = NetworkManager()
    
    func callGetAPI<T: Decodable>(forURL url: URL, withresponseType:T.Type, completion: @escaping (Result<T, NetworkError>) -> ()) {
        //cache api response, load from cache if available else fetch remote
        let urlRequest = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad)
        
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            
            guard let data = data else {
                completion(.failure(.invalidResponse))
                return
            }
            
            do {
                let decodedResponse = try JSONDecoder().decode(T.self, from: data)
                
                completion(.success(decodedResponse))
            }catch {
                completion(.failure(.genericError(message: error.localizedDescription)))
            }
        }.resume()
    }
}
