//
//  AddReview.swift
//  Fade
//
//  Created by Devang Lakhani  on 4/13/21.
//  Copyright © 2021 Devang Lakhani. All rights reserved.
//

import Foundation
import UIKit

enum EnumAddReview{
    case ratingCell
    case txtViewCell
    case addPhotoCell
    case btnCell
    
    
    var cellId : String{
        switch self{
        case .ratingCell:
            return "ratingCell"
        case .txtViewCell:
            return "writeCell"
        case .addPhotoCell:
            return "addPictureCell"
        case .btnCell:
            return "btnCell"
        }
    }
    
    var cellHeight : CGFloat{
        switch self{
        case .ratingCell:
            return 50.widthRatio
        case .txtViewCell:
            return 150.widthRatio
        case .addPhotoCell:
            return 140.widthRatio
        case .btnCell:
            return 70.widthRatio
        }
    }
    
    var sectionTitle : String{
        switch self{
        case .ratingCell:
            return "Ratings"
        case .txtViewCell:
            return "Enter Your Comment"
        case .addPhotoCell:
            return "Add Photos (Optional)"
        default : return ""
        }
    }
}


class AddReview{
    var fromId : String = ""
    var toId : String = ""
    var rating : String = ""
    var message : String = ""
    
    func paramDict() -> [String : Any]{
        var dict : [String : Any] = [:]
        dict["from_id"] = fromId
        dict["to_id"] = toId
        dict["rating"] = rating
        dict["message"] = message
        return dict
    }
    
    func validateData() -> (isValid : Bool, error: String){
        var res = (isValid : true, error : "")
        
        if String.validateStringValue(str: rating){
            res.isValid = false
            res.error = kSelectStar
        }else if String.validateStringValue(str: message){
            res.isValid = false
            res.error = kEnterMessage
        }
        
        return res
    }
}

class Reviews{
    var fromId : String
    var toId : String
    var rating : String
    var message : String
    var users : UsersReview?
    var drivers : DriversData?
    var arrimgList : [ImageList] = []
    
    init(dict: NSDictionary) {
        fromId = dict.getStringValue(key: "from_id")
        toId = dict.getStringValue(key: "to_id")
        rating = dict.getStringValue(key: "rating")
        message = dict.getStringValue(key: "message")
        if let userData = dict["from_id_user"] as? NSDictionary{
            self.users = UsersReview(dict: userData)
        }
        if let userData = dict["to_id_user"] as? NSDictionary{
            self.drivers = DriversData(dict: userData)
        }
        if let imgData = dict["image"] as? [NSDictionary]{
            for imgs in imgData{
                let dictData = ImageList(dict: imgs)
                self.arrimgList.append(dictData)
            }
        }
    }
}

class ImageList{
    var imgName : String
    var imgUrl : URL?{
        return URL(string: _storage+imgName)
    }
    
    init(dict: NSDictionary) {
        imgName = dict.getStringValue(key: "image")
    }
}

class UsersReview{
    var name : String
    var imgName : String
    
    var profileUrl : URL?{
        return URL(string: _storage+imgName)
    }
    
    init(dict: NSDictionary) {
        name = dict.getStringValue(key: "name")
        imgName = dict.getStringValue(key: "image")
    }
}

class DriversData{
    var id : String
    
    init(dict : NSDictionary) {
        id = dict.getStringValue(key: "id")
    }
}
