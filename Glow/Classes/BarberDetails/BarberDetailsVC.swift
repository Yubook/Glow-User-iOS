//
//  BarberDetailsVC.swift
//  Fade
//
//  Created by Chirag Patel on 28/09/21.
//  Copyright © 2021 Devang Lakhani. All rights reserved.
//

import UIKit

class BarberDetailsVC: ParentViewController {
    @IBOutlet weak var imgBarber : UIImageView!
    @IBOutlet weak var lblBarberName : UILabel!
    @IBOutlet weak var lblDistance : UILabel!
    @IBOutlet weak var btnFav : UIButton!
    @IBOutlet weak var btnChat : UIButton!
    @IBOutlet weak var btnBook : UIButton!
    
    var otherDict : [String:Any] = [:]
    var arrTabDetails : [BarberDetailsMenu] = []
    var enumTabTypes : EnumDetailsType = .Portfolio
    var barberObject : NearestBarber!
    var objProfileData : BarberProfileDetails?
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    }

}

//MARK:- Other Methods
extension BarberDetailsVC{
    func prepareUI(){
        if barberObject != nil{
            barberProfile()
            prepareBarberDetails()
        }
        btnBook.isHidden = true
        getNoDataCell()
        prepareStaticData()
        collectionView.contentInset = UIEdgeInsets(top: 10, left: 30, bottom: 14, right: 30)
        tableView.contentInset = UIEdgeInsets(top: 26, left: 0, bottom: 0, right: 0)
        tableView.separatorStyle = .none
    }
    
    
    func prepareBarberDetails(){
        btnFav.setImage(UIImage(named: barberObject.isFav ? "ic_fill_heart" : "ic_heart"), for: .normal)
        imgBarber.kf.setImage(with: barberObject.profileUrl)
        lblBarberName.text = barberObject.name.capitalizingFirstLetter()
        let distance = Double(barberObject.distance) ?? 0
        let doubleStr = String(format: "%.2f", distance)
        lblDistance.text = doubleStr + " miles away"
        
    }
    
    @IBAction func btnFavTapped(_ sender: UIButton){
        barberObject.isFav.toggle()
        otherDict["user_id"] = _user.id
        otherDict["barber_id"] = barberObject.barberId
        if barberObject.isFav{
            otherDict["type"] = 1
            self.favUnFav(param: otherDict)
        }else{
            otherDict["type"] = 0
            self.favUnFav(param: otherDict)
        }
        prepareBarberDetails()
    }
    
    @IBAction func btnAddServiceTapped(_ sender: UIButton){
        if objProfileData != nil{
            let objData = objProfileData!.arrBarberServices[sender.tag]
            objData.isSelected.toggle()
            let selectedArr = objProfileData!.arrBarberServices.filter{$0.isSelected}
            btnBook.isHidden = selectedArr.isEmpty ? true : false
            self.tableView.reloadRows(at: [IndexPath(row: sender.tag, section: 1)], with: .automatic)
        }
    }
    
