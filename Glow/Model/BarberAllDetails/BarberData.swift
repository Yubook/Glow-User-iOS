//
//  BarberData.swift
//  Fade
//
//  Created by Chirag Patel on 29/09/21.
//  Copyright © 2021 Devang Lakhani. All rights reserved.
//

import Foundation
import UIKit

enum EnumBarberData{
    case serviceCell
    case addressCell
    case galleryCell
    case reviewCell
    
    var cellId: String{
        switch self{
        case .serviceCell:
            return "serviceCell"
        case .addressCell:
            return "addressCell"
        case .galleryCell:
            return "gallaryCell"
        case .reviewCell :
            return "reviewCell"
        }
    }
    
    var cellHeight : CGFloat{
        switch self{
        case .galleryCell:
            return 90.widthRatio
        case .reviewCell,.addressCell,.serviceCell :
            return UITableView.automaticDimension
        }
    }
}

struct BarberDetailsModel{
    var cellType : EnumBarberData = .serviceCell
    var reviewType = ""
    var reviewValue = 0
    var reviewDisplayValue = 0.0
}

class BarberDetailsData{
    var arrData : [BarberDetailsModel] = []
    
    func prepareData(){
        var f0 = BarberDetailsModel()
        f0.cellType  = .serviceCell
        self.arrData.append(f0)
        
        var f1 = BarberDetailsModel()
        f1.cellType  = .addressCell
        self.arrData.append(f1)
        
        var f2 = BarberDetailsModel()
        f2.cellType  = .galleryCell
        self.arrData.append(f2)
        
        var f3 = BarberDetailsModel()
        f3.cellType  = .reviewCell
        f3.reviewType = "Service"
        
        self.arrData.append(f3)
        
        var f4 = BarberDetailsModel()
        f4.cellType  = .reviewCell
        f4.reviewType = "Hygiene"
        self.arrData.append(f4)
        
        var f5 = BarberDetailsModel()
        f5.cellType  = .reviewCell
        f5.reviewType = "Value"
        self.arrData.append(f5)
    }
}


class BarberProfileDetails{
    var barberId : String
    var mobile : String
    var name : String
    var profile : String
    var gender : String
    var avgRating : String
    var totalReviews : String
    var fiveStar : String
    var fourStar : String
    var threeStar : String
    var twoStar : String
    var oneStar : String
    var arrBarberServices : [BarberService] = []
    var dictTerms : Terms?
   // var arrPortfolio : [Portfolio] = []
    var arrReviews : [BarberReviews] = []
    var chat : Bool
    var chatId : String
    
    init(dict: NSDictionary) {
        barberId = dict.getStringValue(key: "barber_id")
        mobile = dict.getStringValue(key: "mobile")
        name = dict.getStringValue(key: "name")
        profile = dict.getStringValue(key: "profile")
        gender = dict.getStringValue(key: "gender")
        avgRating = dict.getStringValue(key: "average_rating")
        totalReviews = dict.getStringValue(key: "total_reviews")
        fiveStar = dict.getStringValue(key: "fivestar")
        fourStar = dict.getStringValue(key: "fourstar")
        threeStar = dict.getStringValue(key: "threestar")
        twoStar = dict.getStringValue(key: "twostar")
        oneStar = dict.getStringValue(key: "onestar")
        chat = dict.getBooleanValue(key: "chat")
        chatId = dict.getStringValue(key: "chat_group_id")
        if let arrServices = dict["services"] as? [NSDictionary]{
            for dictService in arrServices{
                let objData = BarberService(dict: dictService)
                self.arrBarberServices.append(objData)
            }
        }
        if let terms = dict["policy_and_term"] as? NSDictionary{
            self.dictTerms = Terms(dict: terms)
        }
//        if let arrPort = dict["portfolios"] as? [NSDictionary]{
//            for dictPort in arrPort{
//                let objData = Portfolio(dict: dictPort)
//                self.arrPortfolio.append(objData)
//            }
//        }
        if let arrReview = dict["reviews"] as? [NSDictionary]{
            for dictReview in arrReview{
                let objData = BarberReviews(dict: dictReview)
                self.arrReviews.append(objData)
            }
        }
    }
}

class Terms{
    let id : String
    var type : String
    var content : String
    
    init(dict: NSDictionary) {
        id = dict.getStringValue(key: "id")
        type = dict.getStringValue(key: "type")
        content = dict.getStringValue(key: "content")
    }
}

class Portfolio{
    let id : String
    var img : String
    
    var imgReview : URL?{
        return URL(string: _storage+img)
    }
    
    init(dict: NSDictionary) {
        id = dict.getStringValue(key: "id")
        img = dict.getStringValue(key: "image")
    }
}

class BarberReviews{
    var id : String
    var orderId : String
    var userId : String
    var barberId : String
    var service : String
    var hygine : String
    var value : String
    var arrPortfoilio : [Portfolio] = []
    
    init(dict: NSDictionary) {
        id = dict.getStringValue(key: "id")
        orderId = dict.getStringValue(key: "order_id")
        userId = dict.getStringValue(key: "user_id")
        barberId = dict.getStringValue(key: "barber_id")
        service = dict.getStringValue(key: "service")
        hygine = dict.getStringValue(key: "hygiene")
        value = dict.getStringValue(key: "value")
        
        if let arrPhoto = dict["review_images"] as? [NSDictionary]{
            for dictPhoto in arrPhoto{
                let objData = Portfolio(dict: dictPhoto)
                self.arrPortfoilio.append(objData)
            }
        }
    }
}
