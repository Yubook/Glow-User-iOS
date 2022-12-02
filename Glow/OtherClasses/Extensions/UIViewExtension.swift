//  Created by Tom Swindell on 09/12/2015.
//  Copyright © 2015 The App Developers. All rights reserved.
//

import Foundation
import UIKit


extension UIScrollView {
    
    var currentPage: Int {
        return Int(self.contentOffset.x / self.frame.size.width)
    }
}

//MARK: - Graphics
extension UIView {
    
    func makeRound() {
        layer.cornerRadius = (self.frame.height * _widthRatio) / 2
        clipsToBounds = true
    }
    
    func fadeAlpha(toAlpha: CGFloat, duration time: TimeInterval) {
        UIView.animate(withDuration: time) { () -> Void in
            self.alpha = toAlpha
        }
    }
    
    // Will add mask to given image
    func mask(maskImage: UIImage) {
        let mask: CALayer = CALayer()
        mask.frame = CGRect(x: 0, y: 0, width: maskImage.size.width, height: maskImage.size.height)//CGRectMake( 0, 0, maskImage.size.width, maskImage.size.height)
        mask.contents = maskImage.cgImage
        layer.mask = mask
        layer.masksToBounds = true
    }
    
    func shake() {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.04
        animation.repeatCount = 4
        animation.autoreverses = true
        animation.fromValue = CGPoint(x: self.center.x - 8, y: self.center.y)
        animation.toValue = CGPoint(x: self.center.x + 8, y: self.center.y)
        self.layer.add(animation, forKey: "position")
    }
}

// MARK: - Constraints
extension UIView {
    
    func addConstraintToSuperView(lead: CGFloat, trail: CGFloat, top: CGFloat, bottom: CGFloat) {
        guard self.superview != nil else {
            return
        }
        let top = NSLayoutConstraint(item: self, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.superview!, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1.0, constant: top)
        let bottom = NSLayoutConstraint(item: self, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.superview!, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1.0, constant: bottom)
        let lead = NSLayoutConstraint(item: self, attribute: NSLayoutConstraint.Attribute.leading, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.superview!, attribute: NSLayoutConstraint.Attribute.leading, multiplier: 1.0, constant: lead)
        let trail = NSLayoutConstraint(item: self, attribute: NSLayoutConstraint.Attribute.trailing, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.superview!, attribute: NSLayoutConstraint.Attribute.trailing, multiplier: 1.0, constant: trail)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.superview!.addConstraints([top,bottom,lead,trail])
    }
}

//MARK: - Apply gradient on view
extension UIView {
    
    func applyGradientEffects(_ colours: [UIColor], gradientPoint: VBGradientPoint, removeFirstLayer: Bool = true) {
        layoutIfNeeded()
        if let subLayers = layer.sublayers, subLayers.count > 1, removeFirstLayer {
            subLayers.first?.removeFromSuperlayer()
        }
        let gradient = CAGradientLayer()
        gradient.frame = bounds
        gradient.colors = colours.map { $0.cgColor }
        gradient.startPoint = gradientPoint.draw().startPoint
        gradient.endPoint = gradientPoint.draw().endPoint
        layer.insertSublayer(gradient, at: 0)
    }
    
    func addBottomShadow() {
        layer.masksToBounds = false
        layer.shadowRadius = 4
        layer.shadowOpacity = 1
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOffset = CGSize(width: 0 , height: 2)
        layer.shadowPath = UIBezierPath(rect: CGRect(x: 0,
                                                     y: bounds.maxY - layer.shadowRadius,
                                                     width: bounds.width,
                                                     height: layer.shadowRadius)).cgPath
    }
    
}

extension UIView {
    
