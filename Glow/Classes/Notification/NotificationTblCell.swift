//
//  NotificationTblCell.swift
//  Fade
//
//  Created by Devang Lakhani  on 4/13/21.
//  Copyright © 2021 Devang Lakhani. All rights reserved.
//

import UIKit

class NotificationTblCell: UITableViewCell {
    
    @IBOutlet weak var lblDescription : UILabel!
    @IBOutlet weak var lblTimeDate : UILabel!

    
    func prepareCell(data: NotificationList){
        lblDescription.text = data.message
        lblTimeDate.text = data.strTime
    }

}
