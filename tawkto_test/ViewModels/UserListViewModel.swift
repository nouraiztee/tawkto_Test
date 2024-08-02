//
//  UserListViewModel.swift
//  tawkto_test
//
//  Created by Nouraiz Taimour on 31/07/2024.
//

import Foundation

protocol UserListViewModelInput {
    func getUsers(sinceID: Int)
}

class UserListViewModel: UserListViewModelInput {
    
    var apiService: GitHubUsersAPIServices
    var didFetchUsersList: () -> () = {}
    
    var usersList: [GitHubUserPresentable]? {
        didSet {
            didFetchUsersList()
        }
    }
    
    
    init(apiService: GitHubUsersAPIServices) {
        self.apiService = apiService
    }
    
    func getUsers(sinceID: Int = 0) {
        apiService.getUsersFromAPI(since: sinceID) { usersResult in
            switch usersResult {
            case .success(let githubUsers):
                let users = githubUsers.map({ user in
                    user.gitHubUser
                })
                let presentableUsers = users.map({ user in
                    GitHubUserPresentable(userModel: user)
                })
                
                if (self.usersList?.isEmpty ?? false) || sinceID == 0 {
                    self.usersList = presentableUsers
                }else {
                    self.usersList?.append(contentsOf: presentableUsers)
                }
                
            case .failure(let error):
                break
            }
        }
    }
}
