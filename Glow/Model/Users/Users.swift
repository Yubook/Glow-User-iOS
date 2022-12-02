//
//  Users.swift
//  Fade
//
//  Created by Devang Lakhani  on 4/23/21.
//  Copyright © 2021 Devang Lakhani. All rights reserved.
//

import Foundation
import CoreData

class Users : NSManagedObject, ParentManagedObject{
    
    @NSManaged var id : String
    @NSManaged var role : String
    @NSManaged var name : String
    @NSManaged var email : String
    @NSManaged var phone : String
    @NSManaged var profilePhoto : String
    @NSManaged var address : String
    @NSManaged var latitude : String
    @NSManaged var longitude : String
    @NSManaged var latestLatitutde : String
    @NSManaged var latestLong : String
    
    var profileUrl : URL?{
        return URL(string: _storage + profilePhoto)
    }
    
    func initWith(dict : NSDictionary){
        id = dict.getStringValue(key: "id")
        role = dict.getStringValue(key: "role_id")
        name = dict.getStringValue(key: "name")
        email = dict.getStringValue(key: "email")
        phone = dict.getStringValue(key: "mobile")
        profilePhoto = dict.getStringValue(key: "profile")
        address = dict.getStringValue(key: "address_line_1")
        latitude = dict.getStringValue(key: "latitude")
        longitude = dict.getStringValue(key: "longitude")
        latestLatitutde = dict.getStringValue(key: "latest_latitude")
        latestLong = dict.getStringValue(key: "latest_longitude")
    }
}
