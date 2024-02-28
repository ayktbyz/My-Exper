//
//  UserCarInfoManager.swift
//  My Expert
//
//  Created by AYKUT BEYAZ on 14.01.2024.
//

import CoreData
import UIKit

class UserCarInfoManager {

    static let shared = UserCarInfoManager()
    private let appDelegate: AppDelegate
    private let context: NSManagedObjectContext

    private init() {
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
    }

    func fetchAllUserCarInfo() -> [UserCarInfo]? {
        let request: NSFetchRequest<UserCarInfo> = UserCarInfo.fetchRequest()
        request.returnsObjectsAsFaults = false
        
        do {
            return try context.fetch(request)
        } catch {
            print("Error fetching data: \(error)")
            return nil
        }
    }
    
    func fetchUserCarInfo(by id: UUID) -> UserCarInfo? {
        let request: NSFetchRequest<UserCarInfo> = UserCarInfo.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        request.returnsObjectsAsFaults = false
        
        do {
            let results = try context.fetch(request)
            return results.first
        } catch {
            print("Error fetching data: \(error)")
            return nil
        }
    }
    
    func deleteUserCarInfo(by id: UUID) -> Bool {
        let request: NSFetchRequest<UserCarInfo> = UserCarInfo.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        
        do {
            let results = try context.fetch(request)
            if let carInfoToDelete = results.first {
                context.delete(carInfoToDelete)
                try context.save()
                return true
            } else {
                print("Car info not found.")
                return false
            }
        } catch {
            print("Error deleting data: \(error)")
            return false
        }
    }
}

