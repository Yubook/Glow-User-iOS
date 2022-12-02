//
//  FilterTblCell.swift
//  Fade
//
//  Created by Chirag Patel on 12/11/21.
//  Copyright © 2021 Devang Lakhani. All rights reserved.
//

import UIKit

class FilterTblCell: UITableViewCell {
    @IBOutlet weak var lblTitle : UILabel!
    @IBOutlet weak var imgCheck : UIImageView!
    
    func prepareCell(data: FilterNew, idx: Int){
        let selectedFilter = _userDefault.bool(forKey: "selectedFilter")
        let index = _userDefault.integer(forKey: "index")
        if index == idx {
            data.isSelected = selectedFilter
        }
        
        lblTitle.text = data.name
        imgCheck.isHidden = data.isSelected ? false : true
    }

}
