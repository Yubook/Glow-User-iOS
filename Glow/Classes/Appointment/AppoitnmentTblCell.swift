//
//  AppoitnmentTblCell.swift
//  Fade
//
//  Created by Devang Lakhani  on 4/13/21.
//  Copyright © 2021 Devang Lakhani. All rights reserved.
//

import UIKit
import Cosmos

class AppoitnmentTblCell: UITableViewCell {
    @IBOutlet weak var imgProfileView : UIImageView!
    @IBOutlet weak var lblDriverName : UILabel!
    @IBOutlet weak var lblDriverService : UILabel!
    @IBOutlet weak var lblBookedService : UILabel!
    @IBOutlet weak var lblCost : UILabel!
    @IBOutlet weak var lblDate : UILabel!
    @IBOutlet weak var ratingView : CosmosView!
    @IBOutlet weak var lbltotalReviews : UILabel!
    @IBOutlet weak var btnCancal : UIButton!
    
    weak var parent : AppointmentVC!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
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

extension AppoitnmentTblCell{
    func currentCell(current : PreviousBooking){
        ratingView.isUserInteractionEnabled = false
        imgProfileView.contentMode = .scaleAspectFill
        if parent.cellType == .previousCell{
            btnCancal.isEnabled = false
            btnCancal.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        }else {
            btnCancal.setTitle("Cancel Booking", for: .normal)
            btnCancal.isEnabled = true
            btnCancal.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }
        btnCancal.setTitle("Cancel Booking", for: .normal)
        lblCost.text = "£\(current.totalPay)"
        if let user = current.users{
            lblDriverName.text = user.name
            imgProfileView.kf.setImage(with: user.profileUrl)
            ratingView.rating = Double(user.avgRating) ?? 0.0
            lbltotalReviews.text = "Review " + user.totalRating
        }
        var serviceList : String{
            let strService = current.arrBarberServices.map{$0.serviceName}.filter{!$0.isEmpty}.joined(separator: ",")
            return strService
        }
        lblDriverService.text = serviceList
        lblBookedService.text = serviceList
        if !current.arrBarberServices.isEmpty{
            let serviceFirst = current.arrBarberServices.first!
            lblDate.text = serviceFirst.strDate + convertFormat(time: serviceFirst.slotTime)
        }
    }
    
    func prepareOtherCell(data: PreviousBooking){
        if parent.cellType == .previousCell{
            btnCancal.isEnabled = false
            btnCancal.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        }else{
            btnCancal.isEnabled = true
            btnCancal.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }
        ratingView.isUserInteractionEnabled = false
        imgProfileView.contentMode = .scaleAspectFill
        btnCancal.setTitle("Cancel Booking", for: .normal)
        lblCost.text = "£\(data.totalPay)"
        if let user = data.users{
            lblDriverName.text = user.name
            imgProfileView.kf.setImage(with: user.profileUrl)
            ratingView.rating = Double(user.avgRating) ?? 0.0
            lbltotalReviews.text = "Review " + user.totalRating
        }
        var serviceList : String{
            let strService = data.arrBarberServices.map{$0.serviceName}.filter{!$0.isEmpty}.joined(separator: ",")
            return strService
        }
        lblDriverService.text = serviceList
        lblBookedService.text = serviceList
        if !data.arrBarberServices.isEmpty{
            let serviceFirst = data.arrBarberServices.first!
            lblDate.text = serviceFirst.strDate + convertFormat(time: serviceFirst.slotTime)
        }
    }
}


