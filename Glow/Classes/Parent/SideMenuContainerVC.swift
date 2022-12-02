//
//  SideMenuContainerVC.swift
//  DUCE
//
//  Created by Devang on 1/29/21.
//  Copyright © 2021 Devang Lakhani. All rights reserved.
//

import UIKit

//MARK: Point
/**
 *This class use for get center point of menu ,screen
 */
class Point {
    static var centerPoint = CGPoint()
}
//MARK: SlideAction
/**
 * Slide Menu Action Open & close
 */
public enum SlideAction {
    case open
    case close
}

//MARK: SlideAnimationStyle
/**
 *This class use Slide open animation style
 */
public enum SlideAnimationStyle {
    case style1
    case style2
}

public struct SlideMenuOptions {
    public static var animationStyle: SlideAnimationStyle = .style1
    
    public static var screenFrame     = UIScreen.main.bounds
    public static var panVelocity : CGFloat = 800
    public static var panAnimationDuration : TimeInterval = 0.35
    
    public static var pending = UIDevice.current.userInterfaceIdiom == .pad ? screenFrame.size.width/2.5 : 100.0
    public static var thresholdTrailSpace : CGFloat =  UIScreen.main.bounds.width + pending
    public static var thresholdLedSpace : CGFloat =  UIScreen.main.bounds.width - pending
    public static var panGesturesEnabled: Bool = true
    public static var tapGesturesEnabled: Bool = true
}


class SideMenuContainerVC: ParentViewController {

    @IBOutlet weak var menuContainer: UIView!
    @IBOutlet weak var mainContainer: UIView!
    
    @IBOutlet weak var topConst: NSLayoutConstraint!
    @IBOutlet weak var mainContainerTrailSpace: NSLayoutConstraint!
    @IBOutlet weak var mainContainerLedSpace: NSLayoutConstraint!
    
    @IBOutlet weak var menuContainerTrailSpace: NSLayoutConstraint!
    @IBOutlet weak var menuContainerLedSpace: NSLayoutConstraint!
    
    // MARK: Variables
    var transparentView = UIControl()
    var tabbar : UITabBarController!
    var menuActionType: SlideAction = .close
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareConstraintUpdate()
        prepareTableViewUI()
        prepareSlideMenuUI()
    }
}

extension SideMenuContainerVC {
    
    func prepareConstraintUpdate(){
        if SlideMenuOptions.animationStyle == .style1 {
            menuContainerLedSpace.constant =  SlideMenuOptions.screenFrame.width
            menuContainerTrailSpace.constant =  -SlideMenuOptions.thresholdLedSpace
            self.view.bringSubviewToFront(menuContainer)
        }else{
            menuContainerTrailSpace.constant = SlideMenuOptions.pending
            menuContainerLedSpace.constant = 0
            self.view.bringSubviewToFront(mainContainer)
            mainContainer.layer.shadowColor = UIColor.black.cgColor
            mainContainer.layer.shadowOpacity = 0.6
            mainContainer.layer.shadowOffset = CGSize(width: 0, height: 2)
        }
    }
    
    func prepareTableViewUI() {
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.tableFooterView = UIView()
        topConst.constant = _statusBarHeight
    }
}

//MARK: - Slider Menu UI
extension SideMenuContainerVC {
    
    func prepareSlideMenuUI() {
        // Pan Gesture Recognizer code
        let corner :UIScreenEdgePanGestureRecognizer = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(SideMenuContainerVC.swipePanAction(gestureRecognizer:)))
        corner.edges = UIRectEdge.left
        mainContainer.addGestureRecognizer(corner)
        
        //transparentView Code
        addTransparentControlUI()
    }
    func addTransparentControlUI() {
        transparentView =  UIControl()
        transparentView.alpha = 0
        transparentView.isHidden = true
        transparentView.addTarget(self, action: #selector(ParentViewController.shutterAction(_:)), for: UIControl.Event.touchUpInside)
        
        
        if SlideMenuOptions.animationStyle == .style1{
            transparentView.frame =  CGRect(x: 0, y: 0, width: SlideMenuOptions.screenFrame.width, height: SlideMenuOptions.screenFrame.height)
            transparentView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
            self.view.addSubview(self.transparentView)
            self.view.bringSubviewToFront(menuContainer)
        }else{
            transparentView.frame =  CGRect(x: SlideMenuOptions.thresholdLedSpace, y: 0, width: SlideMenuOptions.pending, height: SlideMenuOptions.screenFrame.height)
            transparentView.backgroundColor =   UIColor.clear
            self.view.addSubview(self.transparentView)
        }
    }
}

