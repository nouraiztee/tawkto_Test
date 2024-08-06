//
//  CoreDataUser+CoreDataClass.swift
//  tawkto_test
//
//  Created by Nouraiz Taimour on 04/08/2024.
//
//

import Foundation
import CoreData

@objc(CoreDataUser)
public class CoreDataUser: NSManagedObject {

    func setData(FromUserModel model: GitHubUserModel) {
        avatarUrl = model.avatarURL ?? ""
        blog = model.blog ?? ""
        company = model.company ?? ""
        followers = Int32(exactly: model.followers ?? 0) ?? 0
        following = Int32(exactly: model.following ?? 0) ?? 0
        id = Int32(exactly: model.id ?? -1) ?? -1
        login = model.login ?? ""
        name = model.name ?? ""
        note = model.note ?? ""
        url = model.url ?? ""
    }
    
    var customUser: GitHubUserModel {
        return GitHubUserModel(login: login, id: Int(id), avatarURL: avatarUrl, name: name, company: company, blog: blog, followers: Int(followers), following: Int(following), url: url, note: note)
    }
}
