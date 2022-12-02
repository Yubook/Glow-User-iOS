//
//  ChangeLocation.swift
//  Fade
//
//  Created by Chirag Patel on 29/09/21.
//  Copyright © 2021 Devang Lakhani. All rights reserved.
//

import Foundation
import UIKit

class ChangeLocation{
    var title : String
    var img : UIImage?
    
    init(title: String,img: UIImage?) {
        self.title = title
        self.img = img
    }
}

enum EnumManuallyLocation{
    case textFieldCell
    
    var cellId : String{
        switch self{
        case .textFieldCell:
            return "txtFieldCell"
        }
    }
    
    var cellHeight : CGFloat{
        switch self{
        case .textFieldCell:
            return UITableView.automaticDimension
        }
    }
}

struct ManuallyLocModel{
    var sectionTitle : String = ""
    var keyBoardType : UIKeyboardType = .default
    var returnKeyType : UIReturnKeyType = .default
    var cellType : EnumManuallyLocation = .textFieldCell
    var value = ""
}

class ManuallyLocation{
    var arrData : [ManuallyLocModel] = []
    
    func prepareData(){
        var f1 = ManuallyLocModel()
        f1.sectionTitle = "Street address & number"
        f1.keyBoardType = .default
        f1.returnKeyType = .next
        self.arrData.append(f1)
        
        var f2 = ManuallyLocModel()
        f2.sectionTitle = "House / Apartment no. (optional)"
        f2.keyBoardType = .default
        f2.returnKeyType = .next
        self.arrData.append(f2)
        
        var f3 = ManuallyLocModel()
        f3.sectionTitle = "City"
        f3.keyBoardType = .default
        f3.returnKeyType = .next
        self.arrData.append(f3)
        
        var f4 = ManuallyLocModel()
        f4.sectionTitle = "Post Code"
        f4.keyBoardType = .namePhonePad
        f4.returnKeyType = .next
        self.arrData.append(f4)
        
        var f5 = ManuallyLocModel()
        f5.sectionTitle = "Country"
        f5.keyBoardType = .default
        f5.returnKeyType = .done
        self.arrData.append(f5)
    }
    
    func validateData() -> (isValid: Bool, err: String){
        var result = (isValid: true, err: "")
        if String.validateStringValue(str: arrData[0].value){
            result.isValid = false
            result.err = "Enter Street address & number"
        }else if String.validateStringValue(str: arrData[2].value){
            result.isValid = false
            result.err = "Enter City"
        }else if String.validateStringValue(str: arrData[3].value){
            result.isValid = false
            result.err = "Enter Post Code"
        }else if String.validateStringValue(str: arrData[4].value){
            result.isValid = false
            result.err = "Enter Country"
        }
        return result
    }
}
