//
//  NearestDrivers.swift
//  Fade
//
//  Created by Devang Lakhani  on 5/17/21.
//  Copyright © 2021 Devang Lakhani. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreLocation

class NearestDriver{
    let id : String
    let name : String
    let email : String
    let phone : String
    let gender : String
    let strProfile : String
    let role : String
    let address : String
    let vanNumber : String
    var latitude : String
    var longitude : String
    var distance : String
    var avgRating : String
    var totalRating : String
    var arrService : [DriverServices] = []
    
    var profileUrl : URL?{
        return URL(string: _storage+strProfile)
    }
    
    
    init(dict: NSDictionary) {
        id = dict.getStringValue(key: "id")
        role = dict.getStringValue(key: "role_id")
        name = dict.getStringValue(key: "name")
        email = dict.getStringValue(key: "email")
        phone = dict.getStringValue(key:  "mobile")
        gender = dict.getStringValue(key: "gender")
        strProfile = dict.getStringValue(key: "image")
        address = dict.getStringValue(key: "address")
        vanNumber = dict.getStringValue(key: "van_number")
        avgRating = dict.getStringValue(key: "average_rating")
        totalRating = dict.getStringValue(key: "total_rating")
        latitude = dict.getStringValue(key: "latitude")
        longitude = dict.getStringValue(key: "longitude")
        distance = dict.getStringValue(key: "distance")
            
        if let driverService = dict["service"] as? [NSDictionary]{
            for data in driverService{
                let services = DriverServices(dict: data)
                self.arrService.append(services)
            }
        }
    }
}

class DriverServices{
    var name : String
    var price  : String
    var time : String
    
    
    init(dict : NSDictionary) {
        name = dict.getStringValue(key: "name")
        price = dict.getStringValue(key: "price")
        time = dict.getStringValue(key: "required_time")
    }
}


class CustomPin : NSObject, MKAnnotation{
    var coordinate: CLLocationCoordinate2D
    var title : String?
    var subtitle: String?
    
    init(pinTitle: String, pinSubtitle: String, location: CLLocationCoordinate2D){
        self.coordinate = location
        self.title = pinTitle
        self.subtitle = pinSubtitle
    }
}


struct Location{
    let name : String
    let coordinates : CLLocationCoordinate2D
}

class LocationManager {
    static let shared = LocationManager()
    public func findLocation(with query: String, completion : @escaping (([Location]) -> ())){
        let geoCoding = CLGeocoder()
        
        geoCoding.geocodeAddressString(query) { places, error in
            guard let places = places,error == nil else {
                completion ([])
                return
            }
            let models : [Location] = places.compactMap ({ place in
                var name : String = ""
                
                if let locationName = place.name{
                    name += locationName
                }
                if let adminRegion = place.administrativeArea{
                    name += ", \(adminRegion)"
                }
                if let locality = place.locality{
                    name += ", \(locality)"
                }
                if let country = place.country{
                    name += ", \(country)"
                }
                if let subLocality = place.subLocality{
                    name += ", \(subLocality)"
                }
                if let subStreetLocality = place.subThoroughfare{
                    name += ", \(subStreetLocality)"
                }
                
                let result = Location(name: name, coordinates: place.location?.coordinate ?? CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0))
                return result
                
            })
            completion(models)
        }
    }
}
