//
//  AppoitnmentBooking.swift
//  Fade
//
//  Created by Devang Lakhani  on 4/12/21.
//  Copyright © 2021 Devang Lakhani. All rights reserved.
//

import Foundation
import UIKit

enum EnumAppoitnmentsDetails{
    case previousCell
    case currentCell
    case featureCell
    
    init(idx : Int) {
        if idx == 0{
            self = .previousCell
        }else if idx == 1{
            self = .currentCell
        }else{
            self = .featureCell
        }
    }
}

class AppotnmentBooking{
    var id : String
    var driverId : String
    var isBooked : Bool
    var bookedDate : Date?
    var timeSlots : TimeSlots?
    var isSelected = false
    
    var strDate : String{
        let strPrefix = Date.localDateString(from: bookedDate, format: "EEEE, MMM d, yyyy")
        return "\(strPrefix) @ "
    }
    var strCurrDate : String{
        let strPrefix = Date.localDateString(from: bookedDate, format: "yyyy-MM-dd")
        return "\(strPrefix)"
    }
    var strSlotDate : String{
        let strSlotDate = Date.localDateString(from: bookedDate)
        return strSlotDate
    }
    
    init(dict : NSDictionary) {
        id = dict.getStringValue(key: "id")
        driverId = dict.getStringValue(key: "barber_id")
        isBooked = dict.getBooleanValue(key: "is_booked")
        bookedDate = Date.dateFromAppServerFormat(from: dict.getStringValue(key: "date"))
        
        if let slots = dict["time"] as? NSDictionary{
            self.timeSlots = TimeSlots(dict: slots)
        }
    }
}

class TimeSlots{
    var time : String

    init(dict : NSDictionary) {
        time = dict.getStringValue(key: "time")
    }
}