//MARK: - UIGesture
extension SideMenuContainerVC {
    
    func animatedDrawerEffect() {
        if let container = self.findContainerController(){
            if menuActionType == .close
            {
                container.panMenuOpen()
            }else
            {
                container.panMenuClose()
            }
        }
    }
    
    func menuContainerClose(_ animatedView: UIView) {
        if let container = self.findContainerController(){
            menuActionType = .close
            if SlideMenuOptions.animationStyle == .style1{
                container.menuContainerLedSpace.constant = SlideMenuOptions.screenFrame.width
                container.menuContainerTrailSpace.constant   = -SlideMenuOptions.thresholdLedSpace
            }else{
                container.mainContainerTrailSpace.constant = 0
                container.mainContainerLedSpace.constant = 0
            }
            
            UIView.animate(withDuration: SlideMenuOptions.panAnimationDuration, animations: { () -> Void in
                container.tableView.isUserInteractionEnabled = false
                self.transparentView.isEnabled = false
                self.transparentView.alpha = 0
                container.view.layoutIfNeeded()
                
            }, completion: { (finished) -> Void in
                self.transparentView.isHidden = true
                self.transparentView.isEnabled = true
                container.tableView.isUserInteractionEnabled = true
            })
            
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOfGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    //MARK: - Swipe Getsure code
    
    @objc func swipePanAction(gestureRecognizer: UIScreenEdgePanGestureRecognizer) {
        if !SlideMenuOptions.panGesturesEnabled{
            return
        }
        
        if let navCon: UINavigationController = self.tabbar!.selectedViewController as? UINavigationController{
            if navCon.viewControllers.count != 1 {
                return
            }
        }
        let centerPoint = Point.centerPoint
        
        
        switch gestureRecognizer.state {
        case .began:
            Point.centerPoint = self.mainContainer.center
            break
            
        case .changed:
            let translation: CGPoint = gestureRecognizer.translation(in: self.view)
            moveContainerOnGesture(x: centerPoint.x, translation: translation)
            break
            
        case .ended,.failed,.cancelled:
            let translation: CGPoint = gestureRecognizer.translation(in: self.view)
            let vel: CGPoint = gestureRecognizer.velocity(in: self.view)
            let halfWidth = SlideMenuOptions.screenFrame.width / 2
            self.view.endEditing(true)
            //  recognizer has received touches recognized as the end of the gesture base on menu close/open
            if vel.x > SlideMenuOptions.panVelocity{
                self.panMenuOpen()
            }else if vel.x < -SlideMenuOptions.panVelocity{
                self.panMenuClose()
            }else if  translation.x > halfWidth{
                self.panMenuOpen()
            }else{
                self.panMenuClose()
            }
            
            break
        default:
            break
        }
    }
    //  MenuContainer/MainContainer Constraint update base on moment action
    
    func moveContainerOnGesture(x:CGFloat,translation: CGPoint){
        let ctPoint = (x + translation.x)
        
        let halfWidth = SlideMenuOptions.screenFrame.width / 2
        if ctPoint >= halfWidth {
            if ctPoint - halfWidth > SlideMenuOptions.thresholdLedSpace {
                //Menu Screen rech maximum to open
                if SlideMenuOptions.animationStyle == .style1{
                    if menuContainerTrailSpace.constant != 0
                    {
                        self.menuContainerLedSpace.constant = SlideMenuOptions.pending
                        self.menuContainerTrailSpace.constant = 0
                        transparentViewAnimation(x: translation.x)
                        self.view.layoutIfNeeded()
                    }
                }else{
                    if mainContainerLedSpace.constant != SlideMenuOptions.thresholdLedSpace
                    {
                        mainContainerTrailSpace.constant = -SlideMenuOptions.thresholdLedSpace;
                        mainContainerLedSpace.constant = SlideMenuOptions.thresholdLedSpace;
                        menuSlideAnimation(x: translation.x)
                        transparentViewAnimation(x: translation.x)
                        self.view.layoutIfNeeded()
                    }
                }
                
            }else {
                if SlideMenuOptions.animationStyle == .style1{
                    self.menuContainerTrailSpace.constant =   (ctPoint - halfWidth) - SlideMenuOptions.screenFrame.width + SlideMenuOptions.pending
                    self.menuContainerLedSpace.constant =  SlideMenuOptions.screenFrame.width - (ctPoint - halfWidth)
                    transparentViewAnimation(x: translation.x)
                    
                }else{
                    self.mainContainerTrailSpace.constant = -translation.x
                    self.mainContainerLedSpace.constant = translation.x
                    menuSlideAnimation(x: translation.x)
                    transparentViewAnimation(x: translation.x)
                }
                self.view.layoutIfNeeded()
                
            }
            
        }
    }
    
    //  recognizer has received touches recognized as the end of the gesture base on menu close method
    
    func panMenuClose() {
        menuActionType = .close
        if SlideMenuOptions.animationStyle == .style1{
            menuContainerLedSpace.constant = SlideMenuOptions.screenFrame.width
            menuContainerTrailSpace.constant   = -SlideMenuOptions.thresholdLedSpace
        }else{
            mainContainerTrailSpace.constant = 0
            mainContainerLedSpace.constant = 0
            menuSlideAnimation(x: SlideMenuOptions.pending,isAnimate: false)
        }
        
        UIView.animate(withDuration: SlideMenuOptions.panAnimationDuration, animations: { () -> Void in
            self.transparentView.isEnabled = false
            self.tableView.isUserInteractionEnabled = false
            
            self.transparentView.alpha = 0
            self.view.layoutIfNeeded()
            
        }, completion: { (finished) -> Void in
            self.transparentView.isHidden = true
            self.transparentView.isEnabled = true
            self.tableView.isUserInteractionEnabled = true
        })
    }
    //  recognizer has received touches recognized as the end of the gesture base on menu open method
    
    func panMenuOpen() {
        menuActionType = .open
        
        if SlideMenuOptions.animationStyle == .style1{
            menuContainerLedSpace.constant = SlideMenuOptions.pending
            menuContainerTrailSpace.constant = 0
            
        }else{
            mainContainerTrailSpace.constant = -SlideMenuOptions.thresholdLedSpace
            mainContainerLedSpace.constant = SlideMenuOptions.thresholdLedSpace
            menuSlideAnimation(x: SlideMenuOptions.screenFrame.width,isAnimate: false)
        }
        self.transparentView.isHidden = false
        
        UIView.animate(withDuration: SlideMenuOptions.panAnimationDuration, animations: { () -> Void in
            self.transparentView.isEnabled = false
            self.tableView.isUserInteractionEnabled = false
            
            self.transparentView.alpha = 1
            self.view.layoutIfNeeded()
            
        }, completion: { (finished) -> Void in
            self.tableView.isUserInteractionEnabled = true
            
            self.transparentView.isEnabled = true
        })
    }
    
    //MARK: -  animation method
    //  Menu slide animation with user touch moment code
    
    func menuSlideAnimation(x: CGFloat,isAnimate:Bool = true){
        let progress: CGFloat = (x)/SlideMenuOptions.thresholdLedSpace
        let slideMovement : CGFloat = 100
        var location :CGFloat = (slideMovement * -1) + (slideMovement * progress)
        location = location > 0 ? 0 : location
        self.menuContainerLedSpace.constant = location
        self.menuContainerTrailSpace.constant =  abs(location) + SlideMenuOptions.pending
        if isAnimate{
            UIView.animate(withDuration: 0.1) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    //  Transparent view alpha animation with user touch moment code
    func transparentViewAnimation(x: CGFloat){
        let progress: CGFloat = (x)/SlideMenuOptions.thresholdLedSpace
        self.transparentView.isHidden = false
        
        UIView.animate(withDuration: 0.1) {
            self.transparentView.alpha = progress
        }
    }
    
}

//MARK:- UITableView DataSource & Delegate

extension  SideMenuContainerVC {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55.widthRatio
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MenuItemCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

class MenuItemCell: UITableViewCell {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
