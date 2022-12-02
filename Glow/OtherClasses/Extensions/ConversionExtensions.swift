//  Created by iOS Development Company on 01/04/16.
//  Copyright © 2016 iOS Development Company All rights reserved.
//

import Foundation
import UIKit

// MARK: - Conversion
extension Double{
    func getFormattedValue(str: String)->String?{
        return String(format: "%.\(str)f", self)
    }
    
    var intValue: Int?{
        let val = Int(self)
        return val
    }
}

extension CGFloat{
    
    var intValue: Int?{
        let val = Int(self)
        return val
    }
    
    func getFormattedValue(str: String)->String?{
        return String(format: "%.\(str)f", self)
    }
}

extension String {
    var doubleValue: Double? {
        return Double(self)
    }
    var floatValue: Float? {
        return Float(self)
    }
    var integerValue: Int? {
        return Int(self)
    }
}
