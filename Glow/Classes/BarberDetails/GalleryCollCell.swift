//
//  GalleryCollCell.swift
//  Fade
//
//  Created by Chirag Patel on 28/09/21.
//  Copyright © 2021 Devang Lakhani. All rights reserved.
//

import UIKit

class GalleryCollCell: UICollectionViewCell {
    @IBOutlet weak var imgReview : UIImageView!
    
    
    func prepareCell(data: Portfolio){
        imgReview.kf.setImage(with: data.imgReview)
    }
    
}
