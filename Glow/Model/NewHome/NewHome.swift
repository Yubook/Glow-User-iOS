//
//  NewHome.swift
//  Fade
//
//  Created by Chirag Patel on 27/09/21.
//  Copyright © 2021 Devang Lakhani. All rights reserved.
//

import Foundation
import UIKit


enum EnumNewHome{
    case service
    case nearestBarber
    
    
    var cellId : String{
        switch self{
        case .service:
            return "servicesCell"
        case .nearestBarber:
            return "nearBarberCell"
        }
    }
    
    var cellHeight : CGFloat{
        switch self{
        case .service:
            return 90.widthRatio
        case .nearestBarber:
            return UITableView.automaticDimension
        }
    }
    
    var sectionTitle : String{
        switch self{
        case .service:
            return "Services"
        case .nearestBarber:
            return "Barbers near you"
        }
    }
    
    var collCellId : String{
        switch self{
        case .service:
            return "newCollCell"
        default : return ""
        }
    }
}
