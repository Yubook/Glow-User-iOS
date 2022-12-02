//
//  BarberDetails.swift
//  Fade
//
//  Created by Chirag Patel on 28/09/21.
//  Copyright © 2021 Devang Lakhani. All rights reserved.
//

import Foundation

enum EnumDetailsType{
    case Portfolio
    case Pricing
    case Review
    case Terms
}

class BarberDetailsMenu{
    var title: String
    var id : String
    var isSelected : Bool = false
    
    init(title: String, id: String) {
        self.title = title
        self.id = id
    }
}
