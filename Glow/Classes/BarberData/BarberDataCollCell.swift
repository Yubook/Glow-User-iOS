//
//  BarberDataCollCell.swift
//  Fade
//
//  Created by Chirag Patel on 29/09/21.
//  Copyright © 2021 Devang Lakhani. All rights reserved.
//

import UIKit

class BarberDataCollCell: UICollectionViewCell {
    @IBOutlet weak var imgPhoto : UIImageView!
    @IBOutlet weak var btnAddPhoto : UIButton!
    
    
    func prepareCellData(data: Portfolio){
        imgPhoto.kf.setImage(with: data.imgReview)
    }
}
