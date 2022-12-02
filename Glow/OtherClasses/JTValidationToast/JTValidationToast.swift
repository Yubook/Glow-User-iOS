//
//  ValidationToast.swift
//  Store2Door
//
//  Created by Yudiz Solutions on 31/08/18.
//  Copyright © 2018 Yudiz Solutions. All rights reserved.
//

import Foundation
import UIKit

// Toast Present stlye enum
enum ToastPosition : Int{
    case top = 0
    case center = 1
    case bottom = 2
    case belowNav = 3
    
    static var navHeight: CGFloat = 44
}
// Toast behaviour type enum
enum ToastType : Int{
    case normal
    case success
    case warning
    case error
}


// Toast View
class JTValidationToast: UIView {
    
    // MARK: - Outlets
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var viewMessage: UIView!
    
    var presentType : ToastPosition = .top
    var animationStlye : AnimationStlye = .slide
    var title : String = ""
    var message : String = ""
    
    fileprivate var alertWindow: ToastWindow?
    
    fileprivate var window_Appdelegate: UIWindow{
        let appDelegator   = UIApplication.shared.delegate! as! AppDelegate
        return appDelegator.window!
    }
    
    //  Toast animation stlye enum
    enum AnimationStlye : Int{
        case fade
        case slide
    }
    
