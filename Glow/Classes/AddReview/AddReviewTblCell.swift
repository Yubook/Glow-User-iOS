//
//  AddReviewTblCell.swift
//  Fade
//
//  Created by Devang Lakhani  on 4/13/21.
//  Copyright © 2021 Devang Lakhani. All rights reserved.
//

import UIKit
import Cosmos

class AddReviewTblCell: UITableViewCell {
    @IBOutlet weak var picCollView : UICollectionView!
    @IBOutlet weak var lblSectionTitle : UILabel!
    @IBOutlet weak var lblPlaceHolder : UILabel!
    @IBOutlet weak var txtView : UITextView!
    @IBOutlet weak var reviewView : CosmosView!
    
    
    weak var parentVC : AddReviewVC!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}

//MARK:- Others Methods
extension AddReviewTblCell{
    func prepareTextView(data : EnumAddReview){
        switch data{
        case .txtViewCell:
            txtView.layer.cornerRadius = 10
            txtView.layer.borderColor = #colorLiteral(red: 0.7843137255, green: 0.7843137255, blue: 0.7843137255, alpha: 1)
            txtView.layer.borderWidth = 2.0
        default : break
        }
    }
}

//MARK:- TextView Delegate Methods
extension AddReviewTblCell : UITextViewDelegate{
    
    func textViewDidChange(_ textView: UITextView) {
        let str = textView.text.trimmedString()
        if str.count > 0{
            parentVC.objData.message = str
            lblPlaceHolder.isHidden = true
        }else{
            lblPlaceHolder.isHidden = false
        }
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //    func textViewDidBeginEditing(_ textView: UITextView) {
    //        parentVC.tableView.scrollToRow(at: IndexPath(row: 3, section: 0), at: .top, animated: true)
    //    }
}

//MARK:- CollectionView Delegate & DataSource Methods
extension AddReviewTblCell : UICollectionViewDelegate, UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0{
            return 1
        }else{
            return self.parentVC.arrSelectedImage.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : AddPictureCollCell
        
        if indexPath.section == 0{
            
            cell = picCollView.dequeueReusableCell(withReuseIdentifier: "addPicCell", for: indexPath) as! AddPictureCollCell
            if parentVC.arrReviewData.count > 5{
                cell.isHidden = true
            }
            return cell
        }else{
            cell = picCollView.dequeueReusableCell(withReuseIdentifier: "picListCell", for: indexPath) as! AddPictureCollCell
            cell.imgView.image = self.parentVC.arrSelectedImage[indexPath.row]
            return cell
        }
    }
}

//MARK:- CollectionView Delegate FlowLayout Methods
extension AddReviewTblCell : UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collHeight = 90.widthRatio
        let collWidth = collHeight * 1.34
        
        return CGSize(width: collWidth, height: collHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
    }
}


//MARK:- Add Picture Methods
extension AddReviewTblCell{
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
extension AddReviewTblCell : UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if picker.sourceType == .camera{
            if let image = info[.originalImage] as? UIImage{
                print(image)
                self.parentVC.dismiss(animated: true, completion: nil)
            }
        }else if picker.sourceType == .photoLibrary{
            if let image = info[.editedImage] as? UIImage{
                self.parentVC.arrSelectedImage.append(image)
                self.picCollView.reloadData()
                self.parentVC.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.parentVC.dismiss(animated: true, completion: nil)
    }
}

//MARK:- Setup Reviews
extension AddReviewTblCell{
    func setupReview(){
        reviewView.rating = 0.0
        reviewView.text = "0 Star"
        reviewView.settings.starSize = 30
        
        reviewView.didFinishTouchingCosmos = {rating in
            self.parentVC.objData.rating = "\(Int(rating))"
            self.reviewView.text = "\(Int(rating)) Star"
        }
    }
}


