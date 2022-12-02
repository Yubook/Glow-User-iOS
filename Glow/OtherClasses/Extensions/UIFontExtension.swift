//  Created by iOS Development Company on 13/01/16.
//  Copyright © 2016 The App Developers. All rights reserved.
//

import UIKit

enum DuceFont: String {
    
    case sfProDisplayRegular = "SFProDisplay-Regular"
    case sfProDisplayBold = "SFProDisplay-Bold"    
    //case poppinsRegular = "Poppins-Regular"

}

extension UIFont {
    
    class func DUCEFontWith(_ name: DuceFont, size: CGFloat) -> UIFont{
        return UIFont(name: name.rawValue, size: size)!
    }
}
