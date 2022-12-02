//  Created by Tom Swindell on 10/12/2015.
//  Copyright © 2015 The App Developers. All rights reserved.
//

import UIKit
import AVFoundation
import QuartzCore
import ImageIO

public extension UIImage {
    
    func mask(maskImage: UIImage) -> UIImage? {
        var maskedImage: UIImage? = nil
        
        let maskRef = maskImage.cgImage as CGImage?
        
        let mask = CGImage(maskWidth: maskRef!.width,
                           height: maskRef!.height,
                           bitsPerComponent: maskRef!.bitsPerComponent,
                           bitsPerPixel: maskRef!.bitsPerPixel,
                           bytesPerRow: maskRef!.bytesPerRow,
                           provider: maskRef!.dataProvider!, decode: nil, shouldInterpolate: false) as CGImage?
        
        let maskedImageRef = self.cgImage!.masking(mask!)
        
        maskedImage = UIImage(cgImage: maskedImageRef!)
        
        return maskedImage
    }
    
    class func createImageWithColor(color: UIColor, size: CGSize) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)//CGRectMake(0, 0, size.width, size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
    
    func resize(size:CGSize)-> UIImage {
        
        let scale  = UIScreen.main.scale
        let newSize = CGSize(width: size.width  , height: size.height  )
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, scale)
        let context = UIGraphicsGetCurrentContext()
        
        context!.interpolationQuality = CGInterpolationQuality.high
        self.draw(in: CGRect(origin: CGPoint.zero, size: newSize))
        
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return scaledImage!
    }
}

extension UIImageView{
    func rotateImageHalf(duration: Double, isForward: Bool){
        let rotation : CABasicAnimation = CABasicAnimation(keyPath:"transform.rotation.z")
        rotation.duration = duration
        rotation.isRemovedOnCompletion = false
        rotation.repeatCount = 1
        rotation.fillMode = CAMediaTimingFillMode.forwards
        rotation.fromValue = NSNumber(value: 0.0)
        rotation.toValue = NSNumber(value: (isForward == true ? 3.14 : -3.14))
        self.layer.add(rotation, forKey: "rotate")
    }
}