    @IBAction func btnBookAppoimntmentTapped(_ sender: UIButton){
        if objProfileData != nil{
            let arrSelectedService = objProfileData!.arrBarberServices.filter{$0.isSelected}
            let storyboard = UIStoryboard(name: "Home", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier :"AppointmentBookingVC") as! AppointmentBookingVC
            vc.arrSelectedServices = arrSelectedService
            vc.objBarber = barberObject
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func btnChatTapped(_ sender : UIButton){
        if objProfileData != nil{
            let storyboard = UIStoryboard(name: "Chat", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier :"MessagesListVC") as! MessagesListVC
            vc.name = objProfileData!.name
            vc.groupId = objProfileData!.chatId
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

//MARK:- CollectionView Delegate & DataSource Methods
extension BarberDetailsVC : UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrTabDetails.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : BarberDetailsCollCell
        cell = collectionView.dequeueReusableCell(withReuseIdentifier: "tabCell", for: indexPath) as! BarberDetailsCollCell
        cell.prepareCell(data: arrTabDetails[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        setSeleectedIndex(index: indexPath.row)
        selectedIndexTypes(index: indexPath.row)
    }
}

//MARK:- CollectionView DelegateFlow Layout Methods
extension BarberDetailsVC : UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collHeight = 30.widthRatio
        let collWidth = collHeight * 3.75
        return CGSize(width: collWidth, height: collHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func setSeleectedIndex(index: Int){
        for (idx,obj) in arrTabDetails.enumerated(){
            if index == idx{
                obj.isSelected = true
            }else{
                obj.isSelected = false
            }
        }
        collectionView.reloadData()
    }
    
    func selectedIndexTypes(index: Int){
        let objData = arrTabDetails[index]
        if objData.id == "0"{
            enumTabTypes = .Portfolio
        }else if objData.id == "1"{
            enumTabTypes = .Pricing
        }else if objData.id == "2"{
            enumTabTypes = .Review
        }else{
            enumTabTypes = .Terms
        }
        self.tableView.reloadData()
    }
}

//MARK:- Static Data Methods
extension BarberDetailsVC{
    func prepareStaticData(){
        self.arrTabDetails.append(contentsOf: [BarberDetailsMenu(title: "Portfolio", id: "0"),BarberDetailsMenu(title: "Pricing", id: "1"),BarberDetailsMenu(title: "Review", id: "2"),BarberDetailsMenu(title: "Terms", id: "3")])
        self.arrTabDetails[0].isSelected = true
    }
}


//MARK:- TableView Delegate & DataSource Methods
extension BarberDetailsVC{
    func numberOfSections(in tableView: UITableView) -> Int {
        switch enumTabTypes{
        case .Portfolio,.Review,.Terms:
            return 1
        case .Pricing:
            return 2
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch enumTabTypes{
        case .Portfolio,.Review,.Terms:
            return 1
        case .Pricing:
            if section == 0{
                return 1
            }else{
                if objProfileData != nil{
                    return objProfileData!.arrBarberServices.count
                }else{
                    return 1
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : BarberDetailsTblCell
        if enumTabTypes == .Portfolio{
            cell = tableView.dequeueReusableCell(withIdentifier: "portfolioCell", for: indexPath) as! BarberDetailsTblCell
            cell.selectionStyle = .none
            cell.parentVC = self
            cell.galleryCollView.reloadData()
            cell.galleryCollView.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
            cell.getCollNoDataCell()
            btnBook.isHidden = true
            return cell
        }else if enumTabTypes == .Pricing{
            if indexPath.section == 0{
                cell = tableView.dequeueReusableCell(withIdentifier: "bookAppointmentCell", for: indexPath) as! BarberDetailsTblCell
                cell.selectionStyle = .none
                return cell
            }else{
                if objProfileData != nil{
                    cell = tableView.dequeueReusableCell(withIdentifier: "servicesCell", for: indexPath) as! BarberDetailsTblCell
                    cell.selectionStyle = .none
                    if objProfileData != nil{
                        let selectedArr = objProfileData!.arrBarberServices.filter{$0.isSelected}
                        btnBook.isHidden = selectedArr.isEmpty ? true : false
                    }
                    cell.parentVC = self
                    cell.prepareServiceData(data: objProfileData!.arrBarberServices[indexPath.row], idx: indexPath.row)
                    return cell
                }else{
                    let cell : NoDataTableCell
                    cell = tableView.dequeueReusableCell(withIdentifier: "noDataCell") as! NoDataTableCell
                    cell.setText(str: "No Service Available")
                    return cell
                }
                
            }
        }else if enumTabTypes == .Review{
            cell = tableView.dequeueReusableCell(withIdentifier: "reviewCell", for: indexPath) as! BarberDetailsTblCell
            cell.selectionStyle = .none
            if objProfileData != nil{
                cell.prepareTotalReview(data: objProfileData!)
                cell.prepareProgressReview(data: objProfileData!)
                cell.prepareReviews(data: objProfileData!)
            }
            btnBook.isHidden = true
            return cell
        }else {
            if objProfileData != nil{
                if  objProfileData!.dictTerms != nil{
                    cell = tableView.dequeueReusableCell(withIdentifier: "termsConditionCell", for: indexPath) as! BarberDetailsTblCell
                    cell.selectionStyle = .none
                    btnBook.isHidden = true
                    if objProfileData != nil{
                        if let terms = objProfileData!.dictTerms{
                            cell.lblTermsCondition.text = terms.content
                        }
                    }
                    return cell
                }else{
                    let cell : NoDataTableCell
                    cell = tableView.dequeueReusableCell(withIdentifier: "noDataCell") as! NoDataTableCell
                    cell.setText(str: "No Data Available")
                    return cell
                }
            }else{
                let cell : NoDataTableCell
                cell = tableView.dequeueReusableCell(withIdentifier: "noDataCell") as! NoDataTableCell
                cell.setText(str: "No Data Available")
                return cell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if enumTabTypes == .Terms || enumTabTypes == .Pricing{
            if objProfileData == nil{
                return 200.widthRatio
            }else{
                return UITableView.automaticDimension
            }
        }else if enumTabTypes == .Portfolio{
            return tableView.frame.height
        }else{
            return UITableView.automaticDimension
        }
        
    }
}


//MARK:- Favorite & UnFavorite Barber WebCall Methods
extension BarberDetailsVC{
    func favUnFav(param:[String:Any]){
        showHud()
        KPWebCall.call.favoriteUnFavoriteBarber(param: param) {[weak self] (json, statusCode) in
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


//MARK:- Barber Profile WebCall Methods
extension BarberDetailsVC{
    func barberProfile(){
        showHud()
        KPWebCall.call.getDriverData(param: ["barber_id" : barberObject.barberId]) {[weak self] (json, statusCode) in
            guard let weakSelf = self, let dict = json as? NSDictionary else {return}
            if statusCode == 200{
                weakSelf.hideHud()
                if let res = dict["result"] as? NSDictionary{
                    weakSelf.objProfileData = BarberProfileDetails(dict: res)
                }
                if weakSelf.objProfileData != nil{
                    weakSelf.btnChat.isHidden = weakSelf.objProfileData!.chat ? false : true
                }
                weakSelf.tableView.reloadData()
            }else{
                weakSelf.showError(data: json, view: weakSelf.view)
            }
        }
    }
}
