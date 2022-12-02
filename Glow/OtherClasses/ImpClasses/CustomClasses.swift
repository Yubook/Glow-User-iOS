//  Created by iOS Development Company on 19/04/16.
//  Copyright © 2016 iOS Development Company All rights reserved.
//

import Foundation
import UIKit

class KPTouch: ConstrainedView {
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

class KPGradientButton: UIButton {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.applyGradient()
    }
}

class KPRoundButton: UIButton {
    
    @IBInspectable var isRatioAppliedOnSize: Bool = false
    
    @IBInspectable var isGradientApplicable: Bool = false {
        didSet{
            if isGradientApplicable {
                self.applyGradient()
            }
        }
    }
    
    @IBInspectable var isRationAppliedOnText: Bool = false{
        didSet{
            if isRationAppliedOnText, let afont = titleLabel?.font {
                titleLabel?.font = afont.withSize(afont.pointSize * _widthRatio)
            }
        }
    }
    
    @IBInspectable var cornerRadious: CGFloat = 0{
        didSet{
            if cornerRadious == 0{
                layer.cornerRadius = (self.frame.height * _widthRatio) / 2
            }else{
                layer.cornerRadius = isRatioAppliedOnSize ? cornerRadious * _widthRatio : cornerRadious
            }
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.clear{
        didSet{
            layer.borderColor = borderColor.cgColor
        }
    }

    @IBInspectable var borderWidth: CGFloat = 0{
        didSet{
            layer.borderWidth = borderWidth
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if let img = self.imageView {
            img.contentMode = .scaleAspectFit
            let padding = 12.widthRatio
            self.imageEdgeInsets = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
            img.layer.cornerRadius = img.frame.size.height / 2
        }
        self.layer.masksToBounds = true
    }
}

class KPRoundLabel: UILabel {
    
    @IBInspectable var isRatioAppliedOnSize: Bool = false
    
    @IBInspectable var isRationAppliedOnText: Bool = false{
        didSet{
            if isRationAppliedOnText {
                font = font.withSize(font.pointSize * _widthRatio)
            }
        }
    }
    
//    @IBInspectable var borderColor: UIColor = UIColor.clear{
//        didSet{
//            layer.borderColor = borderColor.cgColor
//        }
//    }
//
//    @IBInspectable var borderWidth: CGFloat = 0{
//        didSet{
//            layer.borderWidth = borderWidth
//        }
//    }
    
    @IBInspectable var cornerRadious: CGFloat = 0{
        didSet{
            if cornerRadious == 0{
                layer.cornerRadius = isRatioAppliedOnSize ? (self.frame.height * _widthRatio) / 2 : self.frame.height / 2
            }else{
                layer.cornerRadius = isRatioAppliedOnSize ? cornerRadious * _widthRatio : cornerRadious
            }
        }
    }
    
    @IBInspectable var letterSpace : CGFloat = 0{
        didSet{
            letterSpace = letterSpace * _widthRatio
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

class JPTextField: UITextField {
    
    @IBInspectable var letterSpace : CGFloat = 0{
        didSet{
            letterSpace = letterSpace * _widthRatio
        }
    }
        
    let padding = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 5)
       
       override open func textRect(forBounds bounds: CGRect) -> CGRect {
           return bounds.inset(by: padding)
       }
       
       override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
           return bounds.inset(by: padding)
       }
       
       override open func editingRect(forBounds bounds: CGRect) -> CGRect {
           return bounds.inset(by: padding)
       }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if let afont = font {
            font = afont.withSize(afont.pointSize * _widthRatio)
        }
        layer.masksToBounds = true
        tintColor = UIColor.hexStringToUIColor(hexStr: "2D2D41", alpha: 1.0)
        textColor = UIColor.hexStringToUIColor(hexStr: "2D2D41", alpha: 1.0)
        if let place = placeholder {
            let font = UIFont.DUCEFontWith(.sfProDisplayRegular, size: 15.widthRatio)
            let color = UIColor.hexStringToUIColor(hexStr: "2D2D41", alpha: 0.5)
            setAttributedPlaceHolder(text: place, font: font, color: color, spacing: 0)
        }
    }
    
    func addAttributePlaceHolder(isAsterikRequired: Bool) {
        if let place = placeholder{
            let font = UIFont.DUCEFontWith(.sfProDisplayRegular, size: 15.widthRatio)
            let color = UIColor.hexStringToUIColor(hexStr: "2D2D41", alpha: 0.5)
            setAttributedPlaceHolder(text: place, font: font, color: color, spacing: 0, isAsterik: isAsterikRequired)
        }
    }
}

class KPRoundTextField: UITextField {

    @IBInspectable var isRatioAppliedOnSize: Bool = false
    
    @IBInspectable var isRationAppliedOnText: Bool = false{
        didSet{
            if isRationAppliedOnText {
                font = font?.withSize((font?.pointSize)! * _widthRatio)
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
    
    let padding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 5)
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    @IBInspectable var cornerRadious: CGFloat = 0{
        didSet{
            if cornerRadious == 0{
                layer.cornerRadius = isRatioAppliedOnSize ? (self.frame.height * _widthRatio) / 2 : self.frame.height / 2
            }else{
                layer.cornerRadius = isRatioAppliedOnSize ? cornerRadious * _widthRatio : cornerRadious
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.masksToBounds = true
    }
}



class KPBorderView: KPRoundView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 5
        layer.borderWidth = 0.3
        layer.borderColor = UIColor.hexStringToUIColor(hexStr: "2D2D41", alpha: 0.4).cgColor
    }
    
}

class KPRoundView: UIView {
    
    @IBInspectable var isRatioAppliedOnSize: Bool = false
    
    @IBInspectable var cornerRadious: CGFloat = 0 {
        didSet{
            if cornerRadious == 0 {
                layer.cornerRadius = (self.frame.height * _widthRatio) / 2
            }else{
                layer.cornerRadius = isRatioAppliedOnSize ? cornerRadious * _widthRatio : cornerRadious
            }
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.clear{
        didSet{
            layer.borderColor = borderColor.cgColor
        }
    }

    @IBInspectable var borderWidth: CGFloat = 0{
        didSet{
            layer.borderWidth = borderWidth
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.masksToBounds = true
    }
}

class KPRoundShadowView: KPRoundView {
    
    @IBInspectable var xPos: CGFloat = 0
    @IBInspectable var yPos: CGFloat = 0
    @IBInspectable var radious: CGFloat = 0
    @IBInspectable var opacity: CGFloat = 0.20
    @IBInspectable var shadowCorner: CGFloat = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        clipsToBounds = true
        layer.masksToBounds = false
        layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.2)
        layer.shadowOpacity = Float(opacity)
        layer.shadowOffset = CGSize(width: xPos, height: yPos)
        layer.shadowRadius = radious
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateShadow()
    }
    
    func updateShadow() {
        let roundPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: [.allCorners], cornerRadii: CGSize(width: shadowCorner, height: shadowCorner))
        layer.shadowPath = roundPath.cgPath
    }
}

class KPRoundImageView: UIImageView {

    @IBInspectable var isRatioAppliedOnSize: Bool = false
    
    @IBInspectable var cornerRadious: CGFloat = 0 {
        didSet{
            if cornerRadious == 0{
                layer.cornerRadius = (self.frame.width) / 2
            }else{
                layer.cornerRadius = isRatioAppliedOnSize ? cornerRadious * _widthRatio : cornerRadious
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.masksToBounds = true
    }
}

class KPRoundedView: UIView {

    @IBInspectable var isRatioAppliedOnSize: Bool = false
    
    @IBInspectable var cornerRadious: CGFloat = 0 {
        didSet{
            if cornerRadious == 0{
                layer.cornerRadius = (self.frame.width) / 2
            }else{
                layer.cornerRadius = isRatioAppliedOnSize ? cornerRadious * _widthRatio : cornerRadious
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.masksToBounds = true
    }
}

class KPRoundedButton: UIButton {

    @IBInspectable var isRatioAppliedOnSize: Bool = false
    
    @IBInspectable var cornerRadious: CGFloat = 0 {
        didSet{
            if cornerRadious == 0{
                layer.cornerRadius = (self.frame.width) / 2
            }else{
                layer.cornerRadius = isRatioAppliedOnSize ? cornerRadious * _widthRatio : cornerRadious
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.masksToBounds = true
    }
}



class KPNavigationBar: UIView{
    
    @IBInspectable var cornerRadious: CGFloat = 0
    @IBOutlet var lblTitle:UILabel?
    override func awakeFromNib() {
        super.awakeFromNib()
        let rect = CGRect(origin: self.bounds.origin, size: CGSize(width: _screenSize.width, height: _btmNavigationHeight))
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: cornerRadious, height: cornerRadious))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
}

class KPSingleRoundCornerView: UIView{
    
    @IBInspectable var isTopLeft: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let rect = CGRect(origin: self.bounds.origin, size: CGSize(width: _screenSize.width / 2 - 1, height: 62))
        let corner:UIRectCorner = isTopLeft ? [UIRectCorner.topLeft] : [UIRectCorner.topRight]
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corner, cornerRadii: CGSize(width: 7, height: 7))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        mask.lineWidth = 2
        mask.strokeColor = isTopLeft ? DuceColor.red.cgColor : DuceColor.gray.cgColor
        mask.fillColor = UIColor.white.cgColor
        self.layer.addSublayer(mask)
        for view in self.subviews{
            self.bringSubviewToFront(view)
        }
    }
}

class RoundShadowView: KPRoundView {
    
    @IBInspectable var xPos: CGFloat = 0
    @IBInspectable var yPos: CGFloat = 0
    @IBInspectable var radious: CGFloat = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        clipsToBounds = true
        layer.masksToBounds = false
        layer.shadowColor = #colorLiteral(red: 0.1333333333, green: 0.137254902, blue: 0.1529411765, alpha: 1)
        layer.shadowOpacity = 0.9
        layer.shadowOffset = CGSize(width: xPos, height: yPos)
        layer.shadowRadius = radious
        let shadowRect = CGRect(origin: CGPoint.zero, size: CGSize(width: self.frame.size.width, height: self.frame.size.height))
        let roundPath = UIBezierPath(roundedRect: shadowRect, byRoundingCorners: [.allCorners], cornerRadii: CGSize(width: self.frame.size.height / 2, height: self.frame.size.height / 2))
        layer.shadowPath = roundPath.cgPath
    }
}


class KPNavigationGradientView: UIView {
    
    @IBInspectable var height: CGFloat = 44
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = #colorLiteral(red: 0.1411764706, green: 0.2980392157, blue: 0.631372549, alpha: 1)
       // self.applyGradientToNav(height: height)
    }
}


//MARK: - Constained Classes for All device support
class KPGredientView : KPRoundView {
    
    @IBInspectable var isShadowApplied: Bool = false
    
    @IBInspectable public var zPosition: CGFloat {
        get { return layer.zPosition }
        set { layer.zPosition = newValue }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.applyGradientforView()
    }
}

class KPTopViewGradient: BaseView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.applyGradient(colours: [UIColor.hexStringToUIColor(hexStr: "5BC4AD"),UIColor.hexStringToUIColor(hexStr: "#5BC4B0"), UIColor.hexStringToUIColor(hexStr: "5AC2AB")])
    }
    
}

class KPThreeGradientView: UIView {
    
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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.applyGradient()
    }
}

class KPBlackGredientView : UIView{
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.clear
        self.applyGradient(colours: [UIColor.black.withAlphaComponent(0),UIColor.black.withAlphaComponent(1)])
    }
    
    func applyGradient(colours: [UIColor]) -> Void {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = CGRect(x: 0, y: 0, width: _screenSize.width, height: _btmNavigationHeight)
        gradient.colors = colours.map { $0.cgColor }
        self.layer.insertSublayer(gradient, at: 0)
    }
}


class SimpleDarkBlur: UIView {
    override func awakeFromNib() {
        self.backgroundColor = UIColor.clear
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        //always fill the view
        blurEffectView.frame = self.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(blurEffectView)
        self.sendSubviewToBack(blurEffectView)
    }
}

class SimpleLightBlur: UIView {
    override func awakeFromNib() {
        self.backgroundColor = UIColor.clear
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.extraLight)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        //always fill the view
        blurEffectView.frame = self.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(blurEffectView)
        self.sendSubviewToBack(blurEffectView)
    }
}

/// This Class will decrease font size as well it will make intrinsiz content size 10 pixel bigger as we need padding on both side of label
class KPointsLabel: UILabel {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        font = font.withSize(font.pointSize * _widthRatio)
        self.layer.cornerRadius = ((self.bounds.size.height + 4) * _widthRatio)/2
        self.layer.masksToBounds = true
    }

