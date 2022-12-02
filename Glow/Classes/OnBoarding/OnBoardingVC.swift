//
//  OnBoardingVC.swift
//  Fade
//
//  Created by Devang Lakhani  on 4/7/21.
//  Copyright © 2021 Devang Lakhani. All rights reserved.
//

import UIKit

class OnBoardingVC: ParentViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13, *) {
            return .darkContent
        } else {
            return .default
        }
    }
}

//MARK:- Others Methods
extension OnBoardingVC{
    @IBAction func btnStartedTapped(_ sender: UIButton){
        _appDelegator.setOnBoardingStatus(value: true)
        _appDelegator.navigateUserToHome()
    }
    
    @IBAction func btnTermsTapped(_ sender:  UIButton){
        self.performSegue(withIdentifier: "terms", sender: nil)
    }
    
    @IBAction func btnPrivacyTapped(_ sender: UIButton){
        self.performSegue(withIdentifier: "privacy", sender: nil)
    }
}
