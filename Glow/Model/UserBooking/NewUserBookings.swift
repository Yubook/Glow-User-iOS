//
//  NewUserBookings.swift
//  Fade
//
//  Created by Devang Lakhani  on 11/13/21.
//  Copyright © 2021 Devang Lakhani. All rights reserved.
//

import Foundation

enum EnumChangedStatus{
    case pending
    case none
    
    init(val : Int) {
        if val == 0{
            self = .pending
        }else{
            self = .none
        }
    }
}

class BookingList{
    var arrPreviousBooked :[PreviousBooking] = []
    var arrFeatureBooked : [PreviousBooking] = []
    var arrCurrentBooked : [PreviousBooking] = []
    
    init(dict: NSDictionary) {
        if let previousDict = dict["previous"] as? NSDictionary{
            if let previousData = previousDict["data"] as? [NSDictionary]{
                for data in previousData{
                    let dictData = PreviousBooking(dict: data)
                    self.arrPreviousBooked.append(dictData)
                }
            }
        }
        if let nextDict = dict["next"] as? NSDictionary{
            if let nextData = nextDict["data"] as? [NSDictionary]{
                for data in nextData{
                    let dictData = PreviousBooking(dict: data)
                    self.arrFeatureBooked.append(dictData)
                }
            }
        }
        if let currentDict = dict["today"] as? NSDictionary{
            if let currData = currentDict["data"] as? [NSDictionary]{
                for data in currData{
                    let dictData = PreviousBooking(dict: data)
                    self.arrCurrentBooked.append(dictData)
                }
            }
        }
    }
}

class PreviousBooking{
    var orderId : String
    var totalPay : String
    var isOrderCompleted : Int
    var users : UsersData?
    var arrBarberServices : [Services] = []
    var arrReviews : [BarberReviews] = []
    var lat : String
    var long : String
    var address : String
    var distance : Double
    var chat : Bool
    var chatId : String
    var arrPortfolio : [Portfolio] = []
    
    var bookingStatus : EnumChangedStatus{
        return EnumChangedStatus(val: isOrderCompleted)
    }
    var orderStatus: EnumBookingStatus {
        return EnumBookingStatus(val: isOrderCompleted)
    }
    
    init(dict: NSDictionary) {
        orderId = dict.getStringValue(key: "id")
        totalPay = dict.getStringValue(key: "amount")
        isOrderCompleted = dict.getIntValue(key: "is_order_complete")
        address = dict.getStringValue(key: "address")
        if let userData = dict["barber"] as? NSDictionary{
            self.users = UsersData(dict: userData)
        }
        if let serviceData = dict["service"] as? [NSDictionary]{
            for dictService in serviceData{
                let objData = Services(dict: dictService)
                self.arrBarberServices.append(objData)
            }
        }
        if let reviewData = dict["review"] as? [NSDictionary]{
            for data in reviewData{
                let objData = BarberReviews(dict: data)
                self.arrReviews.append(objData)
            }
        }
        if let arrImgs = dict["review_images"] as? [NSDictionary]{
            for dictImg in arrImgs{
                let objData = Portfolio(dict: dictImg)
                self.arrPortfolio.append(objData)
            }
        }
        lat = dict.getStringValue(key: "latitude")
        long = dict.getStringValue(key: "longitude")
        distance = dict.getDoubleValue(key: "distance")
        chat = dict.getBooleanValue(key: "chat")
        chatId = dict.getStringValue(key: "chat_group_id")
    }
}

class UsersData{
    var id : String
    var name : String
    var imgName : String
    var email : String
    var phone : String
    var address : String
    var lat : String
    var long : String
    var latestLat : String
    var latestLong : String
    var avgRating : String
    var totalRating: String
    var isBarberAvailable : Int
    var isServiceAdded : Int
    var isSlotAdded : Int
    var profileUrl : URL?{
        return URL(string: _storage+imgName)
    }
    
    init(dict : NSDictionary) {
        id = dict.getStringValue(key: "id")
        name = dict.getStringValue(key: "name")
        imgName = dict.getStringValue(key: "profile")
        email = dict.getStringValue(key: "email")
        phone = dict.getStringValue(key: "mobile")
        address = dict.getStringValue(key: "address_line_1")
        lat = dict.getStringValue(key: "latitude")
        long = dict.getStringValue(key: "longitude")
        latestLat = dict.getStringValue(key: "latest_latitude")
        latestLong = dict.getStringValue(key: "latest_longitude")
        avgRating = dict.getStringValue(key: "average_rating")
        totalRating = dict.getStringValue(key: "total_reviews")
        isBarberAvailable = dict.getIntValue(key: "is_barber_available")
        isServiceAdded = dict.getIntValue(key: "is_service_added")
        isSlotAdded = dict.getIntValue(key: "is_availability")
    }
}
