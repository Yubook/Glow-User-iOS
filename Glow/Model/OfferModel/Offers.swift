//
//  Offers.swift
//  Fade
//
//  Created by Devang Lakhani  on 4/10/21.
//  Copyright © 2021 Devang Lakhani. All rights reserved.
//

import Foundation
import UIKit

class Offers{
    var price : String
    var description : String
    var offerImage : String
    
    var setImage : UIImage?{
        return UIImage(named: offerImage)
    }
    
    init(price : String, desc: String, imgName: String) {
        self.price = price
        self.description = desc
        self.offerImage = imgName
    }
}
