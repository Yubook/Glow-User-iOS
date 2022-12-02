//
//  AppoitnmentBookCollCell.swift
//  Fade
//
//  Created by Devang Lakhani  on 4/12/21.
//  Copyright © 2021 Devang Lakhani. All rights reserved.
//

import UIKit

class AppoitnmentBookCollCell: UICollectionViewCell {
    
    @IBOutlet weak var lblTime : UILabel!
    @IBOutlet weak var bView : UIView!
    weak var parent : AppointmentBookingVC!
    
    
    func prepareCell(data : AppotnmentBooking){
        if let timeSlot = data.timeSlots{
            let timeDate = data.strSlotDate + " " + parent.getSubStringTime(time: timeSlot.time)
            let timeDate1 = parent.getTimeAndDate()
            lblTime.text = timeSlot.time
            bView.backgroundColor = data.isSelected ?  #colorLiteral(red: 0.1333333333, green: 0.137254902, blue: 0.1529411765, alpha: 1) : #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            lblTime.textColor = data.isSelected ? .white : .black
            if data.isBooked || timeDate < timeDate1{
                self.isSelected = false
                bView.backgroundColor = #colorLiteral(red: 0.1333333333, green: 0.137254902, blue: 0.1529411765, alpha: 0.2)
            }
        }
    }
}
