//
//  ChangeLocationTblCell.swift
//  Fade
//
//  Created by Chirag Patel on 29/09/21.
//  Copyright © 2021 Devang Lakhani. All rights reserved.
//

import UIKit

class ChangeLocationTblCell: UITableViewCell {
    @IBOutlet weak var lblTitle : UILabel!
    @IBOutlet weak var imgTitle : UIImageView!
    
    
    func prepareCellData(data: ChangeLocation){
        lblTitle.text = data.title
        imgTitle.image = data.img
    }
}
