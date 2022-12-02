//
//  ChatListTblCell.swift
//  Fade
//
//  Created by Devang Lakhani  on 4/13/21.
//  Copyright © 2021 Devang Lakhani. All rights reserved.
//

import UIKit

class ChatListTblCell: UITableViewCell {
    @IBOutlet weak var statusView : UIView!
    @IBOutlet weak var imgProfileView : UIImageView!
    @IBOutlet weak var lblName : UILabel!
    @IBOutlet weak var lblLastMessage : UILabel!
    @IBOutlet weak var lblRoleName : UILabel!
    @IBOutlet weak var lblCount : UILabel!
    @IBOutlet weak var messageCounter : UIView!

    
    func prepareInboxUI(data : DriversOnChat){
        imgProfileView.kf.indicatorType = .activity
        imgProfileView.kf.setImage(with: data.profileUrl, placeholder: _placeImageUser)
        imgProfileView.layer.cornerRadius = imgProfileView.frame.height / 2
        lblName.text = data.name.capitalizingFirstLetter()
        statusView.backgroundColor = data.statusColor
        lblLastMessage.text = data.activeStatus
        messageCounter.isHidden = data.unreadCount == 0 ? true : false
        messageCounter.layer.cornerRadius = messageCounter.frame.height / 2
        lblCount.text = "\(data.unreadCount)"
    }
}
