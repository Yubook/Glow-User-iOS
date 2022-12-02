//
//  ChatList.swift
//  Fade
//
//  Created by Devang Lakhani  on 4/13/21.
//  Copyright © 2021 Devang Lakhani. All rights reserved.
//

import Foundation
import UIKit

class ChatList{
    var arrDrivers : [DriversOnChat] = []
    
    init(dict: NSDictionary) {
        if let driverDict = dict["barbers"] as? [NSDictionary]{
            for dictDriver in driverDict{
                let data = DriversOnChat(dict: dictDriver)
                self.arrDrivers.append(data)
            }
        }
        if let adminDict = dict["admin"] as? [NSDictionary]{
            for dictAdmin in adminDict{
                let admin = DriversOnChat(dict: dictAdmin)
                self.arrDrivers.append(admin)
            }
        }
       /* if let adminDict = dict["admin"] as? [NSDictionary]{
            for dictAdmin in adminDict{
                let data = Admin(dict: dictAdmin)
                self.arrAdmin.append(data)
            }
        }
        
        if let usersDict = dict["users"] as? [NSDictionary]{
            for dictUsers in usersDict{
                let data = UserChat(dict: dictUsers)
                self.arrUsers.append(data)
            }
        } */
    }
}
/*
class Admin{
    var id: String
    var name : String
    var imgName : String
    let lastAcive: String
    var role : String
    var unreadCount : Int
    var webProfileName : String
    let groupId : String
    
    var profileUrl : URL?{
        return URL(string: _storage+imgName)
    }
    
    var webProfileUrl : URL?{
        return URL(string: _storage+webProfileName)
    }
    
    var activeStatus: String {
        if lastAcive.isEqual(str: "1") {
            return "Active Now"
        } else {
            let strDate = Date.dateFromLocalFormat(from: lastAcive, format: "yyyy-MM-dd HH:mm:ss")
            let localDate = Date.localDateString(from: strDate, format: "h:mm a | MMM d")
            return "Last Seen at \(localDate)"
        }
    }
    
    var statusColor: UIColor {
        return lastAcive.isEqual(str: "1") ? #colorLiteral(red: 0.2745098039, green: 0.7333333333, blue: 0.2235294118, alpha: 1) : #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
    }
    
    init(dict : NSDictionary) {
        id = dict.getStringValue(key: "id")
        name = dict.getStringValue(key: "name")
        imgName = dict.getStringValue(key: "image")
        role = dict.getStringValue(key: "role")
        unreadCount = dict.getIntValue(key: "unread_count")
        webProfileName = dict.getStringValue(key: "web_profile_pic")
        groupId = dict.getStringValue(key: "group_id")
        lastAcive = dict.getStringValue(key: "last_active_time")
    }
} */

class DriversOnChat{
    var id : String
    var name : String
    var imgName : String
    let lastActive : String
    var role : String
    var unreadCount : Int
    var webProfileName : String
    let groupId: String
    var arrOrders : [ChatOrders] = []
    
    var profileUrl : URL?{
        return URL(string: _storage+imgName)
    }
    
    var webProfileUrl : URL?{
        return URL(string: _storage+webProfileName)
    }
    
    var activeStatus: String {
        if lastActive.isEqual(str: "1") {
            return "Active Now"
        } else {
          //  let strDate = Date.dateFromLocalFormat(from: lastActive, format: "yyyy-MM-dd")
           // let localDate = Date.localDateString(from: strDate, format: "h:mm a | MMM d")
            return "Last Seen at \(lastActive)"
        }
    }
    
    var statusColor: UIColor {
        return lastActive.isEqual(str: "1") ? #colorLiteral(red: 0.2745098039, green: 0.7333333333, blue: 0.2235294118, alpha: 1) : #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
    }
    
    init(dict: NSDictionary) {
        id = dict.getStringValue(key: "id")
        name = dict.getStringValue(key: "name")
        imgName = dict.getStringValue(key: "profile")
        lastActive = dict.getStringValue(key: "last_active_time")
        role = dict.getStringValue(key: "role")
        unreadCount = dict.getIntValue(key: "unread_count")
        webProfileName = dict.getStringValue(key: "web_profile_pic")
        groupId = dict.getStringValue(key: "group_id")
        if let orders = dict["order"] as? [NSDictionary]{
            for dictData in orders{
                let objData = ChatOrders(dict: dictData)
                self.arrOrders.append(objData)
            }
        }
    }
}

/*
class UserChat{
    var id : String
    var name : String
    var imgName : String
    let lastActive : String
    var role : String
    var unreadCount : Int
    var webProfileName : String
    let groupId: String
    
    var profileUrl : URL?{
        return URL(string: _storage+imgName)
    }
    
    var webProfileUrl : URL?{
        return URL(string: _storage+webProfileName)
    }
    
    var activeStatus: String {
        if lastActive.isEqual(str: "1") {
            return "Active Now"
        } else {
            let strDate = Date.dateFromLocalFormat(from: lastActive, format: "yyyy-MM-dd HH:mm:ss")
            let localDate = Date.localDateString(from: strDate, format: "h:mm a | MMM d")
            return "Last Seen at \(localDate)"
        }
    }
    
    var statusColor: UIColor {
        return lastActive.isEqual(str: "1") ? #colorLiteral(red: 0.2745098039, green: 0.7333333333, blue: 0.2235294118, alpha: 1) : #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
    }
    
    init(dict: NSDictionary) {
        id = dict.getStringValue(key: "id")
        name = dict.getStringValue(key: "name")
        imgName = dict.getStringValue(key: "image")
        lastActive = dict.getStringValue(key: "last_active_time")
        role = dict.getStringValue(key: "role")
        unreadCount = dict.getIntValue(key: "unread_count")
        webProfileName = dict.getStringValue(key: "web_profile_pic")
        groupId = dict.getStringValue(key: "group_id")
    }
}
*/

class ChatOrders{
    var orderId : String
    var barberId : String
    var discount : Int
    var amount : String
    var lat : Double
    var long : Double
    var address : String
    var isOrderCompleted : Int
    var arrServices : [Services] = []
    var arrReview : [BarberReviews] = []
    
    
    init(dict : NSDictionary) {
        orderId = dict.getStringValue(key: "order_id")
        barberId = dict.getStringValue(key: "barber_id")
        discount = dict.getIntValue(key: "discount")
        amount = dict.getStringValue(key: "amount")
        lat = dict.getDoubleValue(key: "latitude")
        long = dict.getDoubleValue(key: "longitude")
        address = dict.getStringValue(key: "address")
        isOrderCompleted = dict.getIntValue(key: "is_order_complete")
        if let arrDict = dict["service"] as? [NSDictionary]{
            for dictData in arrDict{
                let objData = Services(dict: dictData)
                self.arrServices.append(objData)
            }
        }
        if let arrReviewData = dict["review"] as? [NSDictionary]{
            for dictData in arrReviewData{
                let objData = BarberReviews(dict: dictData)
                self.arrReview.append(objData)
            }
        }
    }
}
