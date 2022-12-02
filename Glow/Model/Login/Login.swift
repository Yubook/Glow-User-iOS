//
//  Login.swift
//  Fade
//
//  Created by Devang Lakhani  on 4/8/21.
//  Copyright © 2021 Devang Lakhani. All rights reserved.
//

import Foundation
import UIKit

enum EnumLogin{
    case backScreenCell
    case txtFieldCell
    case instructionCell
    case btnCell
    
    var cellId: String{
        switch self{
        case .backScreenCell:
            return "backScreenCell"
        case .instructionCell:
            return "instructionCell"
        case .txtFieldCell:
            return "txtFieldCell"
        case .btnCell:
            return "btnCell"
        }
    }
    
    var cellHeight : CGFloat{
        switch self{
        case .backScreenCell:
            return 300.widthRatio
        case .instructionCell:
            return UITableView.automaticDimension
        case .txtFieldCell:
            return 75.widthRatio
        case .btnCell:
            return 85.widthRatio
        }
    }
}


struct LoginModel {
    var value : String = ""
    var cellType : EnumLogin = .backScreenCell
    var placeHolderTitle : String = ""
    var keyboardType : UIKeyboardType = .default
    var keyboardAppearance : UIKeyboardAppearance = .default
}

class Login{
    var arrData : [LoginModel] = []
    
    func prepareData(){
        var f1 = LoginModel()
        f1.cellType = .backScreenCell
        self.arrData.append(f1)
        
        
        var f2 = LoginModel()
        f2.placeHolderTitle = "Mobile Number"
        f2.keyboardType = .phonePad
        f2.keyboardAppearance = .dark
        f2.cellType = .txtFieldCell
        self.arrData.append(f2)
        
        var f3 = LoginModel()
        f3.cellType = .instructionCell
        self.arrData.append(f3)
        
        var f4 = LoginModel()
        f4.cellType = .btnCell
        self.arrData.append(f4)
    }
    
    func validatetData() -> (isValid: Bool, error: String) {
        var result = (isValid: true, error: "")
        if String.validateStringValue(str: arrData[1].value) {
            result.isValid = false
            result.error = kEnterMobile
        } else if !arrData[1].value.validateContact() {
            result.isValid = false
            result.error = kMobileInvalid
        }
        return result
    }
}



enum EnumLoginEmail{
    case backScreenCell
    case txtEmailFieldCell
    case instructionCell
    case btnCell
    
    var cellId: String{
        switch self{
        case .backScreenCell:
            return "backScreenCell"
        case .instructionCell:
            return "instructionCell"
        case .txtEmailFieldCell:
            return "txtFieldCell"
        case .btnCell:
            return "btnCell"
        }
    }
    
    var cellHeight : CGFloat{
        switch self{
        case .backScreenCell:
            return 350.heightRatio
        case .instructionCell:
            return UITableView.automaticDimension
        case .txtEmailFieldCell:
            return 75.widthRatio
        case .btnCell:
            return 70.widthRatio
        }
    }
}


struct LoginEmailModel {
    var value : String = ""
    var cellType : EnumLoginEmail = .backScreenCell
    var placeHolderTitle : String = ""
    var keyboardType : UIKeyboardType = .default
    var keyboardAppearance : UIKeyboardAppearance = .default
}

class LoginEmail{
    var arrData : [LoginEmailModel] = []
    
    func prepareData(){
        var f1 = LoginEmailModel()
        f1.cellType = .backScreenCell
        self.arrData.append(f1)
        
        var f2 = LoginEmailModel()
        f2.placeHolderTitle = "Email ID"
        f2.keyboardType = .emailAddress
        f2.keyboardAppearance = .light
        f2.cellType = .txtEmailFieldCell
        self.arrData.append(f2)
        
        var f3 = LoginEmailModel()
        f3.cellType = .instructionCell
        self.arrData.append(f3)
        
        var f4 = LoginEmailModel()
        f4.cellType = .btnCell
        self.arrData.append(f4)
    }
    
    func validatetData() -> (isValid: Bool, error: String) {
        var result = (isValid: true, error: "")
        if String.validateStringValue(str: arrData[1].value) {
            result.isValid = false
            result.error = kEnterEmail
        } else if !arrData[1].value.isValidEmailAddress() {
            result.isValid = false
            result.error = kInvalidEmail
        }
        return result
    }
}
