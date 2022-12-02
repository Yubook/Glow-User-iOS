//
//  FavoritesTblCell.swift
//  Fade
//
//  Created by Chirag Patel on 27/09/21.
//  Copyright © 2021 Devang Lakhani. All rights reserved.
//

import UIKit
import Cosmos

class FavoritesTblCell: UITableViewCell {
    @IBOutlet weak var lblBarberName : UILabel!
    @IBOutlet weak var imgBarber : UIImageView!
    @IBOutlet weak var lblServiceName : UILabel!
    @IBOutlet weak var ratingView : CosmosView!
    @IBOutlet weak var lblTotalRating : UILabel!
    @IBOutlet weak var btnFavorite : UIButton!

    
    func parpareBarber(data: NearestBarber){
        ratingView.isUserInteractionEnabled = false
        btnFavorite.setImage(UIImage(named: "ic_fill_heart"), for: .normal)
        lblBarberName.text = data.name.capitalizingFirstLetter()
        imgBarber.kf.setImage(with: data.profileUrl)
        lblTotalRating.text = "(" + data.totalReview  +  " Ratings" + ")"
        ratingView.rating = Double(data.avgRating) ?? 0
        let distance = Double(data.distance) ?? 0
        let doubleStr = String(format: "%.2f", distance)
        if !data.arrBarberServices.isEmpty{
            let totalServices = data.arrBarberServices.first!.barberServiceDict
            let price = data.arrBarberServices.first!.servicePrice
            if let service = totalServices{
                lblServiceName.text = doubleStr + " miles away " + "/ " + service.name + " £" + price
            }
        }
    }

}
