//
//  BarberDataTblCell.swift
//  Fade
//
//  Created by Chirag Patel on 29/09/21.
//  Copyright © 2021 Devang Lakhani. All rights reserved.
//

import UIKit
import Cosmos
import MapKit

class BarberDataTblCell: UITableViewCell {
    @IBOutlet weak var collView : UICollectionView!
    @IBOutlet weak var lblBookedService : UILabel!
    @IBOutlet weak var lblTotalPay : UILabel!
    @IBOutlet weak var lblDateTime : UILabel!
    @IBOutlet weak var lblAddress : UILabel!
    @IBOutlet weak var imgMap : UIImageView!
    @IBOutlet weak var ratingView : CosmosView!
    @IBOutlet weak var lblReviewName : UILabel!
    @IBOutlet weak var galleryView : UIView!
    @IBOutlet weak var reviewView : UIView!
    
    weak var parentVC : BarberDataVC!
    
    
    func prepareCell(data : BarberDetailsModel,idx: Int){
        switch data.cellType {
        case .serviceCell:
            var serviceList : String{
                let strService = parentVC.objBooking.arrBarberServices.map{$0.serviceName}.filter{!$0.isEmpty}.joined(separator: ",")
                return strService
            }
            lblBookedService.text = serviceList
            lblTotalPay.text = "£\(parentVC.objBooking.totalPay)"
            if !parentVC.objBooking.arrBarberServices.isEmpty{
                let firstService = parentVC.objBooking.arrBarberServices.first!
                lblDateTime.text = firstService.strDate + convertFormat(time: firstService.slotTime)
            }
        case .addressCell:
            lblAddress.text = parentVC.objBooking.address
            let lat = Double(parentVC.objBooking.lat)!
            let long = Double(parentVC.objBooking.long)!
            let snapShotOption = self.getSnapShotOfMap(lat: lat, long: long)
            let snapShotter = MKMapSnapshotter(options: snapShotOption)
            snapShotter.start { (snapShot, error) in
                if error == nil{
                    let img = snapShot?.image
                    self.imgMap.image = img
                }else{
                    print(error!.localizedDescription)
                }
            }
        case .reviewCell:
            ratingView.tag = idx
            lblReviewName.text = data.reviewType
            if parentVC.objBooking.isOrderCompleted == 1 && parentVC.objBooking.arrReviews.isEmpty{
                parentVC.btnAddReview.isHidden = false
                reviewView.isHidden = false
                ratingView.isUserInteractionEnabled = true
                ratingView.rating = Double(data.reviewValue)
                getReview(idx: ratingView.tag)
            }else if !parentVC.objBooking.arrReviews.isEmpty{
                parentVC.btnAddReview.isHidden = true
                reviewView.isHidden = false
                ratingView.isUserInteractionEnabled = false
                self.prepareReviews(data: parentVC.objBooking)
            }else{
                reviewView.isHidden = true
            }
        case .galleryCell:
            if parentVC.objBooking.isOrderCompleted == 1 {
                galleryView.isHidden = false
                collView.reloadData()
            }else if !parentVC.objBooking.arrReviews.isEmpty{
                galleryView.isHidden = false
                collView.reloadData()
            }else{
                galleryView.isHidden = true
            }
        }
    }
}
//MARK:- Get Map SnapShot Methods
extension BarberDataTblCell{
    func getSnapShotOfMap(lat : Double, long: Double) -> MKMapSnapshotter.Options{
        let mapSnapshotOptions = MKMapSnapshotter.Options()
        let location = CLLocationCoordinate2DMake(lat, long)
        let region = MKCoordinateRegion(center: location, latitudinalMeters: 1000, longitudinalMeters: 1000)
        mapSnapshotOptions.region = region
        mapSnapshotOptions.scale = UIScreen.main.scale
        mapSnapshotOptions.size = CGSize(width: 170.widthRatio, height: 124.widthRatio)
        mapSnapshotOptions.showsBuildings = true
        mapSnapshotOptions.showsPointsOfInterest = true
        return mapSnapshotOptions
    }
    func convertFormat(time: String) -> String{
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "HH:mm"
        let showDate = inputFormatter.date(from: time)
        inputFormatter.dateFormat = "HH:mm a"
        let resultString = inputFormatter.string(from: showDate!)
        return resultString
    }
    
