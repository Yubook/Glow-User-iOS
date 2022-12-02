//
//  ProfileTblCell.swift
//  Fade
//
//  Created by Devang Lakhani  on 4/13/21.
//  Copyright © 2021 Devang Lakhani. All rights reserved.
//

import UIKit

class ProfileTblCell: UITableViewCell {
    @IBOutlet weak var imgView : UIImageView!
    @IBOutlet weak var lblFeature : UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func prepareCell(data: ProfileDetails){
        imgView.image = data.setIcon
        lblFeature.text = data.featuresName
    }
    
    

}
