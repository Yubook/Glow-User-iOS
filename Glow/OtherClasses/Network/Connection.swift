//
//  Connection.swift
//  BarberDriver
//
//  Created by Chirag Patel on 23/11/21.
//  Copyright © 2021 Devang Lakhani. All rights reserved.
//

import Foundation
import SystemConfiguration
import Reachability

class ReachabilityManager: NSObject {
   static  let shared = ReachabilityManager()  // 2. Shared instance
    
    // 3. Boolean to track network reachability
    var isNetworkAvailable : Bool {
      return reachabilityStatus != .unavailable
    }

    var reachabilityStatus: Reachability.Connection = .unavailable
    // 5. Reachability instance for Network status monitoring
    let reachability = try?Reachability()
    
    @objc func reachabilityChanged(notification: Notification) {
       let reachability = notification.object as! Reachability
       switch reachability.connection {
       case .unavailable:
       debugPrint("Network became unreachable")
       case .wifi:
       debugPrint("Network reachable through WiFi")
       case .cellular:
       debugPrint("Network reachable through Cellular Data")
       case .none:
        debugPrint("Network became unreachable")
       }
    }
    
    
    func startMonitoring() {
       NotificationCenter.default.addObserver(self,
                 selector: #selector(self.reachabilityChanged),
                 name: Notification.Name.reachabilityChanged,
                   object: reachability)
      do{
        try reachability?.startNotifier()
      } catch {
        debugPrint("Could not start reachability notifier")
      }
    }
    
    
    
    
}
