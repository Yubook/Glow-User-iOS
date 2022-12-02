//
//  PaymentHistoryTblCell.swift
//  Fade
//
//  Created by Devang Lakhani  on 4/14/21.
//  Copyright © 2021 Devang Lakhani. All rights reserved.
//

import UIKit

class PaymentHistoryTblCell: UITableViewCell {
    @IBOutlet weak var lblServiceName : UILabel!
    @IBOutlet weak var lblTimeDate : UILabel!
    @IBOutlet weak var lblTotalPrice : UILabel!
    @IBOutlet weak var statusView : KPRoundView!
    @IBOutlet weak var lblStatus : UILabel!
    weak var parentVC : PaymentHistoryVC!
    
    enum EnumOrders{
        case pending
        case completed
        case cancle
        
        init(val: Int) {
            if val == 0{
                self = .pending
            }else if val == 1{
                self = .completed
            }else{
                self = .cancle
            }
        }
    }
    func prepareCell(data: TotalExpance){
        self.changeColorView(status: EnumOrders(val: data.isOrderCompleted))
        lblTotalPrice.text = "£" + data.amount
        var services : String{
            if !data.arrServices.isEmpty{
                let str = data.arrServices.map{$0.serviceName}.filter{$0.isEmpty}.joined(separator: ",")
                return str
            }else{
                return ""
            }
        }
        if !data.arrServices.isEmpty{
            let date = data.arrServices.first!.strDate
            let timeStr = convertFormat(time: data.arrServices.first!.slotTime)
            lblTimeDate.text = date + timeStr
        }
        if !data.arrServices.isEmpty{
            let service = data.arrServices.first!.serviceName
            lblServiceName.text = service
        }
       
    }
    
    func convertFormat(time: String) -> String{
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "HH:mm"
        let showDate = inputFormatter.date(from: time)
        inputFormatter.dateFormat = "HH:mm a"
        let resultString = inputFormatter.string(from: showDate!)
        return resultString
    }
    
}

//MARK:- Prepare View Methods
extension PaymentHistoryTblCell{
    func changeColorView(status : EnumOrders){
        statusView.borderWidth = 1.1
        if status == .pending{
            lblStatus.text = "PENDING"
            lblStatus.textColor = #colorLiteral(red: 1, green: 0.7568627451, blue: 0.02745098039, alpha: 1)
            statusView.borderColor = #colorLiteral(red: 1, green: 0.7568627451, blue: 0.02745098039, alpha: 1)
        }else if status == .completed{
            lblStatus.text = "COMPLETED"
            lblStatus.textColor = #colorLiteral(red: 0.2745098039, green: 0.7333333333, blue: 0.2235294118, alpha: 1)
            statusView.borderColor = #colorLiteral(red: 0.2745098039, green: 0.7333333333, blue: 0.2235294118, alpha: 1)
        }else {
            lblStatus.text = "CANCELLED"
            lblStatus.textColor = #colorLiteral(red: 1, green: 0, blue: 0, alpha: 1)
            statusView.borderColor = #colorLiteral(red: 1, green: 0, blue: 0, alpha: 1)
        }
    }
}
