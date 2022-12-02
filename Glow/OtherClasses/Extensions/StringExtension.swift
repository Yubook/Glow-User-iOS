//  Created by Tom Swindell on 07/12/2015.
//  Copyright © 2015 The App Developers. All rights reserved.
//

import Foundation
import UIKit
import CoreTelephony

// MARK: - Registration Validation
extension String {
    
    static func validateStringValue(str:String?) -> Bool{
        var strNew = ""
        if str != nil{
            strNew = str!.trimWhiteSpace(newline: true)
        }
        if str == nil || strNew == "" || strNew.count == 0  {  return true  }
        else  {  return false  }
    }
    
    static func validatePassword(str:String?) -> Bool{
        if str == nil || str == "" || str!.count < 6  {  return true  }
        else  {  return false  }
    }
    
    func isValidUsername() -> Bool {
        let usernameRegex = "[0-9a-z_.]{3,15}" //^[a-zA-Z0-9_]{3,15}$
        let temp = NSPredicate(format: "SELF MATCHES %@", usernameRegex).evaluate(with: self)
        return temp
    }
    
    func isValidName() -> Bool{
        let nameRegix = "(?:[\\p{L}\\p{M}]|\\d)"
        return NSPredicate(format: "SELF MATCHES %@", nameRegix).evaluate(with: self)
    }
    
    func isValidEmailAddress() -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        let temp = NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: self)
        return temp
    }

    func validateContact() -> Bool{
//        let contactRegEx = "^\\d{3}-\\d{3}-\\d{4}$"
        let contactRegEx = "^[0-9]{10,12}$"
        let contactTest = NSPredicate(format:"SELF MATCHES %@", contactRegEx)
        return contactTest.evaluate(with: self)
    }
    
    func validateBankAccNo() -> Bool{
        let accountRegEx = "^[0-9]{10,15}$"
        let accountTest = NSPredicate(format:"SELF MATCHES %@", accountRegEx)
        return accountTest.evaluate(with: self)
    }
}

// MARK: - Character check
extension String {
    
    func trimmedString() -> String {
        return self.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
    }
    
    func contains(find: String) -> Bool{
        return self.range(of: find, options: String.CompareOptions.caseInsensitive) != nil
    }
    
    func trimWhiteSpace(newline: Bool = false) -> String {
        if newline {
            return self.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        } else {
            return self.trimmingCharacters(in: NSCharacterSet.whitespaces)
        }
    }
    
    func removeSpecial(_ character: String) -> String {
        let okayChars : Set<Character> = Set("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ1234567890.")
        return String(self.filter {okayChars.contains($0) })
    }
    
    func suffixAmount() -> String {
        let actualAmount:Double = self.doubleValue ?? 0
        var shortenedAmount = actualAmount
        var suffix = ""
        if actualAmount >= 10000000.0 {
            suffix = "Cr"
            shortenedAmount /= 10000000.0
        } else if actualAmount >= 100000.0 {
            suffix = "L"
            shortenedAmount /= 100000.0
        } else if actualAmount >= 1000.0 {
            suffix = "K"
            shortenedAmount /= 1000.0
        }
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.currencySymbol = ""
        let numberAsString = numberFormatter.string(from: NSNumber(value: shortenedAmount))
        return "\(numberAsString ?? "")\(suffix)"
    }

    func suffixNumber() -> String {
        let number: NSNumber = NSNumber(value: Int64(self) ?? 0)
        var num:Double = number.doubleValue
        let sign = ((num < 0) ? "-" : "" )

        num = fabs(num)

        if (num < 1000.0) {
            return "\(sign)\(num)";
        }

        let exp:Int = Int(log10(num) / 3.0 ); //log10(1000));

        let units:[String] = ["K","M","G","T","P","E"];

        let roundedNum:Double = round(10 * num / pow(1000.0,Double(exp))) / 10;
        
        return "\(sign)\(roundedNum)\(units[exp-1])"
    }
    
    func applyPatternOnNumbers(pattern: String) -> String {
        var pureNumber = self.replacingOccurrences( of: "[^0-9]", with: "", options: .regularExpression)
        for index in 0 ..< pattern.count {
            guard index < pureNumber.count else { return pureNumber }
            let stringIndex = String.Index(utf16Offset: index, in: String(pattern))
            let patternCharacter = pattern[stringIndex]
            guard patternCharacter != "#" else { continue }
            pureNumber.insert(patternCharacter, at: stringIndex)
        }
        return String(pureNumber.prefix(pattern.count))
    }

}

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}

extension String {
    func localized(comment: String = "") -> String {
        return NSLocalizedString(self, comment: comment)
    }
}


// MARK: - Layout
extension String {
    
    var length: Int {
        return (self as NSString).length
    }
    
    func isEqual(str: String) -> Bool {
        if self.compare(str) == ComparisonResult.orderedSame{
            return true
        }else{
            return false
        }
    }
    
    func heightWithConstrainedWidth(width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: [NSStringDrawingOptions.usesLineFragmentOrigin], attributes: [NSAttributedString.Key.font: font], context: nil)
        return boundingBox.height
    }
    
    func singleLineHeight(font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: [NSStringDrawingOptions.usesLineFragmentOrigin], attributes: [NSAttributedString.Key.font: font], context: nil)
        return boundingBox.height
    }
    
    func WidthWithNoConstrainedHeight(font: UIFont) -> CGFloat {
        let width = CGFloat.greatestFiniteMagnitude
        let constraintRect = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        return boundingBox.width
    }
}

extension Data {
    var html2AttributedString: NSAttributedString? {
        do {
            return try NSAttributedString(data: self, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            print("error:", error)
            return  nil
        }
    }
    var html2String: String {
        return html2AttributedString?.string ?? ""
    }
}

extension String {
    var html2AttributedString: NSAttributedString? {
        return Data(utf8).html2AttributedString
    }
    var html2String: String {
        return html2AttributedString?.string ?? ""
    }
}

extension String {
    func heightFormImageUrl() -> CGFloat {
        let url = URL(string: self)!
        var pixelHeight:Int!
        if let imageSource = CGImageSourceCreateWithURL(url as CFURL, nil) {
            if let imageProperties = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, nil) as Dictionary? {
                pixelHeight = imageProperties[kCGImagePropertyPixelHeight] as? Int
            }
        }
        return CGFloat(pixelHeight)
    }
    
    func widthFormImageUrl() -> CGFloat {
        let url = URL(string: self)!
        var pixelWidth:Int!
        if let imageSource = CGImageSourceCreateWithURL(url as CFURL, nil) {
            if let imageProperties = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, nil) as Dictionary? {
                pixelWidth = imageProperties[kCGImagePropertyPixelWidth] as? Int
            }
        }
        return CGFloat(pixelWidth)
    }
    
    func toDate(withFormat format: String = "yyyy-MM-dd") -> Date {
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = format
      guard let date = dateFormatter.date(from: self) else {
        preconditionFailure("Take a look to your format")
      }
      return date
    }
}
