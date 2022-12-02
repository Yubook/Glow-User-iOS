//
//  NearByBarbers.swift
//  Fade
//
//  Created by Chirag Patel on 12/11/21.
//  Copyright © 2021 Devang Lakhani. All rights reserved.
//

import Foundation

class NearestBarber{
    let barberId : String
    let mobile : String
    var name : String
    var email : String
    var address : String
    var latitude : String
    var longitude : String
    var latestLongitude : String
    var latestLatitude : String
    var distance : String
    var profile : String
    var gender : String
    var isFav : Bool
    var avgRating : String
    var totalReview : String
    var state : State?
    var city : City?
    var isAvaiable : Int
    var arrBarberServices : [BarberService] = []
    
    var profileUrl : URL?{
        return URL(string: _storage+profile)
    }
    
    init(dict: NSDictionary) {
        barberId = dict.getStringValue(key: "barber_id")
        mobile = dict.getStringValue(key: "mobile")
        name = dict.getStringValue(key: "name")
        email = dict.getStringValue(key: "email")
        address = dict.getStringValue(key: "address_line_1")
        latitude = dict.getStringValue(key: "latitude")
        latestLatitude = dict.getStringValue(key: "latest_latitude")
        longitude = dict.getStringValue(key: "longitude")
        latestLongitude = dict.getStringValue(key: "latest_longitude")
        distance = dict.getStringValue(key: "distance")
        profile = dict.getStringValue(key: "profile")
        gender = dict.getStringValue(key: "gender")
        isFav = dict.getBooleanValue(key: "is_favourite")
        avgRating = dict.getStringValue(key: "average_rating")
        totalReview = dict.getStringValue(key: "total_reviews")
        isAvaiable = dict.getIntValue(key: "is_available")
        if let dictState = dict["state"] as? NSDictionary{
            self.state = State(dict: dictState)
        }
        if let dictCity = dict["city"] as? NSDictionary{
            self.city = City(dict: dictCity)
        }
        
        if let arrServices = dict["services"] as? [NSDictionary]{
            for dictService in arrServices{
                let objData = BarberService(dict: dictService)
                self.arrBarberServices.append(objData)
            }
        }
    }
}
class State{
    var state : String
    
    init(dict: NSDictionary) {
        state = dict.getStringValue(key: "name")
    }
}
class City{
    var city : String
    
    init(dict: NSDictionary) {
        city = dict.getStringValue(key: "name")
    }
}


class BarberService{
    var id : String
    var servicePrice : String
    var isSelected = false
    var barberServiceDict : Services?
    var serviceName : String
    
    init(dict: NSDictionary) {
        id = dict.getStringValue(key: "id")
        servicePrice = dict.getStringValue(key: "service_price")
        serviceName = dict.getStringValue(key: "service_name")
        if let dictService = dict["service"] as? NSDictionary{
            self.barberServiceDict = Services(dict: dictService)
        }
    }
}
