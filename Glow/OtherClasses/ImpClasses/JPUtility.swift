//
//  JPUtility.swift
//  LHT
//
//  Created by Hitesh Khunt on 12/12/19.
//  Copyright © 2019 Hitesh Khunt. All rights reserved.
//

import Foundation

class JPUtility: NSObject {
    
    static let shared = JPUtility()
   
    func performOperation(_ delay: Double, block: @escaping ()->()) {
        let delayInSeconds = delay
        let delay = delayInSeconds * Double(NSEC_PER_SEC)
        let time = DispatchTime.now() + Double(Int64(delay)) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: time) {
            block()
        }
    }   
}
