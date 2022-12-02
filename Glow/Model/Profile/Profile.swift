//
//  Profile.swift
//  Fade
//
//  Created by Devang Lakhani  on 4/14/21.
//  Copyright © 2021 Devang Lakhani. All rights reserved.
//

import Foundation
import UIKit

class ProfileDetails{
    var iconName : String
    var featuresName: String
    
    var setIcon : UIImage?{
        return UIImage(named: iconName)
    }
    
    init(iconName: String, featureName : String) {
        self.iconName = iconName
        self.featuresName = featureName
    }
}
