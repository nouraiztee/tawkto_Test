//
//  UserDetailsViewModel.swift
//  tawkto_test
//
//  Created by Nouraiz Taimour on 04/08/2024.
//

import Foundation


protocol UserDetailsViewModelInput {
    func getUserDetails(userName: String)
    
    func getUserFollowersText() -> String
    func getUserFollowingText() -> String
    func getUserNameText() -> String
    func getUserCompanyText() -> String
    func getUserBlogText() -> String
    func getUserNote(forUserID login: String) -> String
    func getUserAvatarData() -> Data?
    func getUserAvatar(withUrl url: String)
    
}

class UserDetailsViewModel: UserDetailsViewModelInput, ObservableObject {
    
    var apiService: GitHubUsersAPIServices
    var localStorageService: GitHubUserCoreDataService
    var didFetchUserDetails: (GitHubUserPresentable) -> () = {_ in }
    var userName: String!
    
    
    @Published var userDetails: GitHubUserPresentable!
    @Published var imageData: Data?
    
    
    init(apiService: GitHubUsersAPIServices = GitHubUsersAPIClient(), localStorageService: GitHubUserCoreDataService = CoreDataClient.shared) {
        self.apiService = apiService
        self.localStorageService = localStorageService
        
    }
    
    func getUserDetails(userName: String) {
        apiService.getUserDetails(forUserName: userName) { result in
            switch result {
            case .success(let userDetails):
                DispatchQueue.main.async {
                    self.userDetails = GitHubUserPresentable(userModel: userDetails.gitHubUser)
                }
            case .failure(_):
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
    
    func getUserFollowersText() -> String {
        guard let userDetails else {return ""}
        return "\(userDetails.getFollowersCount())"
    }
    
    func getUserFollowingText() -> String {
        guard let userDetails else {return ""}
        return "\(userDetails.getFollowingCount())"
    }
    
    func getUserNameText() -> String {
        guard let userDetails else {return ""}
        return userDetails.getUsername()
    }
    
    func getUserCompanyText() -> String {
        guard let userDetails else {return ""}
        return userDetails.getCompany()
    }
    
    func getUserBlogText() -> String {
        guard let userDetails else {return ""}
        return userDetails.getBlog()
    }
    
    func getUserAvatar(withUrl url: String) {
        guard let url = URL(string: url) else { return }
        ImageLoader.shared.loadData(url: url) { data, error in
            if data != nil {
                self.imageData = data
            }
        }
    }
    
    func getUserAvatarData() -> Data? {
        guard let imageData = imageData else { return nil }
        return imageData
    }
}
