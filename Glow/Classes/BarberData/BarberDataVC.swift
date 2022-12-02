//
//  BarberDataVC.swift
//  Fade
//
//  Created by Chirag Patel on 29/09/21.
//  Copyright © 2021 Devang Lakhani. All rights reserved.
//

import UIKit

class BarberDataVC: ParentViewController {
    @IBOutlet weak var imgBarber : UIImageView!
    @IBOutlet weak var lblBarberName : UILabel!
    @IBOutlet weak var lblDistance : UILabel!
    @IBOutlet weak var btnFav : UIButton!
    @IBOutlet weak var btnChat : UIButton!
    @IBOutlet weak var btnAddReview : UIButton!
    
    var barberObject : UsersData!
    var objProfileData : BarberProfileDetails?
    var objBooking : PreviousBooking!
    var arrUserReviewImg : [UIImage?] = []
    var arrBarberData : [EnumBarberData] = [.serviceCell,.addressCell,.galleryCell,.reviewCell]
    var objTotalData = BarberDetailsData()
    var otherDict : [String:Any] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnFav.setImage(UIImage(named: "ic_heart"), for: .normal)
        if barberObject != nil{
            barberProfile()
        }
        prepareUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13, *) {
            return .darkContent
        } else {
            return .default
        }
    }}
//MARK:- Others Methods
extension BarberDataVC{
    func prepareUI(){
        objTotalData.prepareData()
        prepareBarberDetails()
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
        tableView.contentInset = UIEdgeInsets(top: 15, left: 0, bottom: 60, right: 0)
    }
    
    func prepareBarberDetails(){
        btnAddReview.isHidden = objBooking.isOrderCompleted == 1 ? false : true
        imgBarber.kf.setImage(with: barberObject.profileUrl)
        lblBarberName.text = barberObject.name.capitalizingFirstLetter()
        // let distance = Double(obj.distance) ?? 0
        let doubleStr = String(format: "%.2f", objBooking.distance)
         lblDistance.text = doubleStr + " miles away"
        btnChat.isHidden = objBooking.chat ? false : true
    }
    
    @IBAction func btnFavTapped(_ sender: UIButton){
        sender.isSelected.toggle()
        otherDict["user_id"] = _user.id
        otherDict["barber_id"] = barberObject.id
        if sender.isSelected{
            otherDict["type"] = 1
            self.favUnFav(param: otherDict)
            btnFav.setImage(UIImage(named: "ic_fill_heart"), for: .normal)
        }else{
            otherDict["type"] = 0
            self.favUnFav(param: otherDict)
            btnFav.setImage(UIImage(named: "ic_heart"), for: .normal)
        }
    }
    
    @IBAction func btnAddReviewTapped(_ sender: UIButton){
        if objTotalData.arrData[3].reviewValue != 0 && objTotalData.arrData[4].reviewValue != 0 && objTotalData.arrData[5].reviewValue != 0{
            self.addReview()
        }else{
            self.showError(msg: "Select minimum 1 Star")
        }
    }
    
    @IBAction func btnChatTapped(_ sender : UIButton){
        if objBooking != nil{
            let storyboard = UIStoryboard(name: "Chat", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier :"MessagesListVC") as! MessagesListVC
            vc.name = objBooking.users!.name
            vc.groupId = objBooking.chatId
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

//MARK:- TableView Delegate & DataSource Methods
extension BarberDataVC{
    func numberOfSections(in tableView: UITableView) -> Int {
        return objTotalData.arrData.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let objData = objTotalData.arrData[indexPath.section]
        let cell : BarberDataTblCell
        cell = tableView.dequeueReusableCell(withIdentifier: objData.cellType.cellId, for: indexPath) as! BarberDataTblCell
        cell.parentVC = self
        cell.prepareCell(data: objData,idx: indexPath.section)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return objTotalData.arrData[indexPath.section].cellType.cellHeight
    }
}

//MARK:- Barber Profile WebCall Methods
extension BarberDataVC{
    func barberProfile(){
        showHud()
        KPWebCall.call.getDriverData(param: ["barber_id" : barberObject.id]) {[weak self] (json, statusCode) in
            guard let weakSelf = self, let dict = json as? NSDictionary else {return}
            if statusCode == 200{
                weakSelf.hideHud()
                if let res = dict["result"] as? NSDictionary{
                    weakSelf.objProfileData = BarberProfileDetails(dict: res)
                }
                
                weakSelf.tableView.reloadData()
            }else{
                weakSelf.showError(data: json, view: weakSelf.view)
            }
        }
    }
}

//MARK:- Favorite & UnFavorite Barber WebCall Methods
extension BarberDataVC{
    func favUnFav(param:[String:Any]){
        showHud()
        KPWebCall.call.favoriteUnFavoriteBarber(param: param) {[weak self] (json, statusCode) in
            guard let weakSelf = self, let dict = json as? NSDictionary else {return}
            if statusCode == 200{
                weakSelf.hideHud()
             //   weakSelf.showSuccMsg(dict: dict)
            }else{
                weakSelf.showError(data: json, view: weakSelf.view)
            }
        }
    }
}

//MARK:- Add Review
extension BarberDataVC{
    func paramReviewDict() -> [String:Any]{
        var dict : [String:Any] = [:]
        dict["user_id"] = _user.id
        dict["barber_id"] = barberObject.id
        dict["order_id"] = objBooking.orderId
        dict["service"] =  "\(objTotalData.arrData[3].reviewValue)"
        dict["hygiene"] =  "\(objTotalData.arrData[4].reviewValue)"
        dict["value"] =  "\(objTotalData.arrData[5].reviewValue)"
        return dict
    }
    
    func addReview(){
        showHud()
        KPWebCall.call.addReview(imgs: arrUserReviewImg, param: paramReviewDict()) {[weak self] (json, statusCode) in
            guard let weakSelf = self, let dict = json as? NSDictionary else {return}
            if statusCode == 200{
                weakSelf.hideHud()
               // weakSelf.showSuccMsg(dict: dict)
            }else{
                weakSelf.showError(data: json, view: weakSelf.view)
            }
        }
    }
}
