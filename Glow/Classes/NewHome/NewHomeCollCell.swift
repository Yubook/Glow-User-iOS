//
//  NewHomeCollCell.swift
//  Fade
//
//  Created by Chirag Patel on 27/09/21.
//  Copyright © 2021 Devang Lakhani. All rights reserved.
//

import UIKit

class NewHomeCollCell: UICollectionViewCell {
    @IBOutlet weak var selectedView : KPRoundView!
    @IBOutlet weak var imgCheck : UIImageView!
    @IBOutlet weak var imgService : UIImageView!
    @IBOutlet weak var lblServiceName : UILabel!
    
    func prepareCellData(data: Services){
        lblServiceName.text = data.name.capitalizingFirstLetter()
        imgService.kf.setImage(with: data.imgUrl)
        selectedView.cornerRadious = 10
        if data.isSelected{
            selectedView.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            selectedView.borderWidth = 2.0
            imgCheck.isHidden = false
        }else{
            selectedView.borderColor = #colorLiteral(red: 0.7843137255, green: 0.7843137255, blue: 0.7843137255, alpha: 1)
            selectedView.borderWidth = 1.0
            imgCheck.isHidden = true
        }
    }
    
}
