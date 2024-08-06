//
//  UserDetailsViewModel.swift
//  tawkto_test
//
//  Created by Nouraiz Taimour on 04/08/2024.
//

import Foundation

protocol UserDetailsViewModelInput {
    func getUserDetails()
}

class UserDetailsViewModel: UserDetailsViewModelInput {
    
    var apiService: GitHubUsersAPIServices
    var localStorageService: GitHubUserCoreDataService
    var didFetchUserDetails: (GitHubUserPresentable) -> () = {_ in }
    var userName: String!
    
    
    var userDetails: GitHubUserPresentable! {
        didSet {
            didFetchUserDetails(userDetails)
        }
    }
    
    
    init(apiService: GitHubUsersAPIServices, userName: String, localStorageService: GitHubUserCoreDataService) {
        self.apiService = apiService
        self.userName = userName
        self.localStorageService = localStorageService
        
    }
    
    func getUserDetails() {
        apiService.getUserDetails(forUserName: userName) { result in
            switch result {
            case .success(let userDetails):
                self.userDetails = GitHubUserPresentable(userModel: userDetails.gitHubUser)
            case .failure(let error):
                break
            }
        }
    }
    
    func getUserNote(forUserID login: String) -> String {
        self.localStorageService.getNote(forUser: login)
    }
    
    func saveUserNote(forUserID login: String, note: String) {
        self.localStorageService.saveNote(forUser: login, note: note)
    }
}
