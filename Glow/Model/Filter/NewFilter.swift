//
//  NewFilter.swift
//  Fade
//
//  Created by Chirag Patel on 13/11/21.
//  Copyright © 2021 Devang Lakhani. All rights reserved.
//

import Foundation

class FilterNew{
    var name : String
    var id : String
    var isSelected = false
    
    init(str: String, id: String) {
        self.name = str
        self.id = id
    }
}
