//
//  RationExtention.swift
//  delf
//
//  Created by Yudiz on 1/9/18.
//  Copyright © 2018 Yudiz. All rights reserved.
//

import Foundation
import UIKit

/*---------------------------------------------------
 Ratio
 ---------------------------------------------------*/
let _heightRatio : CGFloat = {
    let ratio = _screenSize.height/812
    return ratio
}()

let _widthRatio : CGFloat = {
    let ratio = _screenSize.width/375
    return ratio
}()


extension CGFloat {

    var widthRatio: CGFloat{
        return self * _widthRatio
    }

    var heightRatio: CGFloat{
        return self * _heightRatio
    }
}

extension Int {
    
    var widthRatio: CGFloat{
        return CGFloat(self) * _widthRatio
    }
    
    var heightRatio: CGFloat{
        return CGFloat(self) * _heightRatio
    }
}

extension Float {
    
    var widthRatio: CGFloat{
        return CGFloat(self) * _widthRatio
    }
    
    var heightRatio: CGFloat{
        return CGFloat(self) * _heightRatio
    }
}

extension Double {
    
    var widthRatio: CGFloat{
        return CGFloat(self) * _widthRatio
    }
    
    var heightRatio: CGFloat{
        return CGFloat(self) * _heightRatio
    }
}

