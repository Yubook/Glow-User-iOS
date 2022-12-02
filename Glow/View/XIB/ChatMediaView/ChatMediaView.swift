//
//  ChatMediaView.swift
//  Simpilli
//
//  Created by Hitesh Khunt on 25/01/21.
//  Copyright © 2021 Hitesh Khunt. All rights reserved.
//

import UIKit

class ChatMediaView: UIView {

    @IBOutlet weak var mediaView: UIView!
    
    var selectedIndex: (Int) ->Void = {_  in}
    
    override func layoutSubviews() {
        super.layoutSubviews()
        mediaView.roundCorners(corners: [.topRight, .bottomLeft], radius: 15.0)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            if touch.view != self.mediaView {
                self.animateOut()
            }
        }
    }
    
    class func instantiateView(with view: UIView) -> ChatMediaView {
        let objView = Bundle.main.loadNibNamed("ChatMediaView", owner: self, options: nil)?.first as! ChatMediaView
        view.addSubview(objView)
        objView.addConstraintToSuperView(lead: 0, trail: 0, top: 0, bottom: -(_bottomAreaSpacing + 64))
        objView.layoutIfNeeded()
        objView.animateIn()
        return objView
    }
    
    func getSelectedIndex(completion: @escaping(Int) -> ()) {
        self.selectedIndex = completion
    }
    
    func animateIn() {
        alpha = 0
        UIView.animate(withDuration: 0.25, animations: {
            self.alpha = 1
        }) { (success) in
            
        }
    }
    
    func animateOut() {
        UIView.animate(withDuration: 0.25, animations: {
            self.alpha = 0
        }) { (success) in
            self.removeFromSuperview()
        }
    }
    
    @IBAction func btnSelectMediaTapped (_ sender: UIButton) {
        let tag = sender.tag
        self.selectedIndex(tag)
        self.animateOut()
    }
}
