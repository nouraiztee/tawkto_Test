//
//  GitHubUserFormated.swift
//  tawkto_test
//
//  Created by Nouraiz Taimour on 31/07/2024.
//

import Foundation
import UIKit

struct GitHubUserPresentable: GitHubUserCellViewModel {
   
    private var user: GitHubUserModel
    
    init(userModel: GitHubUserModel) {
        self.user = userModel
    }
    
    func getUserID() -> Int {
        user.id ?? 0
    }
    
    func getUsername() -> String {
        user.login ?? ""
    }
    
    func getProfileUrl() -> String {
        user.url ?? ""
    }
    
    func getAvatarUrl() -> String {
        user.avatarURL ?? ""
    }
    
    func hasNote() -> Bool {
        user.note == nil ? false : true
    }
    
    func getFollowersCount() -> Int {
        user.followers ?? 0
    }
    
    func getFollowingCount() -> Int {
        user.following ?? 0
    }
    
    func getCompany() -> String {
        user.company ?? ""
    }
    
    func getBlog() -> String {
        user.blog ?? ""
    }
    
    func getNote() -> String {
        user.note ?? ""
    }
    
    func dequeueCell(tableView: UITableView, indexPath: IndexPath) -> UserCustomCell? {
        var cell: UserCustomCell? = nil
        
        if ((indexPath.row + 1) % 4) == 0 {
            if hasNote() {
                cell = tableView.dequeueCell(GitHubUserNoteInvertedTableViewCell.self, for: indexPath)
            }else {
                cell = tableView.dequeueCell(GitHubUserInvertedTableViewCell.self, for: indexPath)
            }
        }else if hasNote() {
            cell = tableView.dequeueCell(GitHubUserNoteTableViewCell.self, for: indexPath)
        }else {
            cell = tableView.dequeueCell(GitHubUserListTableViewCell.self, for: indexPath)
        }
        
        return cell
    }
     
}
