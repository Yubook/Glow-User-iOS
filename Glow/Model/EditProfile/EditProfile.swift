//
//  EditProfile.swift
//  Fade
//
//  Created by Devang Lakhani  on 4/14/21.
//  Copyright © 2021 Devang Lakhani. All rights reserved.
//

import Foundation
import UIKit

enum EnumEditProfile{
    case textFieldCell
    case phoneCell
    case locationCell
    case btnCell
    
    var cellId: String{
        switch self{
        case .textFieldCell:
            return "txtFieldCell"
        case .phoneCell:
            return "phoneCell"
        case .locationCell:
            return "locationCell"
        case .btnCell:
            return "btnCell"
        }
    }
    
    var cellHeight : CGFloat{
        switch self{
        case .textFieldCell,.locationCell:
            return 75.widthRatio
        case .phoneCell:
            return 90.widthRatio
        case .btnCell:
            return 60.widthRatio
        }
    }
}

struct EditProfileModel{
    var placeHolderTitle : String = ""
    var keyboardType : UIKeyboardType = .default
    var returnKeyType : UIReturnKeyType = .default
    var value : String = ""
    var webKeyName : String = ""
    var img : UIImage!
    var cellType : EnumEditProfile = .textFieldCell
    var profileImage : UIImage!
}

class EditProfile{
    var arrEditProfileData : [EditProfileModel] = []
    
    func prepareData(){
        var f0 = EditProfileModel()
        if _user != nil{
            f0.value = _user.name
        }
        f0.placeHolderTitle = "User Name"
        f0.img = UIImage(named: "ic_user_left")
        f0.keyboardType = .default
        f0.returnKeyType = .next
        f0.cellType = .textFieldCell
        self.arrEditProfileData.append(f0)
        
        var f1 = EditProfileModel()
        if _user != nil{
            f1.value = _user.email
        }
        f1.placeHolderTitle = "Email"
        f1.img = UIImage(named: "ic_email_left")
        f1.keyboardType = .emailAddress
        f1.returnKeyType = .done
        f1.cellType = .textFieldCell
        self.arrEditProfileData.append(f1)

        
        var f3 = EditProfileModel()
        f3.cellType = .phoneCell
        f1.keyboardType = .phonePad
        self.arrEditProfileData.append(f3)
        
        var f4 = EditProfileModel()
        f4.cellType = .locationCell
        self.arrEditProfileData.append(f4)
        
        var f5 = EditProfileModel()
        f5.cellType = .btnCell
        self.arrEditProfileData.append(f5)
    }
    
    func validateData() -> (isValid: Bool, error: String){
        var result = (isValid: true, error: "")
        
        if String.validateStringValue(str: arrEditProfileData[0].value){
            result.isValid = false
            result.error = kEnterUsername
        }else if String.validateStringValue(str: arrEditProfileData[1].value){
            result.isValid = false
            result.error = kEnterEmail
        }else if !arrEditProfileData[1].value.isValidEmailAddress(){
            result.isValid = false
            result.error = kInvalidEmail
        }
        
        return result
    }
}
