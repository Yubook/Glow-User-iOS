//
//  KPNavigationViewController.swift
//  SnapTag
//
//  Created by iOS Development Company on 19/04/16.
//  Copyright © 2016 iOS Development Company All rights reserved.
//

import UIKit

class KPNavigationViewController: UINavigationController, UIGestureRecognizerDelegate, UINavigationControllerDelegate, UIViewControllerTransitioningDelegate {
    
    let swipeInteractionController = SwipeInteractionController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        weak var weakSelf: KPNavigationViewController? = self
        self.hidesBarsOnTap = false
        self.hidesBarsOnSwipe = false
        self.hidesBarsWhenKeyboardAppears = false
        self.interactivePopGestureRecognizer?.delegate = weakSelf!
        self.delegate = weakSelf!
        self.isNavigationBarHidden = true
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool{
        if self.viewControllers.count > 1{
            return true
        }else{
            return false
        }
    }
    
   /* func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if viewController is HomeVC || viewController is Settings{
            
        }else{
            swipeInteractionController.wireToViewController(viewController)
        }
    }*/
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
//        if viewController is LoginVC || viewController is SlideMenuContainerVC {
//            self.interactivePopGestureRecognizer!.isEnabled = false
//        } else {
//            self.interactivePopGestureRecognizer!.isEnabled = true
//        }
    }
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return nil
    }

    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return swipeInteractionController.interactionInProgress ? swipeInteractionController : nil
    }
}

class Push:NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return _vcTransitionTime
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let toVC = transitionContext.viewController(forKey: .to)
        transitionContext.containerView.addSubview(toVC!.view)
        
        if toVC?.view.layer.shadowPath == nil {
            self.applyShadow(view: toVC?.view)
        }
        
        toVC?.view.frame.origin = CGPoint(x: _screenSize.width, y: 0)//transitionContext.containerView.frame
        UIView.animate(withDuration: self.transitionDuration(using: transitionContext), animations: {
            toVC?.view.frame.origin = CGPoint(x: 0, y: 0)
        }) { (finish) in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
    
    func applyShadow(view: UIView?) {
        view?.layer.masksToBounds = false
        view?.layer.shadowColor = UIColor.black.cgColor
        view?.layer.shadowOpacity = 0.15
        view?.layer.shadowOffset = CGSize.zero//CGSize(width: -2, height: _statusBarHeight)
        view?.layer.shadowRadius = 2.5
        let shadowRect = CGRect(x: -2.5, y: _statusBarHeight, width: 5, height: _screenSize.height)
        view?.layer.shadowPath = UIBezierPath(rect: shadowRect).cgPath
    }
}


class PushLeft:NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return _vcTransitionTime
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let toVC = transitionContext.viewController(forKey: .to)
        transitionContext.containerView.addSubview(toVC!.view)
        
        if toVC?.view.layer.shadowPath == nil {
            self.applyShadow(view: toVC?.view)
        }
        
        toVC?.view.frame.origin = CGPoint(x: -_screenSize.width, y: 0)//transitionContext.containerView.frame
        UIView.animate(withDuration: self.transitionDuration(using: transitionContext), animations: {
            toVC?.view.frame.origin = CGPoint(x: 0, y: 0)
        }) { (finish) in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
    
    func applyShadow(view: UIView?) {
        view?.layer.masksToBounds = false
        view?.layer.shadowColor = UIColor.black.cgColor
        view?.layer.shadowOpacity = 0.15
        view?.layer.shadowOffset = CGSize.zero//CGSize(width: -2, height: _statusBarHeight)
        view?.layer.shadowRadius = 2.5
        let shadowRect = CGRect(x: _screenSize.width, y: _statusBarHeight, width: 2.5, height: _screenSize.height)
        view?.layer.shadowPath = UIBezierPath(rect: shadowRect).cgPath
    }
}


