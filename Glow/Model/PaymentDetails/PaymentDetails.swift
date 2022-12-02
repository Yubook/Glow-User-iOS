//
//  PaymentDetails.swift
//  Fade
//
//  Created by Devang Lakhani  on 5/12/21.
//  Copyright © 2021 Devang Lakhani. All rights reserved.
//

import Foundation
import UIKit

enum EnumPaymentDetails{
    case sectionCell
    case txtCardCell
    case doubleTextField
    case radioCell
    case walletCell
    case descCell
    case termsCell
    case btnCell
    
    var cellId : String{
        switch self{
        case .sectionCell:
            return "sectionCell"
        case .txtCardCell:
            return "txtCardDetailCell"
        case .descCell:
            return "descCell"
        case .termsCell:
            return "termsCell"
        case .btnCell:
            return "btnCell"
        case .doubleTextField:
            return "txtFieldDateCvvCell"
        case .radioCell:
            return "radioCell"
        case .walletCell:
            return "discountCell"
        }
    }
    
    var cellHeight : CGFloat{
        switch self{
        case .sectionCell:
            return 44.widthRatio
        case .txtCardCell,.termsCell,.btnCell,.doubleTextField:
            return 65.widthRatio
        case .descCell:
            return 30.widthRatio
        case .radioCell,.walletCell:
            return 50.widthRatio
        }
    }
}


struct PaymentDetailsModel{
    var placeholderName : String = ""
    var placeHolderOne : String = ""
    var keyBoardType : UIKeyboardType = .default
    var keyReturnType : UIReturnKeyType = .default
    var value : String = ""
    var str : String = ""
    var value2 : String = ""
    var webKeyName : String = ""
    var webKeyName1 : String = ""
    var webKeyName2 : String = ""
    var cellType : EnumPaymentDetails = .sectionCell
}

class PaymentDetails{
    var arrData : [PaymentDetailsModel] = []
    
    func prepareData(){
        var f0 = PaymentDetailsModel()
        f0.cellType = .sectionCell
        self.arrData.append(f0)
        
        var f1 = PaymentDetailsModel()
        f1.placeholderName = "Name on Card"
        f1.webKeyName = "card[name]"
        f1.keyBoardType = .default
        f1.keyReturnType = .next
        f1.cellType = .txtCardCell
        self.arrData.append(f1)
        
        var f6 = PaymentDetailsModel()
        f6.placeholderName = "Card number"
        f6.webKeyName = "card[number]"
        f6.keyBoardType = .numberPad
        f6.keyReturnType = .done
        f6.cellType = .txtCardCell
        self.arrData.append(f6)
        
        var f2 = PaymentDetailsModel()
        f2.placeholderName = "MM/YY Expiration Date"
        f2.placeHolderOne = "CVV"
        f2.keyBoardType = .numberPad
        f2.keyReturnType = .done
        f2.webKeyName = "card[exp_month]"
        f2.webKeyName2 = "card[exp_year]"
        f2.webKeyName1 = "card[cvc]"
        f2.cellType = .doubleTextField
        self.arrData.append(f2)
        
        /*var f7 = PaymentDetailsModel()
        f7.cellType = .radioCell
        self.arrData.append(f7)*/
        
        var f8 = PaymentDetailsModel()
        f8.cellType = .walletCell
        self.arrData.append(f8)
        
        var f3 = PaymentDetailsModel()
        f3.cellType = .descCell
        self.arrData.append(f3)
        
        var f4 = PaymentDetailsModel()
        f4.cellType = .termsCell
        self.arrData.append(f4)
        
        var f5 = PaymentDetailsModel()
        f5.cellType = .btnCell
        self.arrData.append(f5)
    }
    
    func prepareCardDict() -> [String: Any] {
        var dict: [String: Any] = [:]
        arrData.forEach { (objField) in
            switch objField.cellType{
            case .txtCardCell:
                dict[objField.webKeyName] = objField.value
            case .doubleTextField:
                dict[objField.webKeyName] = objField.value
                dict[objField.webKeyName2] = objField.value2
                dict[objField.webKeyName1] = objField.str
            default: break
            }
        }
        return dict
    }
    
    func isValidData() -> (isValid: Bool, error: String){
        var result = (isValid : true, error: "")
        for data in arrData {
            if String.validateStringValue(str: arrData[1].value){
                result.isValid = false
                result.error = "Enter Valid Name"
                return result
            }else if arrData[2].value == ""{
                result.isValid = false
                result.error = "Enter Valid Card Details"
                return result
            }
            if data.cellType == .doubleTextField {
                if arrData[3].value == ""{
                    result.isValid = false
                    result.error = "Enter Valid Month"
                    return result
                }else if arrData[3].value.count < 2{
                    result.isValid = false
                    result.error = "Enter Valid Month"
                    return result
                }else if arrData[3].value > "12"{
                    result.isValid = false
                    result.error = "Enter Valid Month"
                    return result
                }else if arrData[3].value2 == ""{
                    result.isValid = false
                    result.error = "Enter Valid Year"
                    return result
                }else if arrData[3].value2.count < 2{
                    result.isValid = false
                    result.error = "Enter Valid Year"
                    return result
                }
                else if arrData[3].str == ""{
                    result.isValid = false
                    result.error = "Enter Valid CVV code"
                    return result
                }else if arrData[3].str.count < 3{
                    result.isValid = false
                    result.error = "Enter Valid CVV code"
                    return result
                }
            }
        }
        return result
    }
}
