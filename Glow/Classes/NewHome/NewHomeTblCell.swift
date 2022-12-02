//
//  NewHomeTblCell.swift
//  Fade
//
//  Created by Chirag Patel on 27/09/21.
//  Copyright © 2021 Devang Lakhani. All rights reserved.
//

import UIKit
import Cosmos

class NewHomeTblCell: UITableViewCell {
    @IBOutlet weak var serviceCollView : UICollectionView!
    @IBOutlet weak var lblSectionTitle : UILabel!
    @IBOutlet weak var btnSection : UIButton!
    @IBOutlet weak var lblBarberName : UILabel!
    @IBOutlet weak var imgBarber : UIImageView!
    @IBOutlet weak var lblServiceName : UILabel!
    @IBOutlet weak var ratingView : CosmosView!
    @IBOutlet weak var lblTotalRating : UILabel!
    @IBOutlet weak var btnFavorite : UIButton!
    weak var parentVC : NewHomeVC!
    
    
    func parpareBarber(data: NearestBarber){
        btnFavorite.setImage(UIImage(named: data.isFav ? "ic_fill_heart" : "ic_heart"), for: .normal)
        btnFavorite.isSelected = data.isFav
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
        }else{
            lblServiceName.text = doubleStr + " miles away"
        }
    }
}

//MARK:- CollectionView Delegate & DataSource Methods
extension NewHomeTblCell : UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return parentVC.arrServices.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : NewHomeCollCell
        cell = serviceCollView.dequeueReusableCell(withReuseIdentifier: "newCollCell", for: indexPath) as! NewHomeCollCell
        cell.prepareCellData(data: parentVC.arrServices[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let objData = parentVC.arrServices[indexPath.row]
        objData.isSelected.toggle()
        self.serviceCollView.reloadItems(at: [indexPath])
        let selectedArray = parentVC.arrServices.filter{$0.isSelected}
        if !selectedArray.isEmpty{
            parentVC.arrBarbers = parentVC.filterServices(servicesName: selectedArray.map{$0.name})
        }else{
            parentVC.arrBarbers = parentVC.tempArray
        }
        parentVC.tableView.reloadData()
    }
}

//MARK:- CollectionView FlowLayout Delegate Methods
extension NewHomeTblCell : UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellHeight = 75.widthRatio
        let cellWidth = cellHeight * 1.0
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 16, bottom: 0, right: 0)
    }
}
