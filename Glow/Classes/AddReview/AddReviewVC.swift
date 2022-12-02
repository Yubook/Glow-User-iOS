//
//  AddReviewVC.swift
//  Fade
//
//  Created by Devang Lakhani  on 4/13/21.
//  Copyright © 2021 Devang Lakhani. All rights reserved.
//

import UIKit
import Cosmos

class AddReviewVC: ParentViewController {
    @IBOutlet weak var lblDriverName : UILabel!
    @IBOutlet weak var imgDriverProfile : UIImageView!
    @IBOutlet weak var lblService : UILabel!
    
    let arrReviewData : [EnumAddReview] = [.ratingCell,.txtViewCell,.addPhotoCell,.btnCell]
    var arrSelectedImage : [UIImage] = []
    var objData = AddReview()
    var _driverId : String = ""
    var objDriverData : Orders!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUI()
    }
}

//MARK:- Others Methods
extension AddReviewVC{
    func prepareUI(){
        prepareDriver()
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
        objData.fromId = _user.id
        objData.toId = _driverId
    }
    
    @IBAction func btnSubmitTapped(_ sender : UIButton){
        let valid = objData.validateData()
        if valid.isValid{
            self.addReview()
        }else{
            showError(msg: valid.error)
        }
    }
    
    func prepareDriver(){
        if let driver = objDriverData.driver{
            lblDriverName.text = driver.driverName
            imgDriverProfile.kf.setImage(with: driver.imageUrl)
            if let service = driver.service.first{
                lblService.text = service.name
            }
        }
    }
}

//MARK:- TableView Delegate & DataSource Methods
extension AddReviewVC{
    func numberOfSections(in tableView: UITableView) -> Int {
        return arrReviewData.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableCell(withIdentifier: "sectionCell") as! AddReviewTblCell
        headerView.lblSectionTitle.text = arrReviewData[section].sectionTitle
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : AddReviewTblCell
        
        cell = tableView.dequeueReusableCell(withIdentifier: arrReviewData[indexPath.section].cellId, for: indexPath) as! AddReviewTblCell
        
        let objExtract = arrReviewData[indexPath.section]
        cell.parentVC = self
        cell.prepareTextView(data: objExtract)
        if objExtract == .ratingCell{
            cell.setupReview()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 3{
            return 0
        }else{
            return 45.widthRatio
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return arrReviewData[indexPath.section].cellHeight
    }
}

//MARK:- ImagePicker Methods
extension AddReviewVC{
    
}

//MARK:- AddReview WebCall Method
extension AddReviewVC{
    func addReview(){
        showHud()
        KPWebCall.call.addReviews(imgs: arrSelectedImage, withName: "image[]", param: objData.paramDict()) { [weak self](json, statusCode) in
            guard let weakSelf = self else {return}
            weakSelf.hideHud()
            if statusCode == 200, let dict = json as? NSDictionary{
                weakSelf.showSuccMsg(dict: dict)
                //weakSelf.navigateToReviews()
                weakSelf.navigationController?.popViewController(animated: true)
            }else{
                weakSelf.showError(data: json, view: weakSelf.view)
            }
        }
    }
    
    /* func navigateToReviews(){
     self.performSegue(withIdentifier: "reviews", sender: _driverId)
     }
     
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     if segue.identifier == "reviews"{
     let vc = segue.destination as! ReviewListVC
     if let id = sender as? String{
     vc.driverId = id
     }
     }
     } */
}
