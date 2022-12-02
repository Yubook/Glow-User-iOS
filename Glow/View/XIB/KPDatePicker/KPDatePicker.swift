//
//  KPDataPicker.swift
//  MailM8
//
//  Created by Yudiz Solutions Pvt.Ltd. on 04/07/16.
//  Copyright © 2016 Yudiz Solutions Pvt.Ltd. All rights reserved.
//

import Foundation
import UIKit

class KPDatePicker: ConstrainedView{
    
    //MARK:- IBActions
    @IBAction func cancelTap(sender: UIButton){
        removeViewWithAnimation()
    }
    
    @IBAction func doneTap(sender: UIButton){
        selectionBlock?(datePicker.date)
        removeViewWithAnimation()
    }
    
    @IBAction func dataPickerValueChange(sender: UIDatePicker){
       //jprint(sender.date)
    }
    
    
    //MARK:- IBOutlets
    @IBOutlet var viewOverLay: UIView!
    @IBOutlet var datePicker: UIDatePicker!
    @IBOutlet var datePickerBottom: NSLayoutConstraint!
    
    //MARK:- Variables
    var selectionBlock:((_ date: Date)->())?
    
    //MARK:- View life cycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let loc = touches.first?.location(in: self)
        if let location = loc{
            if location.y < (_screenSize.height - (278 * _widthRatio)){
                removeViewWithAnimation()
            }
        }
    }
    
    //MARK:- Other
    class func instantiateViewFromNib(withView view: UIView) -> KPDatePicker {
        let obj = Bundle.main.loadNibNamed("KPDatePicker", owner: nil, options: nil)![0] as! KPDatePicker
        view.addSubview(obj)
        obj.addConstraaintsToView(view: view)
        if #available(iOS 13.4, *) {
            obj.datePicker.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
        //Animation
        obj.datePickerBottom.constant = -(278 * _widthRatio)
        obj.viewOverLay.alpha = 0.0
        obj.layoutIfNeeded()
        obj.datePickerBottom.constant = 0
        UIView.animate(withDuration: 0.2) { 
            obj.viewOverLay.alpha = 0.3
            obj.layoutIfNeeded()
        }
        return obj
    }
    
    func addConstraaintsToView(view: UIView){
        let top = NSLayoutConstraint(item: self, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1.0, constant: 0)
        let bottom = NSLayoutConstraint(item: self, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1.0, constant: 0)
        let lead = NSLayoutConstraint(item: self, attribute: NSLayoutConstraint.Attribute.leading, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.leading, multiplier: 1.0, constant: 0)
        let trail = NSLayoutConstraint(item: self, attribute: NSLayoutConstraint.Attribute.trailing, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.trailing, multiplier: 1.0, constant: 0)
        self.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraints([top,bottom,lead,trail])
    }
    
    func removeViewWithAnimation(){
        datePickerBottom.constant = -(278 * _widthRatio)
        UIView.animate(withDuration: 0.2, animations: { 
                self.layoutIfNeeded()
                self.viewOverLay.alpha = 0.0
            }) { (done) in
                self.removeFromSuperview()
        }
    }
}