    // MARK: - Initialisers
    override func awakeFromNib() {
        super.awakeFromNib()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.deviceOrientationDidChange(_:)),
            name: UIDevice.orientationDidChangeNotification,
            object: nil
        )
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    class func show(message msg: String, viewController: UIViewController? = nil, type: ToastType = ToastType.error, presentType : ToastPosition = .top, animationStlye : AnimationStlye = .slide, isInternetMsg: Bool = false ,completion: (()->())? = nil) {
        if msg.isEmpty{
            completion?()
            return
        }
        let toast = Bundle.main.loadNibNamed("JTValidationToast", owner: nil, options: nil)![0] as! JTValidationToast
        toast.animationStlye = animationStlye
        toast.presentType = presentType
        toast.message = msg
        toast.lblMessage.text = msg
        toast.lblMessage.textColor = .white
        toast.clipsToBounds = true
        switch type {
        case .error:
            toast.viewMessage.backgroundColor =  UIColor.appErrorColor
            break
        case .success:
            toast.viewMessage.backgroundColor = UIColor.appSuccessColor
            break
        case .warning:
            toast.viewMessage.backgroundColor = UIColor.appThemeBlack()
            break
        default:
            toast.viewMessage.backgroundColor = UIColor.appThemeBlack()
            break
        }
        toast.viewMessage.alpha = toast.animationStlye  == .fade ? 0.0 : 1.0
        
        if let vc = viewController{
            vc.view.addSubview(toast)
            toast.prepareToAddConstraint(vc)
            toast.layoutIfNeeded()
            
            toast.animateIn(duration: 0.2, delay: 0.1) { (completed) in
                toast.animateOut(duration: 0.2, delay: 2.5, completion: { (completed) in
                    toast.removeFromSuperview()
                    completion?()
                })
            }
        }else{
            
            let vc = UIViewController()
            vc.modalPresentationStyle = .fullScreen
            vc.modalTransitionStyle = .coverVertical
            
            toast.alertWindow = ToastWindow(frame: toast.frame)
            toast.alertWindow?.addSubview(toast)
            toast.alertWindow?.rootViewController = vc
            toast.layoutIfNeeded()
            
            if isInternetMsg {
               
            } else {
                toast.animateIn(duration: 0.2, delay: 0.1) { (completed) in
                    toast.animateOut(duration: 0.2, delay: 2.5, completion: { (completed) in
                        toast.removeFromSuperview()
                        toast.alertWindow?.rootViewController?.dismiss(animated: false, completion: nil)
                        completion?()
                    })
                }
            }
        }
    }
    
    // Update toast frame base on toast style
    fileprivate func prepareToAddConstraint(_ vc: UIViewController){
        
        let trail = NSLayoutConstraint(item: self, attribute: NSLayoutConstraint.Attribute.trailing, relatedBy: NSLayoutConstraint.Relation.equal, toItem: vc.view, attribute: NSLayoutConstraint.Attribute.trailing, multiplier: 1, constant: 0)
        let lead = NSLayoutConstraint(item: self, attribute: NSLayoutConstraint.Attribute.leading, relatedBy: NSLayoutConstraint.Relation.equal, toItem: vc.view, attribute: NSLayoutConstraint.Attribute.leading, multiplier: 1, constant: 0)
        
        switch presentType {
        case .bottom:
            let buttom = NSLayoutConstraint(item: self, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: vc.view, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1, constant: 0)
            self.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([buttom,trail,lead])
            break
        case .center:
            let center = NSLayoutConstraint(item: self, attribute: NSLayoutConstraint.Attribute.centerY, relatedBy: NSLayoutConstraint.Relation.equal, toItem: vc.view, attribute: NSLayoutConstraint.Attribute.centerY, multiplier: 1, constant: 0)
            
            self.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([center,trail,lead])
            
            break
            
        case .belowNav:
            var top: NSLayoutConstraint!
            if #available(iOS 11.0, *) {
                let guide = vc.view.safeAreaLayoutGuide
                top =  self.topAnchor.constraint(equalTo: guide.topAnchor, constant: ToastPosition.navHeight)
            }else  {
                top =   self.topAnchor.constraint(equalTo: vc.topLayoutGuide.bottomAnchor, constant:ToastPosition.navHeight)
            }
            self.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([top,trail,lead])
            
            break
        default:
            let top = NSLayoutConstraint(item: self, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: vc.view, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1, constant: 0)
            self.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([top,trail,lead])
            break
        }
    }
    
    fileprivate func getToastMsgFrame() -> (yPos: CGFloat, height: CGFloat, screenSize: CGSize ){
        var height = self.msgHeight()
        var statusBarHeight: CGFloat = 0.0
        let orientation = UIApplication.shared.statusBarOrientation
        
        if let window = alertWindow, orientation.isPortrait || window.shouldRotateManually {
            statusBarHeight = UIApplication.shared.statusBarFrame.height
            
        }else if orientation.isPortrait{
            statusBarHeight = UIApplication.shared.statusBarFrame.height
        }
        var yPos : CGFloat = statusBarHeight
        let screenSize: CGSize = self.window_Appdelegate.frame.size
        
        switch presentType {
        case .bottom:
            yPos = 0.0
            if #available(iOS 11.0, *) {
                height += self.window_Appdelegate.rootViewController!.view.safeAreaInsets.bottom
            }
            yPos = screenSize.height - height - yPos
            
            break
        case .center:
            yPos = screenSize.height/2 - height/2
            break
        case .belowNav:
            if #available(iOS 11.0, *) {
                yPos = self.window_Appdelegate.rootViewController!.view.safeAreaInsets.top
            }
            yPos += ToastPosition.navHeight
            break
            
        default:
            yPos = 0.0
            //            self.clipsToBounds = false
            
            if #available(iOS 11.0, *) {
                height += self.window_Appdelegate.rootViewController!.view.safeAreaInsets.top
            }else{
                height += statusBarHeight
            }
            break
            
        }
        
        return (yPos, height, screenSize)
    }
    
    
    // get message Height
    fileprivate func msgHeight() -> CGFloat{
        
        let screenSize: CGSize = self.window_Appdelegate.frame.size
        var panding: CGFloat = 20
        if #available(iOS 11.0, *) {
            let orientation = UIApplication.shared.statusBarOrientation
            if let window = alertWindow, !orientation.isPortrait || !window.shouldRotateManually {
                panding += self.window_Appdelegate.rootViewController!.view.safeAreaInsets.left * 2
                
            }else if orientation.isLandscape{
                panding += self.window_Appdelegate.rootViewController!.view.safeAreaInsets.left * 2
            }
            
        }
        let size = CGSize(width: screenSize.width - panding, height: .infinity)
        let estimatedSize = lblMessage.sizeThatFits(size)
        return max((ToastPosition.navHeight), (estimatedSize.height + 10))
    }
    
    fileprivate func prepareForAnimation(_ isShow: Bool = false){
        if self.animationStlye == .slide{
            self.viewMessage.alpha = 1.0
            //            self.transform = CG
        }else{
            self.viewMessage.alpha = isShow ? 1.0 : 0.0
        }
        
    }
    // MARK: - Toast Animation Functions
    func animateIn(duration: TimeInterval, delay: TimeInterval, completion: ((_ completed: Bool) -> ())? = nil) {
        if self.animationStlye == .slide{
            let result = self.getToastMsgFrame()
            self.viewMessage.alpha = 1.0
            if self.presentType == .bottom{
                self.viewMessage.transform = CGAffineTransform(translationX: 0, y: (result.height + result.yPos))
            }else if self.presentType == .center{
                self.viewMessage.transform = CGAffineTransform(scaleX: 1, y: 0)
            } else{
                self.viewMessage.transform = CGAffineTransform(translationX: 0, y: -(result.height + result.yPos))
            }
        }
        UIView.animate(withDuration: duration, delay: delay, options: UIView.AnimationOptions.beginFromCurrentState, animations: { () -> Void in
            if self.animationStlye == .slide{
                self.viewMessage.transform = CGAffineTransform.identity
            }else{
                self.viewMessage.alpha = 1.0
            }
        }) { (completed) -> Void in
            completion?(completed)
        }
    }
    
    func animateOut(duration: TimeInterval, delay: TimeInterval, completion: ((_ completed: Bool) -> ())? = nil) {
        let result = self.getToastMsgFrame()
        UIView.animate(withDuration: duration, delay: delay, options: UIView.AnimationOptions.beginFromCurrentState, animations: { () -> Void in
            if self.animationStlye == .slide{
                if self.presentType == .bottom{
                    self.viewMessage.transform = CGAffineTransform(translationX: 0, y: (result.height + result.yPos))
                }else if self.presentType == .center{
                    self.viewMessage.transform = CGAffineTransform(scaleX: 1, y: -0.01)
                }else{
                    self.viewMessage.transform = CGAffineTransform(translationX: 0, y: -(result.height + result.yPos))
                }
            }
            self.viewMessage.alpha = 0.0
            
        }) { (completed) -> Void in
            completion?(completed)
        }
    }
    // MARK: Notifications
    @objc  func deviceOrientationDidChange(_ noti: Notification) {
        self.setNeedsLayout()
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        if let _ = alertWindow{
            let result = self.getToastMsgFrame()
            self.frame = CGRect(x: 0, y:  result.yPos, width: result.screenSize.width, height: result.height)
        }
    }
    
    
    override open func hitTest(_ point: CGPoint, with event: UIEvent!) -> UIView? {
        if let superview = self.superview {
            let pointInWindow = self.convert(point, to: superview)
            let contains = self.frame.contains(pointInWindow)
            if contains && self.isUserInteractionEnabled {
                return self
            }
        }
        return nil
    }
}

