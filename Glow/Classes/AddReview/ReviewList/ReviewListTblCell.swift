//
//  ReviewListTblCell.swift
//  Fade
//
//  Created by Devang Lakhani  on 4/13/21.
//  Copyright © 2021 Devang Lakhani. All rights reserved.
//

import UIKit
import Cosmos

class ReviewListTblCell: UITableViewCell {
    @IBOutlet weak var ratingsView : CosmosView!
    @IBOutlet weak var imgProfile : UIImageView!
    @IBOutlet weak var lblMessage : UILabel!
    @IBOutlet weak var lblTotalReviews : UILabel!
    @IBOutlet weak var imgsCollView : UICollectionView!
    @IBOutlet weak var lblName : UILabel!
    weak var parent : ReviewListVC!
    var arrImgs : [ImageList] = []
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func prepareCell(data: Reviews){
        arrImgs = data.arrimgList
        ratingsView.isUserInteractionEnabled = false
        ratingsView.rating = Double(data.rating) ?? 0.0
        ratingsView.text = "\(data.rating) Star"
        lblMessage.text = data.message
        if let users = data.users{
            imgProfile.kf.setImage(with: users.profileUrl)
            lblName.text = users.name
        }
    }
    @IBAction func btnImageTapped(_ sender: UIButton){
        let imgUrls = arrImgs[sender.tag].imgUrl
        parent.performSegue(withIdentifier: "zoom", sender: imgUrls)
    }
}

//MARK:- CollectionView Delegate & DataSource Methods
extension ReviewListTblCell : UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrImgs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : ReviewListCollCell
        
        cell = imgsCollView.dequeueReusableCell(withReuseIdentifier: "img", for: indexPath) as! ReviewListCollCell
        cell.btnZoom.tag = indexPath.row
        let objData = arrImgs[indexPath.row]
        cell.prepareCell(data: objData)
        
        return cell
    }
}

//MARK:- CollectionView Delegate FlowLayout Methods
extension ReviewListTblCell : UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collHeight = 100.widthRatio
        let collWidth = collHeight * 1.0
        
        return CGSize(width: collHeight, height: collWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 0)
    }
}
