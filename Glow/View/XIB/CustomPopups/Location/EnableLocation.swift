//
//  EnableLocation.swift
//  Fade
//
//  Created by Devang Lakhani  on 4/10/21.
//  Copyright © 2021 Devang Lakhani. All rights reserved.
//

import UIKit

class EnableLocation: UIViewController {
    @IBOutlet weak var hexaView : UIView!
    @IBOutlet weak var lblDescription : UILabel!
    @IBOutlet weak var imgIcon : UIImageView!
    @IBOutlet weak var lblTitle : UILabel!
    
    
    var actionBlock : ((_ tap : Tapped) -> ())?
    enum Tapped{
        case done
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let maskPath = UIBezierPath(square: hexaView.bounds, numberOfSides: 6, cornerRadius: 8.0)

          let maskingLayer = CAShapeLayer()
          maskingLayer.path = maskPath?.cgPath
        
          maskingLayer.lineWidth = 2.0
          maskingLayer.strokeColor = UIColor.black.cgColor
          maskingLayer.fillColor = UIColor.clear.cgColor
          maskingLayer.frame = hexaView.bounds
          hexaView.layer.addSublayer(maskingLayer)
    }
    
    func handleTappedAction(block: @escaping (Tapped) -> ()){
           actionBlock = block
    }
}

//MARK:- Action Methods
extension EnableLocation{
    @IBAction func btnDoneTapped(_ sender: UIButton){
        self.actionBlock?(.done)
    }
}
