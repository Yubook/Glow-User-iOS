//  Created by iOS Development Company on 21/04/16.
//  Copyright © 2016 iOS Development Company All rights reserved.
//

import Foundation
import UIKit

public extension UIResponder {
    
    private struct Static {
        static weak var responder: UIResponder?
    }
    
    static func currentFirst() -> UIResponder? {
        Static.responder = nil
        UIApplication.shared.sendAction(#selector(UIResponder._trap), to: nil, from: nil, for: nil)
        return Static.responder
    }
    
    @objc private func _trap() {
        Static.responder = self
    }
}

extension UITableViewCell {
    
    func maskCellFromTop(margin: CGFloat) {
        layer.mask = visiblityMaskWithoutLocation(location: margin / frame.size.height)
    }
    
    func visiblityMaskWithoutLocation(location: CGFloat) -> CAGradientLayer? {
        let mask = CAGradientLayer()
        mask.frame = bounds
        mask.colors = [UIColor(white: 1, alpha: 0).cgColor, UIColor(white: 1, alpha: 1).cgColor]
        mask.locations = [NSNumber(value: Float(location)), NSNumber(value: Float(location))]
        return mask
    }
}

extension IndexPath {
    // Return IndexPath
    static func indexPathForCellContainingView(view: UIView, inTableView tableView:UITableView) -> IndexPath? {
        let viewCenterRelativeToTableview = tableView.convert(CGPoint(x: view.bounds.midX, y: view.bounds.midY), from:view)
        return tableView.indexPathForRow(at: viewCenterRelativeToTableview)
    }
    
    static func indexPathForCellContainingView(view: UIView, inCollectionView collView:UICollectionView) -> IndexPath? {
        let viewCenterRelativeToCollview = collView.convert(CGPoint(x: view.bounds.midX, y: view.bounds.midY), from:view)
        return collView.indexPathForItem(at: viewCenterRelativeToCollview)
    }
}

// MARK: - AlertController's extension
extension UIAlertController {
    
    class func actionWith(title: String?, message: String?, style: UIAlertController.Style, buttons: [String], controller: UIViewController? = nil, userAction: ((_ action: String) -> ())?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
        buttons.forEach { (buttonTitle) in
            if buttonTitle == kDelete {
                alertController.addAction(UIAlertAction(title: buttonTitle, style: .destructive, handler: { (action: UIAlertAction) in
                    userAction?(buttonTitle)
                }))
            } else if buttonTitle == kCancel {
                alertController.addAction(UIAlertAction(title: buttonTitle, style: .cancel, handler: { (action: UIAlertAction) in
                    userAction?(buttonTitle)
                }))
            } else {
                alertController.addAction(UIAlertAction(title: buttonTitle, style: .default, handler: { (action: UIAlertAction) in
                    userAction?(buttonTitle)
                }))
            }
        }
        
        if let parentController = controller {
            DispatchQueue.main.async {
                parentController.present(alertController, animated: true, completion: nil)
            }
        } else if let window = _appDelegator.window {
            if let rootController = window.rootViewController {
                DispatchQueue.main.async {
                    rootController.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
}

extension Int {
    func timeString() -> String {
        let hours = self / 3600
        let minutes = self / 60 % 60
        let seconds = self % 60
        return String(format: "%02i:%02i:%02i", hours,minutes,seconds)
    }
    
    func minutesToHour() -> (Int, Int, Int) {
        let hours = self / 3600
        let minutes = self / 60 % 60
        let seconds = self % 60
        return (hours,minutes,seconds)
    }
    
    func suffixIntNumber() -> String {
        let number: NSNumber = NSNumber(value: self)
        var num:Double = number.doubleValue
        num = fabs(num)
        
        if (num < 1000.0){
            return "\(num.intValue ?? 0)";
        }
        
        let exp:Int = Int(log10(num) / 3.0 )
        let units:[String] = ["K","M","G","T","P","E"];
        let roundedNum: Double = round(10 * num / pow(1000.0, Double(exp))) / 10
        return "\(roundedNum)\(units[exp-1])"
    }
    
    
}

extension NSAttributedString {
    
    func lineHeight() -> CGFloat {
        let constraintRect = CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: [NSStringDrawingOptions.usesLineFragmentOrigin], context: nil)
        return ceil(boundingBox.height)
    }
    
    func heightWithConstrainedWidth(width: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: [NSStringDrawingOptions.usesLineFragmentOrigin], context: nil)
        return ceil(boundingBox.height)
    }
    
    func fullRange() -> NSRange {
        return NSMakeRange(0, self.string.length)
    }
}

// MARK: - Attributed
extension NSAttributedString {
    
    // This will give combined string with respective attributes
    class func attributedText(texts: [String], attributes: [[NSAttributedString.Key : Any]]) -> NSAttributedString {
        let attbStr = NSMutableAttributedString()
        for (index,element) in texts.enumerated() {
            attbStr.append(NSAttributedString(string: element, attributes: attributes[index]))
        }
        return attbStr
    }
}

extension UILabel {
    
    func animateLabelAlpha( fromValue: NSNumber, toValue: NSNumber, duration: CFTimeInterval) {
        let titleAnimation: CABasicAnimation = CABasicAnimation(keyPath: "opacity")
        titleAnimation.duration = duration
        titleAnimation.fromValue = fromValue
        titleAnimation.toValue = toValue
        titleAnimation.isRemovedOnCompletion = true
        layer.add(titleAnimation, forKey: "opacity")
    }
    
    func setAttributedText(text: String, font: UIFont, color: UIColor) {
        let mutatingAttributedString = NSMutableAttributedString(string: text)
        mutatingAttributedString.addAttribute(NSAttributedString.Key.font, value: font, range: NSMakeRange(0, text.count))
        mutatingAttributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: NSMakeRange(0, text.count))
        attributedText = mutatingAttributedString
    }
    
    // This will give combined string with respective attributes
    func setAttributedText(texts: [String], attributes: [[NSAttributedString.Key : Any]]) {
        let attbStr = NSMutableAttributedString()
        for (index,element) in texts.enumerated() {
            attbStr.append(NSAttributedString(string: element, attributes: attributes[index]))
        }
        attributedText = attbStr
    }
    
    func addCharactersSpacing(spacing:CGFloat, text:String) {
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(NSAttributedString.Key.kern, value: spacing, range: NSMakeRange(0, text.count))
        self.attributedText = attributedString
    }
}

extension UIButton{
    // This will give combined string with respective attributes
    func setAttributedText(texts: [String], attributes: [[NSAttributedString.Key : Any]],state: UIControl.State) {
        let attbStr = NSMutableAttributedString()
        for (index,element) in texts.enumerated() {
            attbStr.append(NSAttributedString(string: element, attributes: attributes[index]))
        }
        setAttributedTitle(attbStr, for: state)
    }
}

extension UITextField{
    func setAttributedPlaceHolder(text: String, font: UIFont, color: UIColor, spacing: CGFloat, isAsterik: Bool = false) {
        let mutatingAttributedString = NSMutableAttributedString(string: text)
        if isAsterik {
            let asterix = NSAttributedString(string: "*", attributes: [.foregroundColor: UIColor.red])
            mutatingAttributedString.append(asterix)
        }
        mutatingAttributedString.addAttribute(NSAttributedString.Key.font, value: font, range: NSMakeRange(0, text.count))
        mutatingAttributedString.addAttribute(NSAttributedString.Key.kern, value: spacing, range: NSMakeRange(0, text.count))
        mutatingAttributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: NSMakeRange(0, text.count))
        attributedPlaceholder = mutatingAttributedString
    }
    
