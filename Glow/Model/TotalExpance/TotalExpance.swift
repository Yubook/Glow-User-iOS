//
//  TotalExpance.swift
//  Fade
//
//  Created by Devang Lakhani  on 5/29/21.
//  Copyright © 2021 Devang Lakhani. All rights reserved.
//

import Foundation
import UIKit

class TotalExpance{
    var isOrderCompleted : Int 
    var createdDate : Date?
    var amount : String
    var arrServices : [Services] = []
  //  var totalServices : ExpanceServices?
    
    var strDate : String{
        let strPrefix = Date.localDateString(from: createdDate, format: "EEEE, MMM d, yyyy")
        let strSuffix = Date.localDateString(from: createdDate, format: "h:mm a")
        return "\(strPrefix) @ \(strSuffix)"
    }
    
    init(dict: NSDictionary) {
        isOrderCompleted = dict.getIntValue(key: "is_order_complete")
        createdDate = Date.dateFromServerFormat(from: dict.getStringValue(key: "created_at"))
        amount = dict.getStringValue(key: "amount")
        if let dictService = dict["service"] as? [NSDictionary]{
            for dictData in dictService{
                let objData = Services(dict: dictData)
                self.arrServices.append(objData)
            }
            //self.totalServices = ExpanceServices(dict: dictService)
        }
    }
}

class ExpanceServices{
    var name : String
    var price : String
    
    init(dict : NSDictionary) {
        name = dict.getStringValue(key: "name")
        price = dict.getStringValue(key: "price")
    }
}
