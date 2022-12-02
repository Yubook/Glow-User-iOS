//
//  BookingHistoryCell.swift
//  Fade
//
//  Created by Devang Lakhani  on 5/6/21.
//  Copyright © 2021 Devang Lakhani. All rights reserved.
//

import UIKit
import Cosmos

class BookingHistoryCell: UITableViewCell {
    @IBOutlet weak var imgProfileView : UIImageView!
    @IBOutlet weak var lblDriverName : UILabel!
    @IBOutlet weak var lblDriverService : UILabel!
    @IBOutlet weak var lblBookedService : UILabel!
    @IBOutlet weak var lblCost : UILabel!
    @IBOutlet weak var lblDate : UILabel!
    @IBOutlet weak var ratingView : CosmosView!
    @IBOutlet weak var lbltotalReviews : UILabel!
    @IBOutlet weak var lblStatus : UILabel!
    @IBOutlet weak var btnAddReview : UIButton!
    
    func prepareOrders(data: PreviousBooking){
        btnAddReview.backgroundColor = data.arrReviews.isEmpty ? #colorLiteral(red: 0.1333333333, green: 0.137254902, blue: 0.1529411765, alpha: 1) : #colorLiteral(red: 0.8242617846, green: 0.8242812753, blue: 0.8242707849, alpha: 0.8470588235)
        ratingView.isUserInteractionEnabled = false
        if data.orderStatus == .completed{
            lblStatus.text = "Completed"
            btnAddReview.isEnabled = true
            btnAddReview.isUserInteractionEnabled = true
            btnAddReview.backgroundColor = #colorLiteral(red: 0.1333333333, green: 0.137254902, blue: 0.1529411765, alpha: 1)
        }else if data.orderStatus  == .cancel {
            btnAddReview.isEnabled = false
            btnAddReview.isUserInteractionEnabled = false
            btnAddReview.backgroundColor = #colorLiteral(red: 0.8242617846, green: 0.8242812753, blue: 0.8242707849, alpha: 0.8470588235)
            lblStatus.text = "Cancelled"
        }
        lblCost.text = "£\(data.totalPay)"
        var serviceList : String{
            let strService = data.arrBarberServices.map{$0.serviceName}.filter{!$0.isEmpty}.joined(separator: ",")
            return strService
        }
        lblDriverService.text = serviceList
        lblBookedService.text = serviceList
        if let driverData = data.users{
            imgProfileView.kf.setImage(with: driverData.profileUrl)
            lblDriverName.text = driverData.name
            ratingView.rating = Double(driverData.avgRating) ?? 1.0
            lbltotalReviews.text = "Reviews \(driverData.totalRating)"
        }
        if !data.arrBarberServices.isEmpty{
            let serviceFirst = data.arrBarberServices.first!
            lblDate.text = serviceFirst.strDate + convertFormat(time: serviceFirst.slotTime)
        }
    }
}

extension BookingHistoryCell{
    func convertFormat(time: String) -> String{
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "HH:mm"
        let showDate = inputFormatter.date(from: time)
        inputFormatter.dateFormat = "HH:mm a"
        let resultString = inputFormatter.string(from: showDate!)
        return resultString
    }
}
