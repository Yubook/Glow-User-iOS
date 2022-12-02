//
//  CustomTabBarView.swift
//  Fade
//
//  Created by Devang Lakhani  on 4/8/21.
//  Copyright © 2021 Devang Lakhani. All rights reserved.
//

import UIKit

class CustomTabBarView: UIView {
    @IBOutlet var btnsMenu : [UIButton]!
    @IBOutlet var viewMenu: [UIView]!
    @IBOutlet weak var imgView : UIImageView!
    
    
    var completion : ((_ index : Int) -> ()) = {_ in}
    
    override func layoutSubviews() {
        super.layoutSubviews()
        roundCorners(corners: [.topLeft, .topRight], radius: 10.0)
    }
    
    class func getView() -> CustomTabBarView{
        let customTabBar = UINib(nibName: "CustomTabBarView", bundle: nil).instantiate(withOwner: self, options: nil).first as! CustomTabBarView
        customTabBar.frame = CGRect(x: 0, y: (_screenSize.height - 65) - _bottomAreaSpacing, width: _screenSize.width, height: 65 + _bottomAreaSpacing)
        customTabBar.layoutIfNeeded()
        customTabBar.selectedIndexTintColor(index: 0)
        customTabBar.imgView.kf.indicatorType = .activity
        customTabBar.imgView.contentMode = .scaleAspectFill
        customTabBar.imgView.kf.setImage(with: _user.profileUrl)
        return customTabBar
    }
    
    func getSelectedIndex(completion: @escaping(Int) -> ()){
        self.completion = completion
    }
    
    func selectedIndexTintColor(index: Int){
        for btn in btnsMenu{
            viewMenu[btn.tag].backgroundColor = btn.tag == index ? .white : .none
            btn.tintColor = btn.tag == index ? UIColor(red: 0.13, green: 0.14, blue: 0.15, alpha: 1.00) : .white
        }
    }
}


//MARK:- Button Action
extension CustomTabBarView{
    @IBAction func btnMenuTapped(_ sender: UIButton){
        self.selectedIndexTintColor(index: sender.tag)
        completion(sender.tag)
    }
}
