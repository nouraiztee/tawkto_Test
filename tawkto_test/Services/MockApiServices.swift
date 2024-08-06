//
//  MockApiServices.swift
//  tawkto_test
//
//  Created by Nouraiz Taimour on 06/08/2024.
//

import Foundation

class MockApiServices: GitHubUsersAPIServices {
    func getUsersFromAPI(since: Int, completion: @escaping (Result<[GitHubUserAPIModel], NetworkError>) -> ()) {
        let pathString = Bundle(for: type(of: self)).path(forResource: "GithubUsers", ofType: "json")!
        let url = URL(fileURLWithPath: pathString)
        let jsonData = try! Data(contentsOf: url)
        let users = try! JSONDecoder().decode([GitHubUserAPIModel].self, from: jsonData)
        
        completion(.success(users))
    }
    
    func getUserDetails(forUserName name: String, completion: @escaping (Result<GitHubUserAPIModel, NetworkError>) -> ()) {
        let pathString = Bundle(for: type(of: self)).path(forResource: "GithubUserDetail", ofType: "json")!
        let url = URL(fileURLWithPath: pathString)
        let jsonData = try! Data(contentsOf: url)
        let user = try! JSONDecoder().decode(GitHubUserAPIModel.self, from: jsonData)
        
        completion(.success(user))
    }
    
    
}