class Pop:NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return _vcTransitionTime
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let toVC = transitionContext.viewController(forKey: .to)
        let fromVC = transitionContext.viewController(forKey: .from)
        
        if fromVC?.view.layer.shadowPath == nil {
            self.applyShadow(view: fromVC?.view)
        }
        
        transitionContext.containerView.insertSubview(toVC!.view, belowSubview: fromVC!.view)
        fromVC?.view.frame.origin = CGPoint(x: 0, y: 0)
        UIView.animate(withDuration: self.transitionDuration(using: transitionContext), animations: {
            fromVC?.view.frame.origin = CGPoint(x: _screenSize.width, y: 0)
        }) { (finish) in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
    
    func applyShadow(view: UIView?) {
        view?.layer.masksToBounds = false
        view?.layer.shadowColor = UIColor.black.cgColor
        view?.layer.shadowOpacity = 0.1
        view?.layer.shadowOffset = CGSize.zero//CGSize(width: -2, height: _statusBarHeight)
        view?.layer.shadowRadius = 2.5
        let shadowRect = CGRect(x: -2.5, y: _statusBarHeight, width: 5, height: _screenSize.height)
        view?.layer.shadowPath = UIBezierPath(rect: shadowRect).cgPath
    }
}

class PopLeft:NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return _vcTransitionTime
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let toVC = transitionContext.viewController(forKey: .to)
        let fromVC = transitionContext.viewController(forKey: .from)
        
        if fromVC?.view.layer.shadowPath == nil {
            self.applyShadow(view: fromVC?.view)
        }
        
        transitionContext.containerView.insertSubview(toVC!.view, belowSubview: fromVC!.view)
        fromVC?.view.frame.origin = CGPoint(x: 0, y: 0)
        UIView.animate(withDuration: self.transitionDuration(using: transitionContext), animations: {
            fromVC?.view.frame.origin = CGPoint(x: -_screenSize.width, y: 0)
        }) { (finish) in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
    
    func applyShadow(view: UIView?) {
        view?.layer.masksToBounds = false
        view?.layer.shadowColor = UIColor.black.cgColor
        view?.layer.shadowOpacity = 0.1
        view?.layer.shadowOffset = CGSize.zero//CGSize(width: -2, height: _statusBarHeight)
        view?.layer.shadowRadius = 2.5
        let shadowRect = CGRect(x: _screenSize.width, y: _statusBarHeight, width: 2.5, height: _screenSize.height)
        view?.layer.shadowPath = UIBezierPath(rect: shadowRect).cgPath
    }
}


class SwipeInteractionController: UIPercentDrivenInteractiveTransition {
    
    var interactionInProgress = false
    
    fileprivate var shouldCompleteTransition = false
    fileprivate var shouldCompleteTransitionViaVelocity: Bool?
    fileprivate weak var viewController: UIViewController!
    
    func wireToViewController(_ viewController: UIViewController!) {
        self.viewController = viewController
        prepareGestureRecognizerInView(viewController.view)
    }
    
    fileprivate func prepareGestureRecognizerInView(_ view: UIView) {
//        let gesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handleGesture(_:)))
//        gesture.edges = UIRectEdge.left
//        view.addGestureRecognizer(gesture)
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(handleGesture(_:)))
        view.addGestureRecognizer(gesture)
    }
    
    @objc func handleGesture(_ gestureRecognizer: UIPanGestureRecognizer) {
        
        let translation = gestureRecognizer.translation(in: gestureRecognizer.view!.superview!)
        let velo = gestureRecognizer.velocity(in: gestureRecognizer.view!.superview!)
        kprint(items: translation.x)
        kprint(items: velo.x)
        var progress: CGFloat = 0
        let point = translation.x < 0 ? 0 : translation.x
        progress = (point / _screenSize.width) //(translation.x / 100)
        if velo.x > 800 {
            shouldCompleteTransitionViaVelocity = true
        }else if velo.x < -800 {
            shouldCompleteTransitionViaVelocity = false
        }else{
            shouldCompleteTransitionViaVelocity = nil
        }

        progress = CGFloat(fminf(fmaxf(Float(progress), 0.0), 1.0))
        
        switch gestureRecognizer.state {
        case .began:
            interactionInProgress = true
            _ = viewController.navigationController?.popViewController(animated: true)
        case .changed:
            shouldCompleteTransition = progress > 0.5
            update(progress)
        case .cancelled:
            interactionInProgress = false
            cancel()
        case .ended:
            interactionInProgress = false
            if (shouldCompleteTransition && shouldCompleteTransitionViaVelocity == nil){
                update(progress)
                finish()
            }else if let value = shouldCompleteTransitionViaVelocity {
                if value{
                    update(progress)
                    finish()
                }else{
                    cancel()
                }
            }else{
                cancel()
            }
        default:
            print("Unsupported")
        }
    }
}

