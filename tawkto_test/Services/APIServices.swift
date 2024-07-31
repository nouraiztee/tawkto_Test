//
//  APIServices.swift
//  tawkto_test
//
//  Created by Nouraiz Taimour on 31/07/2024.
//

import Foundation

protocol GitHubUsersAPIServices {
    
}

struct GitHubUsersAPIClient: GitHubUsersAPIServices {
    
    var networkService: NetworkServices
    
    init(networkService: NetworkServices = NetworkManager.shared) {
        self.networkService = networkService
    }
    
}
