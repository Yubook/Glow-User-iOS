//
//  SelectServicesVC.swift
//  Fade
//
//  Created by Devang Lakhani  on 4/21/21.
//  Copyright © 2021 Devang Lakhani. All rights reserved.
//

import UIKit

class SelectServicesVC: ParentViewController {
    @IBOutlet weak var lblServiceName: UILabel!
    @IBOutlet weak var lblPrice : UILabel!
    var objData : SelectServices!
    var arrDriversDetails : [NearestDriver] = []
    var arrAppoitnmentSlots : [AppotnmentBooking] = []
    var objWalletDetails : Wallet?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUI()
    }
}

//MARK:- Others Methods
extension SelectServicesVC{
    func prepareUI(){
        getServices()
    }
    
    @IBAction func btnConfirmTapped(_ sender: UIButton){
        self.performSegue(withIdentifier: "paymentDetails", sender: (arrAppoitnmentSlots,arrDriversDetails,objData,objWalletDetails))
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "paymentDetails"{
            let vc = segue.destination as! PaymentDetailsVC
            
            if let data = sender as? ([AppotnmentBooking],[NearestDriver],SelectServices,Wallet){
                vc.arrSlotData = data.0
                vc.arrDriverData = data.1
                vc.bookedService = data.2
                vc.objWallet = data.3
            }
        }
    }
}


//MARK:- WebCall Methods
extension SelectServicesVC{
    func getServices(){
        showHud()
        KPWebCall.call.getServiceList {[weak self] (json, statusCode) in
            guard let weakSelf = self else {return}
            weakSelf.hideHud()
            if statusCode == 200, let dict = json as? NSDictionary, let result = dict["result"] as? [NSDictionary]{
                for res in result{
                    weakSelf.objData = SelectServices(dict: res)
                    weakSelf.lblServiceName.text = weakSelf.objData.serviceName
                    weakSelf.lblPrice.text = "£ " + weakSelf.objData.servicePrice
                }
            }else{
                weakSelf.showError(data: json, view: weakSelf.view)
            }
        }
    }
}