    func getReview(idx: Int){
        ratingView.didFinishTouchingCosmos = {rating in
            self.parentVC.objTotalData.arrData[idx].reviewDisplayValue = rating
            self.parentVC.objTotalData.arrData[idx].reviewValue = Int(rating)
        }
        parentVC.tableView.reloadRows(at: [IndexPath(row: 1, section: idx)], with: .automatic)
    }
}

//MARK:- CollectionView Delegate & DataSource Methods
extension BarberDataTblCell : UICollectionViewDelegate,UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0{
            if parentVC.objBooking.isOrderCompleted == 1 && parentVC.objBooking.arrReviews.isEmpty{
                return 1
            }
            return 0
        }else{
            if !parentVC.objBooking.arrReviews.isEmpty{
                return parentVC.objBooking.arrReviews.first!.arrPortfoilio.count
            }else{
                return parentVC.arrUserReviewImg.count
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : BarberDataCollCell
        if indexPath.section == 0{
            let cell = collView.dequeueReusableCell(withReuseIdentifier: "addPhotoCell", for: indexPath) as! BarberDataCollCell
            return cell
        }else{
            cell = collView.dequeueReusableCell(withReuseIdentifier: "gallaryCollCell", for: indexPath) as! BarberDataCollCell
            if  !parentVC.objBooking.arrReviews.isEmpty{
                cell.prepareCellData(data: parentVC.objBooking.arrReviews.first!.arrPortfoilio[indexPath.row])
            }else if !parentVC.arrUserReviewImg.isEmpty{
                cell.imgPhoto.image = parentVC.arrUserReviewImg[indexPath.row]
            }
            return cell
        }
    }
}
//MARK:- CollectionView Layout Delegate Methods
extension BarberDataTblCell : UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collHeight = 90.widthRatio
        let collWidth = collHeight *  1.34
        return CGSize(width: collWidth, height: collHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 6
    }
}


//MARK:- Image Picker Methods
extension BarberDataTblCell{
    
    @IBAction func btnAddPictureTapped(_ sender: UIButton){
        let pic = UIImagePickerController()
        self.prepareImagePicker(pictureController: pic)
        pic.delegate = self
    }
    
    func prepareImagePicker(pictureController : UIImagePickerController){
        let actionSheet = UIAlertController(title: "SelectType", message: "", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            pictureController.sourceType = .camera
            pictureController.cameraCaptureMode = .photo
            pictureController.allowsEditing = false
            self.parentVC.present(pictureController, animated: true, completion: nil)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "PhotoLibrery", style: .default, handler: { _ in
            pictureController.sourceType = .photoLibrary
            pictureController.allowsEditing = true
            self.parentVC.present(pictureController, animated: true, completion: nil)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancle", style: .cancel, handler: nil))
        
        self.parentVC.present(actionSheet, animated: true, completion: nil)
    }
}

//MARK:- UIImagePickerDelegate Methods
extension BarberDataTblCell : UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if picker.sourceType == .camera{
            if let image = info[.originalImage] as? UIImage{
                print(image)
                self.parentVC.dismiss(animated: true, completion: nil)
            }
        }else if picker.sourceType == .photoLibrary{
            if let image = info[.editedImage] as? UIImage{
                self.parentVC.arrUserReviewImg.append(image)
                self.collView.reloadData()
                self.parentVC.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.parentVC.dismiss(animated: true, completion: nil)
    }
    
    
    func prepareReviews(data: PreviousBooking){
        if !data.arrReviews.isEmpty{
            guard let service = Int(data.arrReviews.first!.service), let hygine = Int(data.arrReviews.first!.hygine), let value = Int(data.arrReviews.first!.value) else {return}
            parentVC.objTotalData.arrData[3].reviewValue = service
            parentVC.objTotalData.arrData[4].reviewValue = hygine
            parentVC.objTotalData.arrData[5].reviewValue = value
            if ratingView.tag == 3{
                ratingView.rating = Double(parentVC.objTotalData.arrData[3].reviewValue)
            }else if ratingView.tag == 4{
                ratingView.rating = Double(parentVC.objTotalData.arrData[4].reviewValue)
            }else {
                ratingView.rating = Double(parentVC.objTotalData.arrData[5].reviewValue)
            }
        }
    }
}

