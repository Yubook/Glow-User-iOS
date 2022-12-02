//
//  TermsPolicy.swift
//  Fade
//
//  Created by Devang Lakhani  on 6/30/21.
//  Copyright © 2021 Devang Lakhani. All rights reserved.
//

import Foundation
import UIKit

class TermsPolicy{
    var selection : String
    var name : String
    var description : String
    
    
    init(dict: NSDictionary) {
        selection = dict.getStringValue(key: "selection")
        name = dict.getStringValue(key: "terms_name")
        description = dict.getStringValue(key: "terms_description")
    }
}
