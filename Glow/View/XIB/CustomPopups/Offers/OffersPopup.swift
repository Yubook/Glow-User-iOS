//
//  OffersPopup.swift
//  Fade
//
//  Created by Devang Lakhani  on 4/9/21.
//  Copyright © 2021 Devang Lakhani. All rights reserved.
//

import UIKit

class OffersPopup: UIViewController {
    
    @IBOutlet weak var lblPrice : UILabel!
    @IBOutlet weak var lblDescription : UILabel!
    
    enum Tapped{
        case cancel,done
    }
    var actionBlock : ((_ tapped : Tapped) -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //prepareHexa()
    }
    
    
    func handleTappedAction(block: @escaping (Tapped) -> ()){
        actionBlock = block
    }
}

//MARK:- Setup Hexagone View
extension OffersPopup{
   /* func prepareHexa(){
        let maskPath = UIBezierPath(square: hexaView.bounds, numberOfSides: 6, cornerRadius: 8.0)
        
        let maskingLayer = CAShapeLayer()
        maskingLayer.path = maskPath?.cgPath
        
        maskingLayer.lineWidth = 2.0
        maskingLayer.strokeColor = UIColor.black.cgColor
        maskingLayer.fillColor = UIColor.clear.cgColor
        maskingLayer.frame = hexaView.bounds
        hexaView.layer.addSublayer(maskingLayer)
    } */
}

//MARK:- Action Methods
extension OffersPopup{
    @IBAction func btnReedemCancelTapped(_ sender : UIButton){
        
        sender.tag == 0 ? actionBlock?(.cancel) : actionBlock?(.done)
    }
}
