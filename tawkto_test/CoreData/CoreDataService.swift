//
//  CoreDataService.swift
//  tawkto_test
//
//  Created by Nouraiz Taimour on 04/08/2024.
//

import Foundation
import CoreData

protocol CoreDataService {
    var persistentContainer: NSPersistentContainer { get }
    func saveContext()
}
