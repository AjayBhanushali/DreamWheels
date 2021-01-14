//
//  DataBaseUtils.swift
//  PixbayApp
//
//  Created by Ajay Bhanushali on 18/12/20.
//

import UIKit
import CoreData

class DataBaseUtils {
    static let shared = DataBaseUtils()
    private var context: NSManagedObjectContext
    
    private init() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
    }
    
    @discardableResult
    func insertSearchText(object: String) -> Bool {
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "RecentSearch")
        
        do {
            let recentSearches = try context.fetch(request)
            
            if recentSearches.count == 10 {
                let objectToDelete = recentSearches[0] as! NSManagedObject
                context.delete(objectToDelete)
            }
            
            let predicate = NSPredicate(format: "searchText = %@", object)
            request.predicate = predicate
            
            do {
                let result = try context.fetch(request) as! [RecentSearch]
                if result.isEmpty {
                    guard let entity = NSEntityDescription.entity(forEntityName: "RecentSearch", in: context) else { return false }
                    let recentSearch = NSManagedObject(entity: entity, insertInto: context)
                    recentSearch.setValue(object, forKey: "searchText")
                } else {
                    return true
                }
            } catch {
                return false
            }
            
            do {
                try context.save()
            } catch {
                print("Failed saving")
                return false
            }
        } catch {
            print("Failed")
            return false
        }
        
        return true
    }
    
    func fetchAllSearchText() -> [String]? {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "RecentSearch")
        do {
            guard let recentSearches = try context.fetch(request) as? [RecentSearch] else { return nil }
            return recentSearches.compactMap { (search) -> String? in
                return search.searchText
            }
        } catch {
            print("Failed")
            return nil
        }
    }
}

