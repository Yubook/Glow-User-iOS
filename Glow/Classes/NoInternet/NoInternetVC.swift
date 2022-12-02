//
//  NoInternetVC.swift
//  BarberDriver
//
//  Created by Chirag Patel on 17/11/21.
//  Copyright © 2021 Devang Lakhani. All rights reserved.
//

import UIKit
import Reachability

class NoInternetVC: ParentViewController {
    var nav = UINavigationController()
    let reach = try! Reachability()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        reachabilityCheck()
    }
}

//MARK:- Others Methods
extension NoInternetVC{
    @IBAction func btnTryAgainTapped(_ sender: UIButton){
        reachabilityCheck()
    }
    
    
    func reachabilityCheck(){
        DispatchQueue.main.async {
            self.reach.whenReachable = {reach in
                if reach.connection == .wifi || reach.connection == .cellular{
                    self.nav.dismiss(animated: true, completion: nil)
                    
                    print("Reachable through WiFi")
                }
            }
            self.reach.whenUnreachable = {_ in
                noInternetPage(mainVc: self, nav: self.navigationController!)
            }
            do{
                try self.reach.startNotifier()
            }catch{
                print("Not start Notifier")
            }
        }
    }
}