    // Will take screen shot of whole screen and return image. It's working on main thread and may lag UI.
    func takeScreenShot() -> UIImage {
        UIGraphicsBeginImageContext(self.bounds.size)
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, UIScreen.main.scale)
        let rec = self.bounds
        self.drawHierarchy(in: rec, afterScreenUpdates: true)
        self.layer.render(in: UIGraphicsGetCurrentContext()!)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img!
    }
    
    // To give parellex effect on any view.
    func ch_addMotionEffect() {
        let axis_x_motion: UIInterpolatingMotionEffect = UIInterpolatingMotionEffect(keyPath: "center.x", type: UIInterpolatingMotionEffect.EffectType.tiltAlongHorizontalAxis)
        axis_x_motion.minimumRelativeValue = NSNumber(value: -10)
        axis_x_motion.maximumRelativeValue = NSNumber(value: 10)
        
        let axis_y_motion: UIInterpolatingMotionEffect = UIInterpolatingMotionEffect(keyPath: "center.y", type: UIInterpolatingMotionEffect.EffectType.tiltAlongVerticalAxis)
        axis_y_motion.minimumRelativeValue = NSNumber(value: -10)
        axis_y_motion.maximumRelativeValue = NSNumber(value: 10)
        
        let motionGroup : UIMotionEffectGroup = UIMotionEffectGroup()
        motionGroup.motionEffects = [axis_x_motion, axis_y_motion]
        self.addMotionEffect(motionGroup)
    }
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    
    func roundTop(radius:CGFloat = 20){
        self.clipsToBounds = true
        self.layer.cornerRadius = radius
        if #available(iOS 11.0, *) {
            self.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        } else {
            // Fallback on earlier versions
        }
    }
    
    func roundBottom(radius:CGFloat = 20){
        self.clipsToBounds = true
        self.layer.cornerRadius = radius
        if #available(iOS 11.0, *) {
            self.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        } else {
            // Fallback on earlier versions
        }
    }
    
    func inAnimate(){
        self.alpha = 1.0
        let animation = CAKeyframeAnimation(keyPath: "transform.scale")
        animation.values = [0.01,1.2,0.9,1]
        animation.keyTimes = [0,0.4,0.6,1]
        animation.duration = 0.5
        self.layer.add(animation, forKey: "bounce")
    }
    
    func applyShadow() {
        layer.shadowColor = #colorLiteral(red: 0.7333333333, green: 0.7333333333, blue: 0.7333333333, alpha: 0.35)
        layer.shadowOpacity = 1
        layer.shadowOffset = CGSize(width: 0, height: 5)
        layer.shadowRadius = 5
    }
    
    func OutAnimation(comp:@escaping ((Bool)->())){
        CATransaction.begin()
        CATransaction.setCompletionBlock({
            comp(true)
        })
        
        let animation = CAKeyframeAnimation(keyPath: "transform.scale")
        animation.values = [1,1.2,0.9,0.01]
        animation.keyTimes = [0,0.4,0.6,1]
        animation.duration = 0.2
        self.layer.add(animation, forKey: "bounce")
        CATransaction.commit()
    }
    
    //Applying gradient effect
    func applyGradient(colours: [UIColor] = [UIColor.hexStringToUIColor(hexStr: "24A78A"),UIColor.hexStringToUIColor(hexStr: "42B69D"), UIColor.hexStringToUIColor(hexStr: "5AC2AB")],locations location:[NSNumber] = [0.5,1.0],opacity opc:Float = 1) -> Void {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = CGRect(x: 0, y: 0, width: self.frame.size.width.widthRatio, height: self.frame.size.height.widthRatio)
        gradient.colors = colours.map { $0.cgColor }
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradient.opacity = opc
        self.layer.insertSublayer(gradient, at: 0)
        self.layoutIfNeeded()
    }
    
    // CGPoint(x: 0, y: 0.5), endPoint: CGPoint(x: 1, y: 0.5))
    func applyGradientToNav(colours: [UIColor] = [UIColor.hexStringToUIColor(hexStr: "6098FF"),UIColor.hexStringToUIColor(hexStr: "85CEE7")],locations location:[NSNumber] = [0.5,1.0],opacity opc:Float = 1, height: CGFloat) -> Void {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = CGRect(x: 0, y: 0, width: _screenSize.width, height: _statusBarHeight + height)
        gradient.colors = colours.map { $0.cgColor }
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradient.opacity = opc
        self.layer.insertSublayer(gradient, at: 0)
        self.layoutIfNeeded()
    }
    
    func applyGradientforView(colours: [UIColor] = [UIColor.hexStringToUIColor(hexStr: "6098FF"),UIColor.hexStringToUIColor(hexStr: "85CEE7")],locations location:[NSNumber] = [0.5,1.0],opacity opc:Float = 1) -> Void {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = CGRect(x: 0, y: 0, width: self.frame.size.width.widthRatio, height: self.frame.size.height.widthRatio)
        gradient.colors = colours.map { $0.cgColor }
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradient.opacity = opc
        self.layer.insertSublayer(gradient, at: 0)
        self.layoutIfNeeded()
    }
}

