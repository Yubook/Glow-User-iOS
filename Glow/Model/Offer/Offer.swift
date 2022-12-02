//
//  Offer.swift
//  Fade
//
//  Created by Devang Lakhani  on 6/3/21.
//  Copyright © 2021 Devang Lakhani. All rights reserved.
//

import Foundation
import UIKit

class Offer{
    var offerName : String
    var offerDiscount : String
    var offerService : OfferService?
    
    init(dict: NSDictionary) {
        offerName = dict.getStringValue(key: "offer_name")
        offerDiscount = dict.getStringValue(key: "offer_percentage")
        if let service = dict["offer_apply_on_service"] as? NSDictionary{
            self.offerService = OfferService(dict: service)
        }
    }
}

class OfferService{
    var serviceName : String
    var price : String
    
    init(dict : NSDictionary) {
        serviceName = dict.getStringValue(key: "name")
        price = dict.getStringValue(key: "price")
    }
}

class Wallet{
    let id : String
    var amount : String
    var userID : String
    
    init(dict: NSDictionary) {
        id = dict.getStringValue(key: "id")
        amount = dict.getStringValue(key: "amount")
        userID = dict.getStringValue(key: "user_id")
    }
}
