//
//  MessagesTblCell.swift
//  Fade
//
//  Created by Devang Lakhani  on 4/14/21.
//  Copyright © 2021 Devang Lakhani. All rights reserved.
//

import UIKit

class MessagesTblCell: UITableViewCell {
    @IBOutlet weak var lblMessage : UILabel!
    @IBOutlet weak var imgView : UIImageView!
    @IBOutlet weak var lblDate : UILabel!
    @IBOutlet weak var lblMsgTime : UILabel!
    @IBOutlet weak var btnView : UIButton!
    @IBOutlet weak var viewTest : UIView!
    @IBOutlet weak var btnDelete : UIButton!
    
    weak var parent : MessagesListVC!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
