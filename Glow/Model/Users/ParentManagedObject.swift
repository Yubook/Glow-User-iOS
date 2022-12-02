//
//  ParentManagedObject.swift
//  Fade
//
//  Created by Devang Lakhani  on 4/23/21.
//  Copyright © 2021 Devang Lakhani. All rights reserved.
//

import Foundation
import CoreData

extension NSManagedObject {
    class func entityName() -> String {
        return "\(self.classForCoder())"
    }
    
    class func deleteRemovedObject(oldObjs: [NSManagedObject], newObjs:[NSManagedObject]){
        var setOld = Set(oldObjs)
        let setNew = Set(newObjs)
        
        setOld.subtract(setNew)
        
        for obj in setOld{
            _appDelegator.managedObjectContext.delete(obj)
        }
        _appDelegator.saveContext()
    }
}

//MARK: - Protocol ParentManagedObject
protocol ParentManagedObject {
    
}

extension ParentManagedObject where Self: NSManagedObject {
    
    /***
     It will create a new entity in database by passing its name and return NSManagedObject
     */
    static func createNewEntity() -> Self {
        let object = NSEntityDescription.insertNewObject(forEntityName: Self.entityName(), into: _appDelegator.managedObjectContext) as! Self
        return object
    }
    
    static func addUpdateEntity(key: String,value: String) -> Self {
        let predicate = NSPredicate(format: "%K = %@",key,value)
        
        let results = fetchDataFromEntity(predicate: predicate, sortDescs: nil)
        let entity: Self
        
        if results.isEmpty{
            entity = createNewEntity()
        }else{
            entity = results.first!
        }
        return entity
    }
    
    
    /***
     It will return NSEntityDescription optional value, by passing entity name.
     */
    static func getExisting() -> NSEntityDescription? {
        let entityDesc = NSEntityDescription.entity(forEntityName: Self.entityName(), in: _appDelegator.managedObjectContext)
        return entityDesc
    }
    
    /***
     It will return an array of existing values from given entity name, with peredicate and sort description.
     */
    static func fetchDataFromEntity(predicate:NSPredicate?, sortDescs:NSArray?)-> [Self] {
        let entityDesc = getExisting()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        fetchRequest.entity = entityDesc
        
        if let _ = predicate {
            fetchRequest.predicate = predicate
        }
        if let _ = sortDescs {
            fetchRequest.sortDescriptors = sortDescs as? Array
        }
        
        do {
            let resultsObj = try _appDelegator.managedObjectContext.fetch(fetchRequest)
            if (resultsObj as! [Self]).count > 0 {
                return resultsObj as! [Self]
            }else{
                return []
            }
            
        } catch let error as NSError {
            kprint(items: "Error in fetchedRequest : \(error.localizedDescription)")
            return []
        }
    }
}
