//
//  APIServices.swift
//  tawkto_test
//
//  Created by Nouraiz Taimour on 31/07/2024.
//

import Foundation

protocol GitHubUsersAPIServices {
    func getUsersFromAPI(since: Int, completion: @escaping (Result<[GitHubUserAPIModel], NetworkError>) -> ())
}

struct GitHubUsersAPIClient: GitHubUsersAPIServices {
    
    var networkService: NetworkServices
    
    init(networkService: NetworkServices = NetworkManager.shared) {
        self.networkService = networkService
    }
    
    func getUsersFromAPI(since: Int, completion: @escaping (Result<[GitHubUserAPIModel], NetworkError>) -> ()) {
        
        guard let url = APIEndpoint.endpointURL(for: .getUsersList(since: since)) else {
            return completion(.failure(.invalidURL))
        }
        
        networkService.callGetAPI(forURL: url, withresponseType: [GitHubUserAPIModel].self) { result in
            completion(result)
        }
    }
    
}
