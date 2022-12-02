//
//  UiTextFieldExtension.swift
//  DUCE
//
//  Created by Devang on 1/27/21.
//  Copyright © 2021 Devang Lakhani. All rights reserved.
//

import Foundation
import UIKit

class JTextField: UITextField {
    
    @IBInspectable var leftImage: UIImage? {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var isRationAppliedOnText: Bool = false{
        didSet{
            if isRationAppliedOnText {
                font = font?.withSize((font?.pointSize)! * _widthRatio)
            }
        }
    }
    @IBInspectable var isRatioAppliedOnSize: Bool = false
    
    @IBInspectable var cornerRadious: CGFloat = 0{
        didSet{
            if cornerRadious == 0{
                layer.cornerRadius = isRatioAppliedOnSize ? (self.frame.height * _widthRatio) / 2 : self.frame.height / 2
            }else{
                layer.cornerRadius = isRatioAppliedOnSize ? cornerRadious * _widthRatio : cornerRadious
            }
        }
    }
    
    @IBInspectable public var borderWidth: CGFloat {
        get { return self.layer.borderWidth }
        set { self.layer.borderWidth = newValue }
    }
    @IBInspectable public var borderColor: UIColor {
        get { return self.layer.borderColor == nil ? UIColor.clear : UIColor(cgColor: self.layer.borderColor!) }
        set { self.layer.borderColor = newValue.cgColor }
    }
    
    @IBInspectable var leftPadding: CGFloat = 0
    
    @IBInspectable var color: UIColor = UIColor.lightGray {
        didSet {
            updateView()
        }
    }
    
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        var textRect = super.leftViewRect(forBounds: bounds)
        textRect.origin.x += leftPadding
        return textRect
    }
    
    func updateView() {
        if let image = leftImage {
            leftViewMode = UITextField.ViewMode.always
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
            imageView.contentMode = .scaleAspectFit
            imageView.image = image
            imageView.tintColor = color
            leftView = imageView
        } else {
            leftViewMode = UITextField.ViewMode.never
            leftView = nil
        }
        
        attributedPlaceholder = NSAttributedString(string: placeholder != nil ?  placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: color])
    }
}
class TextField: UITextField {

    let padding = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 25);

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}


class RightPaddingTextField: UITextField {

    let padding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 30);

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}

@IBDesignable class UITextViewFixed: UITextView {
    override func layoutSubviews() {
        super.layoutSubviews()
        setup()
    }
    func setup() {
        textContainerInset = UIEdgeInsets.zero
        textContainer.lineFragmentPadding = 0
    }
}
