import UIKit

extension UIColor {
    
    class func colorWithGray(gray: Int) -> UIColor {
      return UIColor(red: CGFloat(gray) / 255.0, green: CGFloat(gray) / 255.0, blue: CGFloat(gray) / 255.0, alpha: 1.0)
    }
    
    class func colorWithRGB(r: Int, g: Int, b: Int) -> UIColor {
        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: 1.0)
    }

    class func colorWithHexa(hex:Int) -> UIColor{
        let components = (
            R: CGFloat((hex >> 16) & 0xff) / 255,
            G: CGFloat((hex >> 08) & 0xff) / 255,
            B: CGFloat((hex >> 00) & 0xff) / 255
        )
        return UIColor(red: components.R, green: components.G, blue: components.B, alpha: 1.0)
    }
    
    class func transparentBGColor() -> UIColor {
        return UIColor(red:  77.0 / 255.0, green: 79.0 / 255.0, blue: 92.0 / 255.0, alpha: 0.33)
    }
    
    @objc class func colourWith(red: Int, green: Int, blue: Int, alpha: CGFloat) -> UIColor {
        return UIColor(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: alpha)
    }
    
    @objc class var appGrediantColor1: UIColor {
        return UIColor.colourWith(red: 51, green: 191, blue: 226, alpha: 1.0)
    }
    
    @objc class var appGrediantColor2: UIColor {
        return UIColor.colourWith(red: 98, green: 151, blue: 213, alpha: 1.0)
    }
    
    class func appThemeBlack(alpha: CGFloat = 1.0) -> UIColor {
        return UIColor.hexStringToUIColor(hexStr: "2A3143", alpha: alpha)
    }
    
    @objc class var appSuccessColor: UIColor {
        return UIColor.hexStringToUIColor(hexStr: "26AE60", alpha: 1.0)
    }
    
    @objc class var appErrorColor: UIColor {
        return UIColor.hexStringToUIColor(hexStr: "F05033", alpha: 1.0)
    }
    
    @objc class var positiveTextColor: UIColor {
        return UIColor.hexStringToUIColor(hexStr: "00A9A7", alpha: 1.0)
    }
    
    class func hexStringToUIColor (hexStr: String, alpha: CGFloat = 1.0) -> UIColor {
        var cString:String = hexStr.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
    
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: alpha
        )
    }
}

struct DuceColor {
    static var blue:    UIColor{ return UIColor.hexStringToUIColor(hexStr: "50A2F4")}
    static var red:     UIColor{ return UIColor.hexStringToUIColor(hexStr: "FE4F50")}
    static var gray:    UIColor{ return UIColor.gray}
    static var black:   UIColor{return UIColor.hexStringToUIColor(hexStr: "333333")}
    static var yellow:  UIColor{return UIColor.hexStringToUIColor(hexStr: "E5B515")}
    static var green:   UIColor{return UIColor.hexStringToUIColor(hexStr: "2AAA8E")}
    static var lightRed: UIColor{return UIColor.hexStringToUIColor(hexStr: "DC143C")}
}
