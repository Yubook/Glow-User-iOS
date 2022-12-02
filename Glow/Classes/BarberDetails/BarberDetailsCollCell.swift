//
//  BarberDetailsCollCell.swift
//  Fade
//
//  Created by Chirag Patel on 28/09/21.
//  Copyright © 2021 Devang Lakhani. All rights reserved.
//

import UIKit

class BarberDetailsCollCell: UICollectionViewCell {
    @IBOutlet weak var lblTitle : UILabel!
    @IBOutlet weak var selectedView : UIView!
    
    func prepareCell(data: BarberDetailsMenu){
        lblTitle.text = data.title
        lblTitle.textColor = data.isSelected ? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) : #colorLiteral(red: 0.1776823103, green: 0.1835024953, blue: 0.2030859888, alpha: 1)
        selectedView.backgroundColor = data.isSelected ? #colorLiteral(red: 0.1776823103, green: 0.1835024953, blue: 0.2030859888, alpha: 1) : #colorLiteral(red: 0.9254901961, green: 0.9254901961, blue: 0.9254901961, alpha: 1)
    }
}
