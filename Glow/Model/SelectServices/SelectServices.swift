//
//  SelectServices.swift
//  Fade
//
//  Created by Devang Lakhani  on 4/12/21.
//  Copyright © 2021 Devang Lakhani. All rights reserved.
//

import Foundation
import UIKit

class SelectServices{
    var serviceName : String
    var servicePrice : String
    var serviceImgName : String
    var time : String
    var id : String
    
    var serviceImageUrl : URL?{
        return URL(string: _storage+serviceImgName)
    }
    
    init(dict : NSDictionary) {
        serviceName = dict.getStringValue(key: "name")
        servicePrice = dict.getStringValue(key: "price")
        serviceImgName = dict.getStringValue(key: "image")
        time = dict.getStringValue(key: "required_time")
        id = dict.getStringValue(key: "id")
    }
}


class Services{
    let id : String
    var name : String
    var time : String
    var dictCategory : Category?
    var dictSubCategory : SubCategory?
    var isSelected = false
    var price : String
    var serviceImg : String
    var slotTime : String
    var slotDate : Date?
    var serviceName : String
    
    var strDate : String{
        let strPrefix = Date.localDateString(from: slotDate, format: "EEEE, MMM d, yyyy")
        return "\(strPrefix) @ "
    }
    
    var imgUrl : URL?{
        return URL(string: _storage+serviceImg)
    }
    
    
    var strChatDate : String{
        let stringDate = Date.localDateString(from: slotDate,format: "yyyy-MM-dd")
        return stringDate
    }
    var startChatTime : String{
        let subStr = slotTime.prefix(5)
        let time = subStr.prefix(2)
        var otherTime = String(time)
        if otherTime.last! == ":"{
            otherTime.removeLast()
            let strTime = Int(otherTime)
            let firstTime = strTime! - 1
            let end = subStr.suffix(3)
            return strDate + " " + "0\(firstTime)"+"\(end)"
        }else{
            let strTime = Int(otherTime)
            let firstTime = strTime! - 1
            let end = subStr.suffix(3)
            return strDate + " " + "\(firstTime)"+"\(end)"
        }
    }
    
    var chatEndTime : String{
        let subStr = slotTime.suffix(5)
        return strChatDate + " " + subStr
    }
    
    func getTimeAndDate() -> String{
        let dateFormatter : DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        let date = Date()
        let dateString = dateFormatter.string(from: date)
        return dateString
    }
    
    init(dict: NSDictionary) {
        id = dict.getStringValue(key: "id")
        name = dict.getStringValue(key: "name")
        serviceName = dict.getStringValue(key: "service_name")
        time = dict.getStringValue(key: "time")
        price = dict.getStringValue(key: "price")
        serviceImg = dict.getStringValue(key: "image")
        if let catDict = dict["category"] as? NSDictionary{
            let objData = Category(dict: catDict)
            self.dictCategory = objData
        }
        if let subCatDict = dict["subcategory"] as? NSDictionary{
            let objData = SubCategory(dict: subCatDict)
            self.dictSubCategory = objData
        }
        slotTime = dict.getStringValue(key: "slot_time")
        slotDate = Date.dateFromAppServerFormat(from: dict.getStringValue(key: "slot_date"))
    }
}

class Category{
    let id : String
    var name : String
    var isActive : Bool
    
    init(dict: NSDictionary) {
        id = dict.getStringValue(key: "id")
        name = dict.getStringValue(key: "name")
        isActive = dict.getBooleanValue(key: "is_active")
    }
}

class SubCategory{
    let id : String
    var name : String
    var isActive : Bool
    var dictCatName : CatName?
    
    init(dict: NSDictionary) {
        id = dict.getStringValue(key: "id")
        name = dict.getStringValue(key: "name")
        isActive = dict.getBooleanValue(key: "is_active")
        
        if let catNameDict = dict["category_name"] as? NSDictionary{
            let objData = CatName(dict: catNameDict)
            self.dictCatName = objData
        }
    }
}

class CatName{
    let id : String
    var name : String
    var isActive : Bool
    
    init(dict: NSDictionary) {
        id = dict.getStringValue(key: "id")
        name = dict.getStringValue(key: "name")
        isActive = dict.getBooleanValue(key: "is_active")
    }
}
