//  Created by Tom Swindell on 08/12/2015.
//  Copyright © 2015 The App Developers. All rights reserved.
//

import UIKit
import QuartzCore

class CustomTableIndicatorView: UIView {
    
    // MARK - Variables
    var isAnimating : Bool = false
    var hidesWhenStopped : Bool = true
    lazy private var animationLayer : CALayer = {
        return CALayer()
    }()
    
    // MARK - Init
    init(image : UIImage) {
        let frame : CGRect = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)//CGRectMake(0.0, 0.0, image.size.width, image.size.height)
        super.init(frame: frame)
        animationLayer.frame = frame
        animationLayer.contents = image.cgImage
        animationLayer.masksToBounds = true
        self.layer.addSublayer(animationLayer)
        addRotation(forLayer: animationLayer)
        pause(layer: animationLayer)
        self.isHidden = true
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK - Func
    func addRotation(forLayer layer : CALayer) {
        let rotation : CABasicAnimation = CABasicAnimation(keyPath:"transform.rotation.z")
        rotation.duration = 1.0
        rotation.isRemovedOnCompletion = false
        rotation.repeatCount = HUGE
        rotation.fillMode = CAMediaTimingFillMode.forwards
        rotation.fromValue = NSNumber(value: 0.0)
        rotation.toValue = NSNumber(value: 3.14 * 2.0)
        layer.add(rotation, forKey: "rotate")
    }
    
    private func pause(layer : CALayer) {
        let pausedTime = layer.convertTime(CACurrentMediaTime(), from: nil)
        layer.speed = 0.0
        layer.timeOffset = pausedTime
        isAnimating = false
    }
    
    private func resume(layer : CALayer) {
        let pausedTime : CFTimeInterval = layer.timeOffset
        layer.speed = 1.0
        layer.timeOffset = 0.0
        layer.beginTime = 0.0
        let timeSincePause = layer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        layer.beginTime = timeSincePause
        isAnimating = true
    }
    
    func startAnimating () {
        if isAnimating {
            return
        }
        if hidesWhenStopped {
            self.isHidden = false
        }
        resume(layer: animationLayer)
    }
    
    func stopAnimating () {
        if hidesWhenStopped {
            self.isHidden = true
        }
        pause(layer: animationLayer)
    }
}


class CustomActivityIndicatorView: UIView {
    
    // MARK - Variables
    var isAnimating : Bool = false
    var hidesWhenStopped : Bool = true
    lazy private var animationLayer : CALayer = {
        return CALayer()
    }()
    
    // MARK - Init
    init(image : UIImage) {
        let frame : CGRect = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)//CGRectMake(0.0, 0.0, image.size.width, image.size.height)
        super.init(frame: frame)
        animationLayer.frame = frame
        animationLayer.contents = image.cgImage
        animationLayer.masksToBounds = true
        self.layer.addSublayer(animationLayer)
        addRotation(forLayer: animationLayer)
        pause(layer: animationLayer)
        self.isHidden = true
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK - Func
    func addRotation(forLayer layer : CALayer) {
        let rotation : CABasicAnimation = CABasicAnimation(keyPath:"transform.rotation.z")
        rotation.duration = 1.0
        rotation.isRemovedOnCompletion = false
        rotation.repeatCount = HUGE
        rotation.fillMode = CAMediaTimingFillMode.forwards
        rotation.fromValue = NSNumber(value: 0.0)
        rotation.toValue = NSNumber(value: 3.14 * 2.0)
        layer.add(rotation, forKey: "rotate")
    }
    
    private func pause(layer : CALayer) {
        let pausedTime = layer.convertTime(CACurrentMediaTime(), from: nil)
        layer.speed = 0.0
        layer.timeOffset = pausedTime
        isAnimating = false
    }
    
    private func resume(layer : CALayer) {
        let pausedTime : CFTimeInterval = layer.timeOffset
        layer.speed = 1.0
        layer.timeOffset = 0.0
        layer.beginTime = 0.0
        let timeSincePause = layer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        layer.beginTime = timeSincePause
        isAnimating = true
    }
    
    func startAnimating () {
        if isAnimating {
            return
        }
        if hidesWhenStopped {
            self.isHidden = false
        }
        resume(layer: animationLayer)
    }
    
    func stopAnimating () {
        if hidesWhenStopped {
            self.isHidden = true
        }
        pause(layer: animationLayer)
    }
}
