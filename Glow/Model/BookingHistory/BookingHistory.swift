//
//  BookingHistory.swift
//  Fade
//
//  Created by Devang Lakhani  on 5/12/21.
//  Copyright © 2021 Devang Lakhani. All rights reserved.
//

import Foundation
import UIKit

enum EnumBookingStatus{
    case completed
    case cancel
    case none
    
    init(val : Int) {
        if val == 1{
            self = .completed
        } else if val == 2{
            self = .cancel
        }else{
            self = .none
        }
    }
}

class BookingHistory{
    var bookingDateTime : Date?
    var serviceName : String
    var serviceCost : String
    var driver : Driver?
    
    var strDate : String{
        let strPrefix = Date.localDateString(from: bookingDateTime, format: "EEEE, MMM d, yyyy")
        let strSuffix = Date.localDateString(from: bookingDateTime, format: "h:mm a")
        return "\(strPrefix) @ \(strSuffix)"
    }
    
    
    init(dict: NSDictionary) {
        bookingDateTime = Date.dateFromServerFormat(from: dict.getStringValue(key: "updated_at"))
        serviceName = dict.getStringValue(key: "service_name")
        serviceCost = dict.getStringValue(key: "service_price")
        if let drivers = dict["service_driver"] as? NSDictionary{
            self.driver = Driver(dict: drivers)
        }
    }
}

class Driver{
    var id : String
    var driverName : String
    var driverImageName : String
    var avgRating : String
    var totalReview : String
    var service : [BookedServices] = []
    
    var imageUrl : URL?{
        return URL(string: _storage+driverImageName)
    }
    
    init(dict : NSDictionary) {
        id = dict.getStringValue(key: "id")
        driverName = dict.getStringValue(key: "name")
        driverImageName = dict.getStringValue(key: "image")
        avgRating = dict.getStringValue(key: "average_rating")
        totalReview = dict.getStringValue(key: "total_rating")
        if let data = dict["service"] as? [NSDictionary]{
            for serviceData in data{
                let dictData = BookedServices(dict: serviceData)
                self.service.append(dictData)
            }
        }
    }
}

class Orders{
    var bookedDate : BookedSlots?
    var driver : Driver?
    var isOrderCompleted : Int
    var amount : String
    var orderServices : BookedServices?
    
    var orderStatus: EnumBookingStatus {
        return EnumBookingStatus(val: isOrderCompleted)
    }
    
    init(dict: NSDictionary) {
        if let slotsData = dict["slot"] as? NSDictionary{
            self.bookedDate = BookedSlots(dict: slotsData)
        }
        if let driverData = dict["driver"] as? NSDictionary{
            self.driver = Driver(dict: driverData)
        }
        if let serviceData = dict["service"] as? NSDictionary{
            self.orderServices = BookedServices(dict: serviceData)
        }
        isOrderCompleted = dict.getIntValue(key: "is_order_complete")
        amount = dict.getStringValue(key: "amount")
    }
}

class BookedServices{
    var name : String
    var cost : String
    
    var intCost : Int?{
        return Int(cost)
    }
    init(dict: NSDictionary) {
        name = dict.getStringValue(key: "name")
        cost = dict.getStringValue(key: "price")
    }
}

class BookedSlots{
    var bookedDate : Date?
    var timing : BookedTiming?
    var id : String
    
    var strDate : String{
        let strPrefix = Date.localDateString(from: bookedDate, format: "EEEE, MMM d, yyyy")
        return "\(strPrefix) @ "
    }
    var strSlotDate : String{
        let strSlotDate = Date.localDateString(from: bookedDate)
        return strSlotDate
    }
    
    init(dict: NSDictionary) {
        if let slotsData = dict["timing_slot"] as? NSDictionary{
            self.timing = BookedTiming(dict: slotsData)
        }
        bookedDate = Date.dateFromAppServerFormat(from: dict.getStringValue(key: "date"))
        id = dict.getStringValue(key: "id")
    }
}

class BookedTiming{
    var time : String
    
    init(dict: NSDictionary) {
        time = dict.getStringValue(key: "time")
    }
}