// MARK: - Toast Controller
class VToastVC: UIViewController {
    var toast : JTValidationToast?
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13, *) {
            return .darkContent
        } else {
            return .default
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    override var preferredStatusBarUpdateAnimation : UIStatusBarAnimation {
        return  .none
    }
    
    // Toast dismiss controller
    func dismissToast(block :(( _ success:Bool) ->())? = nil){
        if let atoast = toast{
            atoast.animateOut(duration: 0.2, delay: 1.5, completion: { (completed) -> () in
                atoast.removeFromSuperview()
                block?(true)
                self.dismiss(animated: false, completion: nil)
            })
        }else{
            block?(true)
            self.dismiss(animated: false, completion: nil)
        }
    }
}


// MARK: - ToastWindow

open class ToastWindow: UIWindow {
    
    //    public static let shared = ToastWindow(frame: UIScreen.main.bounds)
    
    /// Will not return `rootViewController` while this value is `true`. Or the rotation will be fucked in iOS 9.
    var isStatusBarOrientationChanging = false
    
    /// Don't rotate manually if the application:
    ///
    /// - is running on iPad
    /// - is running on iOS 9
    /// - supports all orientations
    /// - doesn't require full screen
    /// - has launch storyboard
    ///
    var shouldRotateManually: Bool {
        let iPad = UIDevice.current.userInterfaceIdiom == .pad
        let application = UIApplication.shared
        let window = application.delegate?.window ?? nil
        let supportsAllOrientations = application.supportedInterfaceOrientations(for: window) == .all
        
        let info = Bundle.main.infoDictionary
        let requiresFullScreen = (info?["UIRequiresFullScreen"] as? NSNumber)?.boolValue == true
        let hasLaunchStoryboard = info?["UILaunchStoryboardName"] != nil
        
        if #available(iOS 9, *), iPad && supportsAllOrientations && !requiresFullScreen && hasLaunchStoryboard {
            return false
        }
        return true
    }
    
    override open var rootViewController: UIViewController? {
        get {
            guard !self.isStatusBarOrientationChanging else { return nil }
            guard let firstWindow = UIApplication.shared.delegate?.window else { return nil }
            return firstWindow is ToastWindow ? nil : firstWindow?.rootViewController
        }
        set { /* Do nothing */ }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.isUserInteractionEnabled = false
        self.windowLevel = UIWindow.Level.normal + 1
        #if swift(>=4.2)
        let didBecomeVisibleName = UIWindow.didBecomeVisibleNotification
        let willChangeStatusBarOrientationName = UIApplication.willChangeStatusBarOrientationNotification
        let didChangeStatusBarOrientationName = UIApplication.didChangeStatusBarOrientationNotification
        let didBecomeActiveName = UIApplication.didBecomeActiveNotification
        #else
        let didBecomeVisibleName = NSNotification.Name.UIWindowDidBecomeVisible
        let willChangeStatusBarOrientationName = NSNotification.Name.UIApplicationWillChangeStatusBarOrientation
        let didChangeStatusBarOrientationName = NSNotification.Name.UIApplicationDidChangeStatusBarOrientation
        let didBecomeActiveName = NSNotification.Name.UIApplicationDidBecomeActive
        #endif
        self.backgroundColor = .clear
        self.isHidden = false
        self.handleRotate(UIApplication.shared.statusBarOrientation)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.bringWindowToTop),
            name: didBecomeVisibleName,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.statusBarOrientationWillChange),
            name: willChangeStatusBarOrientationName,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.statusBarOrientationDidChange),
            name: didChangeStatusBarOrientationName,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.applicationDidBecomeActive),
            name: didBecomeActiveName,
            object: nil
        )
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented: please use ToastWindow.shared")
    }
    
    /// Bring ToastWindow to top when another window is being shown.
    @objc func bringWindowToTop(_ notification: Notification) {
        if !(notification.object is ToastWindow) {
            self.isHidden = true
            self.isHidden = false
        }
    }
    
    @objc dynamic func statusBarOrientationWillChange() {
        self.isStatusBarOrientationChanging = true
    }
    
    @objc dynamic func statusBarOrientationDidChange() {
        let orientation = UIApplication.shared.statusBarOrientation
        self.handleRotate(orientation)
        self.isStatusBarOrientationChanging = false
    }
    
    @objc func applicationDidBecomeActive() {
        let orientation = UIApplication.shared.statusBarOrientation
        self.handleRotate(orientation)
    }
    
    func handleRotate(_ orientation: UIInterfaceOrientation) {
        let angle = self.angleForOrientation(orientation)
        if self.shouldRotateManually {
            self.transform = CGAffineTransform(rotationAngle: CGFloat(angle))
        }
        
        if let window = UIApplication.shared.windows.first {
            if orientation.isPortrait || !self.shouldRotateManually {
                self.frame.size.width = window.bounds.size.width
                self.frame.size.height = window.bounds.size.height
            } else {
                self.frame.size.width = window.bounds.size.height
                self.frame.size.height = window.bounds.size.width
            }
        }
        
        self.frame.origin = .zero
        DispatchQueue.main.async {
            self.subviews.forEach({ (obj) in
                if let vc = obj as? JTValidationToast{
                    vc.setNeedsLayout()
                }
            })
        }
    }
    
    func angleForOrientation(_ orientation: UIInterfaceOrientation) -> Double {
        switch orientation {
        case .landscapeLeft: return -.pi / 2
        case .landscapeRight: return .pi / 2
        case .portraitUpsideDown: return .pi
        default: return 0
        }
    }
    
}

