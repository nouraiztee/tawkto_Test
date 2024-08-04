//
//  GitHubUserCustomModel.swift
//  tawkto_test
//
//  Created by Nouraiz Taimour on 31/07/2024.
//

import Foundation

protocol GitHubUserCustomModel  {
    var login: String? { get }
    var id: Int? { get }
    var avatarURL: String? { get }
    var name: String? { get }
    var company: String? { get }
    var blog : String? { get }
    var followers: Int? { get }
    var following: Int? { get }
    var url: String? { get }
    var note: String? { get }
    
}

struct GitHubUserModel: GitHubUserCustomModel {

    var login: String?
    var id: Int?
    var avatarURL: String?
    var name: String?
    var company: String?
    var blog: String?
    var followers: Int?
    var following: Int?
    var url: String?
    var note: String?
}
