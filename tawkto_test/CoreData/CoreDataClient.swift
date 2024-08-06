//
//  CoreDataClient.swift
//  tawkto_test
//
//  Created by Nouraiz Taimour on 04/08/2024.
//

import Foundation
import CoreData

protocol GitHubUserCoreDataService: CoreDataService {
    func saveUser(user: GitHubUserModel)
    func getUsers() -> [CoreDataUser]
    func getUser(username: String) -> CoreDataUser?
    func updateUser(user: GitHubUserModel)
    func saveNote(forUser login: String, note: String)
    func getNote(forUser login: String) -> String
}

class CoreDataClient: GitHubUserCoreDataService {
    
    
    static let shared = CoreDataClient()
    
    // MARK: Context's
    lazy var mainContext: NSManagedObjectContext = {
        return persistentContainer.viewContext
    }()
    
    lazy var backgroundContext: NSManagedObjectContext = {
        let context = self.persistentContainer.newBackgroundContext()
        context.automaticallyMergesChangesFromParent = true
        return context
    }()
    
    var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CoreDataUserModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            print(storeDescription)
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func saveContext() {
        guard backgroundContext.hasChanges else { return }
        
        backgroundContext.performAndWait {
            do {
                try self.backgroundContext.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func clearUsersStorage() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CoreDataUser")
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try mainContext.execute(batchDeleteRequest)
        } catch let error as NSError {
            print(error)
        }
    }
    
    func saveUser(user: GitHubUserModel) {
        do {
            let existingUser = getUser(username: user.login ?? "")
            if existingUser != nil {
                existingUser?.login = user.login
                existingUser?.id = Int32(exactly: user.id ?? -1) ?? -1
                existingUser?.avatarUrl = user.avatarURL
                existingUser?.name = user.name
                existingUser?.company = user.company
                existingUser?.blog = user.blog
                existingUser?.followers = Int32(exactly: user.followers ?? -1) ?? -1
                existingUser?.following = Int32(exactly: user.following ?? -1) ?? -1
                existingUser?.url = user.url
            }else {
                let entity = NSEntityDescription.entity(forEntityName: "CoreDataUser", in: backgroundContext)
                let newUser = NSManagedObject(entity: entity!, insertInto: backgroundContext) as! CoreDataUser
                newUser.setData(FromUserModel: user)
            }
            
            saveContext()
        }catch {
            print(error)
        }
    }
    
    func getUsers() -> [CoreDataUser] {
        
        let fetchRequest = NSFetchRequest<CoreDataUser>(entityName: "CoreDataUser")
        
        do {
            let users = try mainContext.fetch(fetchRequest)
            return users
        } catch let error {
            print(error)
        }
        
        return []
        
    }
    
    func getUser(username: String) -> CoreDataUser? {
        
        let fetchRequest = NSFetchRequest<CoreDataUser>(entityName: "CoreDataUser")
        
        let predicate = NSPredicate(format: "login = %@", username)
        fetchRequest.predicate = predicate
        
        do {
            let users = try mainContext.fetch(fetchRequest)
            return users.first
        } catch let error {
            print(error)
            return nil
        }
        
    }
    
    func updateUser(user: GitHubUserModel) {
        
        let fetchRequest = NSFetchRequest<CoreDataUser>(entityName: "CoreDataUser")
        
        let predicate = NSPredicate(format: "login == '\(user.login ?? "")'")
        fetchRequest.predicate = predicate
        
        do {
            
            let users = try backgroundContext.fetch(fetchRequest)
            let CoreDataUser = users.first
            
            CoreDataUser?.setData(FromUserModel: user)
            
            saveContext()
            
        } catch let error {
            print(error)
        }
        
    }
    
    func saveNote(forUser login: String, note: String) {
        let fetchRequest = NSFetchRequest<CoreDataUser>(entityName: "CoreDataUser")
        
        let predicate = NSPredicate(format: "login = %@", login)
        fetchRequest.predicate = predicate
        
        do {
            let user = try backgroundContext.fetch(fetchRequest)
            user.first?.setValue(note, forKey: "note")
            saveContext()
        } catch let error {
            print(error)
        }
    }
    
    func getNote(forUser login: String) -> String {
        let fetchRequest = NSFetchRequest<CoreDataUser>(entityName: "CoreDataUser")
        
        let predicate = NSPredicate(format: "login == %@", "\(login)")
        fetchRequest.predicate = predicate
        
        do {
            let user = try mainContext.fetch(fetchRequest)
            return user.first?.note ?? ""
        } catch let error {
            print(error)
            return ""
        }
    }
}
