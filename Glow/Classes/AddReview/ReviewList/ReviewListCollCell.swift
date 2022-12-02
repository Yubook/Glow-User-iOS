//
//  ReviewListCollCell.swift
//  Fade
//
//  Created by Devang Lakhani  on 6/9/21.
//  Copyright © 2021 Devang Lakhani. All rights reserved.
//

import UIKit

class ReviewListCollCell: UICollectionViewCell {
    @IBOutlet weak var imgsView : UIImageView!
    @IBOutlet weak var btnZoom : UIButton!
    
    func prepareCell(data : ImageList){
        imgsView.kf.setImage(with: data.imgUrl)
    }
}
