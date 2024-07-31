//
//  GitHubUserCustomModel.swift
//  tawkto_test
//
//  Created by Nouraiz Taimour on 31/07/2024.
//

import Foundation

protocol GitHubUserCustomModel  {
    var login: String? { get }
    var id: Int { get }
    var avatarURL: String? { get }
    var url: String { get }
    var eventsURL: String? { get }
    var type: String? { get }
    var hasNote: Bool { get }
}

struct GitHubUserModel: GitHubUserCustomModel {
    var login: String?
    
    var id: Int
    
    var avatarURL: String?
    
    var url: String
    
    var eventsURL: String?
    
    var type: String?
    
    var hasNote: Bool
    
}
