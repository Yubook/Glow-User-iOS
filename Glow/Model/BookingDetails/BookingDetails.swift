//
//  BookingDetails.swift
//  Fade
//
//  Created by Devang Lakhani  on 4/13/21.
//  Copyright © 2021 Devang Lakhani. All rights reserved.
//

import Foundation
import UIKit

class BookingDetails{
    var userIconName : String
    var userName : String
    var serviceType : String
    var totalReview: String
    var bookedService : String
    var totalAmount : Double
    var bookingDate : String
    var bookingTime : String
    
    var setImage : UIImage?{
        return UIImage(named: userIconName)
    }
    
    init(iconName : String, name : String, type : String, totalReview: String, bookedService: String, totalAmount : Double, bookingDate : String, bookTime: String) {
        self.userIconName = iconName
        self.userName = name
        self.serviceType = type
        self.totalReview = totalReview
        self.bookedService = bookedService
        self.totalAmount = totalAmount
        self.bookingDate = bookingDate
        self.bookingTime = bookTime
    }
}
