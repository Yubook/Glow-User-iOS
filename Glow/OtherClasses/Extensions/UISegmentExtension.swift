//
//  UISegmentExtension.swift
//  DUCE
//
//  Created by Devang on 1/29/21.
//  Copyright © 2021 Devang Lakhani. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class DesignableSegmentControl: UISegmentedControl{
}
extension UISegmentedControl
{
    func defaultConfiguration(font: UIFont = UIFont.systemFont(ofSize: 12), color: UIColor = UIColor.white)
    {
        let defaultAttributes = [
            NSAttributedString.Key.font: font,
            NSAttributedString.Key.foregroundColor: color
        ]
        setTitleTextAttributes(defaultAttributes, for: .normal)
    }

    func selectedConfiguration(font: UIFont = UIFont.boldSystemFont(ofSize: 12), color: UIColor = UIColor.red)
    {
        let selectedAttributes = [
            NSAttributedString.Key.font: font,
            NSAttributedString.Key.foregroundColor: color
        ]
        setTitleTextAttributes(selectedAttributes, for: .selected)
    }
    
    @IBInspectable
    var textColor: UIColor{
        get {
            return self.textColor
        }
        set {
            let unselectedAttributes = [NSAttributedString.Key.foregroundColor: newValue,
                                        NSAttributedString.Key.font:  UIFont(name: "OpenSans-Regular", size: 14)]
            self.setTitleTextAttributes(unselectedAttributes as [NSAttributedString.Key : Any], for: .normal)
            self.setTitleTextAttributes(unselectedAttributes as [NSAttributedString.Key : Any], for: .selected)
        }
    }
}
