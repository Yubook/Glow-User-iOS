//
//  Otp.swift
//  Fade
//
//  Created by Devang Lakhani  on 4/7/21.
//  Copyright © 2021 Devang Lakhani. All rights reserved.
//

import Foundation
import UIKit

enum EnumOtp{
    case instructionCell
    case otpCell
    case timerCell
    case resendCell
    
    
    var cellId: String{
        switch self{
        case .instructionCell:
            return "instructionCell"
        case .otpCell:
            return "otpnumberCell"
        case .timerCell:
            return "timerCell"
        case .resendCell:
            return "resendCell"
        }
    }
    
    var cellHeight: CGFloat{
        switch self{
        case .instructionCell:
            return 44.widthRatio
        case .otpCell:
            return 96.widthRatio
        case .timerCell:
            return 40.widthRatio
        case .resendCell:
            return 90.widthRatio
        }
    }
}
