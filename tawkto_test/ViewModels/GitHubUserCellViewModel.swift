//
//  GitHubUserCellViewModel.swift
//  tawkto_test
//
//  Created by Nouraiz Taimour on 31/07/2024.
//

import Foundation
import UIKit

protocol GitHubUserCellViewModel {
    func getUserID() -> Int
    func getUsername() -> String
    func getProfileUrl() -> String
    func getAvatarUrl() -> String
    func hasNote() -> Bool
    
    func dequeueCell(tableView: UITableView, indexPath: IndexPath) -> UserCustomCell?
    
}
