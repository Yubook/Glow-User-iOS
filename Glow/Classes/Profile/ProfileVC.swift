//
//  ProfileVC.swift
//  Fade
//
//  Created by Devang Lakhani  on 4/8/21.
//  Copyright © 2021 Devang Lakhani. All rights reserved.
//

import UIKit
import FirebaseAuth
import Reachability

class ProfileVC: ParentViewController {
    
    @IBOutlet weak var imgProfileView : UIImageView!
    @IBOutlet weak var lblUserName : UILabel!
    @IBOutlet weak var readView : UIView!
    
    var arrProfileData : [ProfileDetails] = []
    var isReadNotification = false
    let reach = try! Reachability()
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reachabilityCheck()
        setUserDetails()
        readView.isHidden = isReadNotification ? true : false
    }
    
    deinit {
        reach.stopNotifier()
    }
}

//MARK:- Others Methods
extension ProfileVC{
    func prepareUI(){
        setUserDetails()
        prepareData()
        tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: _tabBarHeight + 10, right: 0)
        if let isRead = _userDefault.object(forKey: "readNotification") as? Bool{
            isReadNotification = isRead
        }
        readView.isHidden = !isReadNotification ? false : true
    }
    
    @IBAction func btnNotificationTapped(_ sender: UIButton){
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let notiVC = storyboard.instantiateViewController(withIdentifier :"NotificationVC") as! NotificationVC
        self.navigationController?.pushViewController(notiVC, animated: true)
    }
    
    @IBAction func btnEditProfileTapped(_ sender: UIButton){
        self.performSegue(withIdentifier: "profileSetup", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "profileSetup"{
            if let vc = segue.destination as? EditProfileVC{
                vc.isEdit = true
            }
        }
    }
    
    func reachabilityCheck(){
        DispatchQueue.main.async {
            self.reach.whenReachable = {reach in
                if reach.connection == .wifi || reach.connection == .cellular{
                    print("Reachable through WiFi")
                }
            }
            self.reach.whenUnreachable = {_ in
                noInternetPage(mainVc: self, nav: self.navigationController!)
            }
            do{
                try self.reach.startNotifier()
            }catch{
                print("Not start Notifier")
            }
        }
    }
}

//MARK:- TableView Delegate & DataSource Methods
extension ProfileVC{
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrProfileData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : ProfileTblCell
        
        cell = tableView.dequeueReusableCell(withIdentifier: "featureCell", for: indexPath) as! ProfileTblCell
        
        cell.selectionStyle = .none
        cell.prepareCell(data: arrProfileData[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0{
            self.performSegue(withIdentifier: "bookingHistory", sender: nil)
        }else if indexPath.row == 1{
            self.performSegue(withIdentifier: "paymentHistory", sender: nil)
        }else if indexPath.row == 2{
            self.shareApp()
        }else if indexPath.row == 3{
            let storyboard = UIStoryboard(name: "Chat", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier :"MessagesListVC") as! MessagesListVC
            vc.name = "Customer Service"
            vc.groupId = "\(_userDefault.integer(forKey: "adminChatId"))"
            self.navigationController?.pushViewController(vc, animated: true)
        }else if indexPath.row == 4{
            UIAlertController.actionWith(title: "Sign Out?", message: "Are you sure you want to sign out?", style: .actionSheet, buttons: [kCancel,kYes], controller: self) { (action) in
                if action == kYes {
                    self.logOutUser()
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.widthRatio
    }
}

//MARK:- Prepare Data
extension ProfileVC{
    func prepareData(){
        var arrData : [ProfileDetails] = []
        arrData.append(contentsOf: [ProfileDetails(iconName: "ic_bookings", featureName: "Bookings "),ProfileDetails(iconName: "ic_payment_hiostory_new", featureName: "Payment History "),ProfileDetails(iconName: "ic_share_new", featureName: "Share Application "),ProfileDetails(iconName: "ic_help_new", featureName: "Help"),ProfileDetails(iconName: "ic_logOut", featureName: "Log Out")])
        
        self.arrProfileData.append(contentsOf: arrData)
    }
    
    func setUserDetails(){
        lblUserName.text = _user.name
        imgProfileView.kf.setImage(with: _user.profileUrl)
        if self.tabBarController != nil{
            let tabBar = self.tabBarController as! JTabBarController
            tabBar.tabBarView.imgView.kf.setImage(with: _user.profileUrl)
        }
    }
}


//MARK:- LogOut User
extension ProfileVC{
    func logOutUser(){
        let firebaseAuth = Auth.auth()
        do{
            try firebaseAuth.signOut()
            exitUser()
        }catch let error as NSError{
            showError(msg: error.localizedDescription)
        }
    }
}


//MARK:- LogOut Webcall Methods
extension ProfileVC{
    func exitUser(){
        showHud()
        KPWebCall.call.logOutUser() {[weak self] (json, statusCode) in
            guard let weakSelf = self else{return}
            weakSelf.hideHud()
            if statusCode == 200{
                _appDelegator.removeUserInfoAndNavToLogin()
            }else{
                weakSelf.showError(data: json, view: weakSelf.view)
            }
        }
    }
}

//MARK:- OfferView Methods
extension ProfileVC{
    func prepareOfferView(){
        if let offerDiscount = _userDefault.object(forKey: "discount") as? String,let offerService = _userDefault.object(forKey: "service") as? String{
            let offerView = OffersPopup(nibName: "OffersPopup", bundle: nil)
            offerView.modalPresentationStyle = .overCurrentContext
            self.present(offerView, animated: true, completion: nil)
            offerView.lblPrice.text = "Get \(offerDiscount)% Off"
            offerView.lblDescription.text = "\(offerService)"
            offerView.handleTappedAction { tapped in
                if tapped == .cancel{
                    offerView.dismiss(animated: false, completion: nil)
                }else{
                    
                    offerView.dismiss(animated: false, completion: nil)
                }
            }
        }else{
            self.showAlert(title: "", msg: "Sorry! No Offer Available")
        }
    }
    func showAlert(title : String, msg: String){
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        self.present(alert, animated: true, completion: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.dismiss(animated: true, completion: nil)
        }
    }
}

//MARK:- Invite Friends Methods
extension ProfileVC{
    func shareApp(){
        let otherName = "Fade App \nGet the best deal to book your appointment with fade. \nInstall App Now \nDownload Android App \n" + "\(URL(string: "https://developer.apple.com/swift/")!)" + "\nDownload iOS App \n" + "\(URL(string: "https://developer.apple.com/swift/")!)"
        let objectsToShare = [otherName]
        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        self.present(activityVC, animated: true, completion: nil)
    }
}
