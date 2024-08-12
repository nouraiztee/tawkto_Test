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
    
    var localStorageService: GitHubUserCoreDataService
    
    var usersList: [GitHubUserPresentable]? {
        didSet {
            guard let _ = usersList else { return }
            didFetchUsersList()
        }
    }
    var searchedUserList: [GitHubUserPresentable]? {
        didSet {
            didFetchUsersList()
        }
    }
    
    var isSearching = false
    private var queue = OperationQueue()
    
    init(apiService: GitHubUsersAPIServices, localStorageService: GitHubUserCoreDataService) {
        self.apiService = apiService
        self.localStorageService = localStorageService
    }
    
    func getUsers(sinceID: Int = 0) {
        
        if isSearching {
            return
        }
        
        queue.cancelAllOperations()
        queue.qualityOfService = .background
        
        let operation = BlockOperation { [unowned self] in
            
            apiService.getUsersFromAPI(since: sinceID) { usersResult in
                switch usersResult {
                case .success(let githubUsers):
                    let users = githubUsers.map({ user in
                        user.gitHubUser
                    })
                    self.handleSucessResponse(users: users, shouldResetStorage: ((self.usersList?.isEmpty ?? false) || sinceID == 0 ))
                case .failure(_):
                    let users = self.localStorageService.getUsers()
                    if !users.isEmpty {
                        let customUsers = users.map({
                            $0.customUser
                        })
                        let presentableUsers = customUsers.map({ user in
                            GitHubUserPresentable(userModel: user)
                        })
                        if self.usersList?.isEmpty ?? false || sinceID == 0 {
                            self.usersList = presentableUsers
                        }else {
                            self.usersList?.append(contentsOf: presentableUsers)
                        }
                        self.didFetchUsersList()
                    }
                }
            }
        }
        self.queue.addOperation(operation)
    }
    
    func getUserListCount() -> Int {
        if isSearching {
            return searchedUserList?.count ?? 0
        }else {
            return usersList?.count ?? 0
        }
    }
    
    func getUserDataSource() -> [GitHubUserPresentable]? {
        if isSearching {
            return searchedUserList
        }else {
            return usersList
        }
    }
    
    private func handleSucessResponse(users: [GitHubUserModel], shouldResetStorage: Bool = false) {
        
        var cdUsers = [CoreDataUser]()
        for user in users {
            let cdUser = self.localStorageService.setUser(user: user)
            cdUsers.append(cdUser)
        }
        
        localStorageService.saveContext()
        
        let presentableUsers = users.map({ user in
            var userWithNote = user
            userWithNote.note = localStorageService.getNote(forUser: user.login ?? "")
            return GitHubUserPresentable(userModel: userWithNote)
        })
        
        if shouldResetStorage {
            self.usersList = presentableUsers
        }else {
            self.usersList?.append(contentsOf: presentableUsers)
        }
    }
    
    func getLocalUsers() {
        usersList = localStorageService.getUsers().map({
            GitHubUserPresentable(userModel: $0.customUser)
        })
    }
    
    func setSearch(isSeacrhing: Bool) {
        self.isSearching = isSeacrhing
    }
    
    func getSearchedUser(withKeyWord keyword: String) {
        let searchedUsers = usersList?.filter({
            let matchedUserName = $0.getUsername().lowercased().contains(keyword.lowercased())
            let matchedNote = $0.getNote().lowercased().contains(keyword.lowercased())
            
            return matchedUserName || matchedNote
        })
        
        if isSearching {
            self.searchedUserList = searchedUsers
        }else {
            self.searchedUserList = usersList
        }
        
    }
}