    func addCharactersSpacingInTaxt(spacing:CGFloat, text:String) {
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(NSAttributedString.Key.kern, value: spacing, range: NSMakeRange(0, text.count))
        self.attributedText = attributedString
    }
    
    func addCharactersSpacingInPlaceHolder(spacing:CGFloat, text:String) {
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(NSAttributedString.Key.kern, value: spacing, range: NSMakeRange(0, text.count))
        self.attributedPlaceholder = attributedString
    }
    
    func addCharactersSpacingWithFont(spacing:CGFloat, text:String, range: NSRange) {
        let attributedString = NSMutableAttributedString(attributedString: self.attributedText!)
        attributedString.addAttribute(NSAttributedString.Key.kern, value: spacing, range: range)
        self.attributedText = attributedString
    }
    
    func addCharactersSpacingForOTP(spacing:CGFloat, text:String, range: NSRange) {
        let rangePara = NSMakeRange(0, text.count)
        let para = NSMutableParagraphStyle()
        para.firstLineHeadIndent = (50.widthRatio - String(text.first!).WidthWithNoConstrainedHeight(font: UIFont.DUCEFontWith(.sfProDisplayRegular, size: 18))) / 2
        let attributedString = NSMutableAttributedString(attributedString: self.attributedText!)
        attributedString.addAttribute(NSAttributedString.Key.kern, value: spacing, range: range)
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: para, range: rangePara)
        self.attributedText = attributedString
    }
}

extension UITextView {
    func addCharactersSpacingInTaxt(spacing:CGFloat, text:String) {
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(NSAttributedString.Key.kern, value: spacing, range: NSMakeRange(0, text.count))
        self.attributedText = attributedString
    }
}

extension UIPanGestureRecognizer {
    
    func shouldScrollVertical() -> Bool {
        let point = self.translation(in: self.view)
        let pointX = abs(point.x)
        let pointY = abs(point.y)
        if pointX < pointY {
            return true
        }else{
            return false
        }
    }
}

//Remove objects
extension Array where Element: Equatable {
    
    mutating func remove(object: Element) {
        if let index = firstIndex(of: object) {
            remove(at: index)
        }
    }
    
    mutating func removeObjectsInArray(array: [Element]) {
        for object in array {
            remove(object: object)
        }
    }
}
