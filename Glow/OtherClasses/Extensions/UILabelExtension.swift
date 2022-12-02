//
//  UILabelExtension.swift
//  DeepContract
//
//  Created by Yudiz Solutions on 20/07/18.
//  Copyright © 2018 Yudiz. All rights reserved.
//

import Foundation
import UIKit

extension UILabel {
    
    func setLineSpacing(lineSpacing: CGFloat = 0.0, lineHeightMultiple: CGFloat = 0.0) {
        
        guard let labelText = self.text else { return }
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.lineHeightMultiple = lineHeightMultiple
        paragraphStyle.alignment = .center
        
        let attributedString:NSMutableAttributedString
        if let labelattributedText = self.attributedText {
            attributedString = NSMutableAttributedString(attributedString: labelattributedText)
        } else {
            attributedString = NSMutableAttributedString(string: labelText)
        }
        
//        paragraphStyle.minimumLineHeight = font.pointSize
//        paragraphStyle.maximumLineHeight = 50//font.pointSize + lineSpacing

        // Line spacing attribute
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        self.attributedText = attributedString
    }
    
    
    func addDropShadow(_ xOffset: CGFloat = 0, yOffset: CGFloat = 0.5, shadowColor: UIColor, shadowBlurRadius: CGFloat = 1,opacity:Float = 1.0) {
        self.layer.shadowColor = shadowColor.cgColor
        self.layer.shadowRadius = shadowBlurRadius
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = CGSize(width: xOffset, height: yOffset)
        self.layer.masksToBounds = false
    }

}


