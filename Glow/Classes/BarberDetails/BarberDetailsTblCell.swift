//
//  BarberDetailsTblCell.swift
//  Fade
//
//  Created by Chirag Patel on 28/09/21.
//  Copyright © 2021 Devang Lakhani. All rights reserved.
//

import UIKit

class BarberDetailsTblCell: UITableViewCell {
    @IBOutlet weak var galleryCollView : UICollectionView!
    @IBOutlet weak var lblServiceName : UILabel!
    @IBOutlet weak var lblPrice : UILabel!
    @IBOutlet weak var lblTime : UILabel!
    @IBOutlet weak var btnAdd : UIButton!
    @IBOutlet weak var lblTitle : UILabel!
    @IBOutlet weak var lblTermsCondition : UILabel!
    @IBOutlet weak var lblServicePoint : UILabel!
    @IBOutlet weak var lblValuePoint : UILabel!
    @IBOutlet weak var lblHyginePoint : UILabel!
    @IBOutlet  var lblTotalStrs : [UILabel]!
    @IBOutlet  var progressStars : [UIProgressView]!
    @IBOutlet weak var lblAverageRating : UILabel!
    
    weak var parentVC : BarberDetailsVC!
    
    func getCollNoDataCell() {
        galleryCollView.register(UINib(nibName: "EmptyCollCell", bundle: nil), forCellWithReuseIdentifier: "noDataCell")
    }
    
    
    func prepareServiceData(data: BarberService, idx: Int){
        if let services = data.barberServiceDict{
            lblPrice.text = "£" + data.servicePrice
            lblTime.text = services.time + "m"
            lblServiceName.text = services.name
            btnAdd.tag = idx
            btnAdd.backgroundColor = data.isSelected ? #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) : #colorLiteral(red: 0.9254901961, green: 0.9254901961, blue: 0.9254901961, alpha: 1)
            lblTitle.textColor = data.isSelected ? .white : #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }
    }
    
    func prepareReviews(data: BarberProfileDetails){
        var totalValueRating = 0.0
        var totalServiceRating = 0.0
        var totalHyginRating = 0.0
        var valueRate : Double!
        var serviceRate : Double!
        var hygineRate : Double!
        for (_,obj) in data.arrReviews.enumerated(){
            totalValueRating += Double(obj.value)!
            totalServiceRating += Double(obj.service)!
            totalHyginRating += Double(obj.hygine)!
        }
        valueRate = totalValueRating / Double(data.arrReviews.count)
        serviceRate = totalServiceRating / Double(data.arrReviews.count)
        hygineRate = totalHyginRating / Double(data.arrReviews.count)
        lblValuePoint.text = valueRate.isNaN ? "0.0" : String(format: "%.2f", valueRate)
        lblServicePoint.text = serviceRate.isNaN ? "0.0" : String(format: "%.2f", serviceRate)
        lblHyginePoint.text = hygineRate.isNaN ? "0.0" : String(format: "%.2f", hygineRate)
        let totalRating = valueRate + serviceRate + hygineRate
        let overallRate = totalRating / 3
        lblAverageRating.text = overallRate.isNaN ? "0.0" :  String(format: "%.1f", overallRate)
    }
    
    func prepareTotalReview(data: BarberProfileDetails){
        for (index,obj) in lblTotalStrs.enumerated(){
            if index == 0{
                obj.text = data.fiveStar
            }else if index == 1{
                obj.text = data.fourStar
            }else if index == 2{
                obj.text = data.threeStar
            }else if index == 3{
                obj.text = data.twoStar
            }else{
                obj.text = data.oneStar
            }
        }
    }
    
    func prepareProgressReview(data: BarberProfileDetails){
        for (index, obj) in progressStars.enumerated(){
            if index == 0{
                let str = Float(data.fiveStar)! * 100
                let totalReview = Float(data.totalReviews)!
                let final = str / totalReview
                if final.isNaN{
                    obj.progress = 0.0
                }else{
                    obj.progress = final
                }
            }else if index == 1{
                let str = Float(data.fourStar)! * 100
                let totalReview = Float(data.totalReviews)!
                let final = str / totalReview
                if final.isNaN{
                    obj.progress = 0.0
                }else{
                    obj.progress = final
                }
            }else if index == 2{
                let str = Float(data.threeStar)! * 100
                let totalReview = Float(data.totalReviews)!
                let final = str / totalReview
                if final.isNaN{
                    obj.progress = 0.0
                }else{
                    obj.progress = final
                }
            }else if index == 3{
                let str = Float(data.twoStar)! * 100
                let totalReview = Float(data.totalReviews)!
                let final = str / totalReview
                if final.isNaN{
                    obj.progress = 0.0
                }else{
                    obj.progress = final
                }
            }else{
                let str = Float(data.oneStar)! * 100
                let totalReview = Float(data.totalReviews)!
                let final = str / totalReview
                if final.isNaN{
                    obj.progress = 0.0
                }else{
                    obj.progress = final
                }
            }
        }
    }
    
}

//MARK:- CollectionView Delegate & DataSource Methods
extension BarberDetailsTblCell : UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if parentVC.objProfileData != nil{
            if !parentVC.objProfileData!.arrReviews.isEmpty{
                return parentVC.objProfileData!.arrReviews.first!.arrPortfoilio.count
            }
        }
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if parentVC.objProfileData != nil{
            if !parentVC.objProfileData!.arrReviews.isEmpty{
                let cell : GalleryCollCell
                cell = galleryCollView.dequeueReusableCell(withReuseIdentifier: "galleryCell", for: indexPath) as! GalleryCollCell
                if parentVC.objProfileData != nil{
                    cell.prepareCell(data: parentVC.objProfileData!.arrReviews.first!.arrPortfoilio[indexPath.row])
                }
                return cell
            }else{
                let cell : EmptyCollCell
                cell = collectionView.dequeueReusableCell(withReuseIdentifier: "noDataCell", for: indexPath) as! EmptyCollCell
                cell.setText(str: "No Data Found!!")
                return cell
            }
        }else{
            let cell : EmptyCollCell
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "noDataCell", for: indexPath) as! EmptyCollCell
            cell.setText(str: "No Data Found!!")
            return cell
        }
    }
}

//MARK:- CollectionView Delegate FlowLayout Methods
extension BarberDetailsTblCell : UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if parentVC.objProfileData != nil{
            if !parentVC.objProfileData!.arrReviews.isEmpty{
                let height = _screenSize.width / 3
                return CGSize(width: height, height: height);
            }
        }
        return CGSize(width: galleryCollView.bounds.size.width, height: galleryCollView.bounds.size.width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}
