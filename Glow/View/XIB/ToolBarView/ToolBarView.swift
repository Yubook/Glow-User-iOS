//
//  ToolBarView.swift
//  KRYB
//
//  Created by Yudiz Solutions on 04/06/18.
//  Copyright © 2018 Yudiz Solutions. All rights reserved.

import Foundation
import UIKit

class ToolBarView: ConstrainedView {
    @IBOutlet var btnDone: UIButton!
    
    weak var viewInput: UIView?
    
    // MARK: Variables
    enum Tapped {
        case done, cancel
    }
    var actionBlock: ((_ tapped: Tapped,_ alert: ToolBarView) -> ())?
    
    class func instantiateViewFromNib() -> ToolBarView {
        let obj = Bundle.main.loadNibNamed("ToolBarView", owner: nil, options: nil)![0] as! ToolBarView
         obj.updateDoneButtonTitle("Done")
        return obj
    }
    
    // MARK: Init
    // This will work only for two buttons (limitation)
    class func show(_ btnTitle: String? = nil) -> ToolBarView {
        let instance = instantiateViewFromNib()
        
        if let title = btnTitle{
            instance.btnDone.setTitle(title, for: .normal)
        }
        
        return instance
    }
    
    func updateDoneButtonTitle(_ btnTitle: String){
        self.btnDone.setTitle(btnTitle, for: .normal)
    }
    
    func handleTappedAction(_ block: @escaping (_ tapped: Tapped, _ alert: ToolBarView) -> ()){
        actionBlock = block
    }
}

//MARK:- Actions
extension ToolBarView{
    @IBAction func btnDoneTapped(_ sender: UIButton!) {
        actionBlock?(Tapped.done,self)
    }
    
}