    override var intrinsicContentSize: CGSize{
        let asize = super.intrinsicContentSize
        if self.text?.count == 1{
            return CGSize(width: (22 * _widthRatio) , height: asize.height + (4 * _widthRatio))
        }else{
            let width = asize.width + (2 * _widthRatio)
            let height = asize.height + (4 * _widthRatio)
            return CGSize(width: (width < height ? height : width) , height: height)
        }
    }
}

class BaseView: ConstrainedView {
    @IBInspectable public var isRound: Bool {
        get { return (layer.cornerRadius == (frame.size.width/2) * _widthRatio) || (layer.cornerRadius == (frame.size.height/2) * _heightRatio) }
        set { layer.cornerRadius = newValue == true ? (frame.size.height/2) * _widthRatio : layer.cornerRadius }
    }
    @IBInspectable public var isViewRound: Bool {
        get { return (layer.cornerRadius == (frame.size.width/2) ) || (layer.cornerRadius == (frame.size.height/2)) }
        set { layer.cornerRadius = newValue == true ? (frame.size.height/2) : layer.cornerRadius }
    }
    @IBInspectable public var borderWidth: CGFloat {
        get { return self.layer.borderWidth }
        set { self.layer.borderWidth = newValue }
    }
    @IBInspectable public var borderColor: UIColor {
        get { return self.layer.borderColor == nil ? UIColor.clear : UIColor(cgColor: self.layer.borderColor!) }
        set { self.layer.borderColor = newValue.cgColor }
    }
    @IBInspectable public var cornerRadius: CGFloat {
        get { return layer.cornerRadius }
        set { layer.cornerRadius = newValue }
    }
    @IBInspectable public var shadowRadius: CGFloat {
        get { return layer.shadowRadius }
        set { layer.shadowRadius = newValue }
    }
    @IBInspectable public var shadowOpacity: Float {
        get { return layer.shadowOpacity }
        set { layer.shadowOpacity = newValue }
    }
    @IBInspectable public var shadowColor: UIColor? {
        get { return layer.shadowColor != nil ? UIColor(cgColor: layer.shadowColor!) : nil }
        set { layer.shadowColor = newValue?.cgColor }
    }
    @IBInspectable public var shadowOffset: CGSize {
        get { return layer.shadowOffset }
        set { layer.shadowOffset = newValue }
    }
    @IBInspectable public var zPosition: CGFloat {
        get { return layer.zPosition }
        set { layer.zPosition = newValue }
    }
}