@IBDesignable class BottomShadowNew : UIView{
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.masksToBounds = false
        layer.shadowRadius = 2
        layer.shadowOpacity = 1
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0 , height: 2)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        roundCorners(corners: [.bottomLeft, .bottomRight], radius: 15)
    }
  
}

/// Gradient view use to apply gradient effects
class GradientView: ConstrainedView {
    
    var gradientColor1: UIColor = .appGrediantColor1
    var gradientColor2: UIColor = .appGrediantColor2
    
    override func awakeFromNib() {
        super.awakeFromNib()
        applyGradient(colours: [gradientColor1, gradientColor2])
    }
}

//Gradient type
typealias GradientType = (startPoint: CGPoint, endPoint: CGPoint)

//Enum for gradient
enum VBGradientPoint {
    case leftRight
    case rightLeft
    case topBottom
    case bottomTop
    case topLeftBottomRight
    case bottomRightTopLeft
    case topRightBottomLeft
    case bottomLeftTopRight
    func draw() -> GradientType {
        switch self {
        case .leftRight:
            return (startPoint: CGPoint(x: 0, y: 0.5), endPoint: CGPoint(x: 1, y: 0.5))
        case .rightLeft:
            return (startPoint: CGPoint(x: 1, y: 0.5), endPoint: CGPoint(x: 0, y: 0.5))
        case .topBottom:
            return (startPoint: CGPoint(x: 0.5, y: 0), endPoint: CGPoint(x: 0.5, y: 1))
        case .bottomTop:
            return (startPoint: CGPoint(x: 0.5, y: 1), endPoint: CGPoint(x: 0.5, y: 0))
        case .topLeftBottomRight:
            return (startPoint: CGPoint(x: 0, y: 0), endPoint: CGPoint(x: 1, y: 1))
        case .bottomRightTopLeft:
            return (startPoint: CGPoint(x: 1, y: 1), endPoint: CGPoint(x: 0, y: 0))
        case .topRightBottomLeft:
            return (startPoint: CGPoint(x: 1, y: 0), endPoint: CGPoint(x: 0, y: 1))
        case .bottomLeftTopRight:
            return (startPoint: CGPoint(x: 0, y: 1), endPoint: CGPoint(x: 1, y: 0))
        }
    }
}



    class BottomCornerRadiusView: UIView {
        
        @IBInspectable var cornerRadious: CGFloat = 0.0
        
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
        
        override func layoutSubviews() {
            super.layoutSubviews()
            roundCorners(corners: [.bottomLeft, .bottomRight], radius: cornerRadious)
        }
        
    }
    
    class TopCornerRadiusView: UIView {
        
        @IBInspectable var cornerRadious: CGFloat = 0.0
        
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
        
        override func layoutSubviews() {
            super.layoutSubviews()
            roundCorners(corners: [.topLeft, .topRight], radius: cornerRadious)
        }
    }

    class TopRoundCornerShadow : TopCornerRadiusView{
        @IBInspectable var xPos: CGFloat = 0
        @IBInspectable var yPos: CGFloat = 0
        @IBInspectable var radious: CGFloat = 0
        @IBInspectable var opacity: CGFloat = 0
        @IBInspectable var shadowCorner: CGFloat = 0
        
        
        override func awakeFromNib() {
            super.awakeFromNib()
            clipsToBounds = true
            //layer.masksToBounds = false
            layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            layer.shadowOpacity = Float(opacity)
            layer.shadowOffset = CGSize(width: xPos, height: yPos)
            layer.shadowRadius = radious
        }
        
        override func layoutSubviews() {
            super.layoutSubviews()
            updateShadow()
        }
        
        func updateShadow() {
            let roundPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: [.topLeft,.topRight], cornerRadii: CGSize(width: shadowCorner, height: shadowCorner))
            layer.shadowPath = roundPath.cgPath
        }
    }
    

@IBDesignable class CustomButton: UIView {
    @IBInspectable var cornerRadious: CGFloat = 0.0
    
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        roundCorners(corners: [.bottomLeft, .bottomRight], radius: cornerRadious)
    }
}
