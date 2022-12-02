//
//  NewHomeVC.swift
//  Fade
//
//  Created by Chirag Patel on 27/09/21.
//  Copyright © 2021 Devang Lakhani. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Reachability

class NewHomeVC: ParentViewController {
    @IBOutlet weak var notiView : UIView!
    @IBOutlet weak var tfSearch : UITextField!
    @IBOutlet weak var lblCurrentLocation : UILabel!
    @IBOutlet weak var lblLocationTitle : UILabel!

    var arrEnumHome : [EnumNewHome] = [.service,.nearestBarber]
    var isFilter : Bool = false
    var arrServices : [Services] = []
    var arrBarbers : [NearestBarber] = []
    var currentLocation : CLLocation!
    var locationManager : CLLocationManager!
    var isNotificationRead : Bool = false
    var isOfferAvailable : Bool = false
    var type = 0
    var otherDict : [String:Any] = [:]
    var filterId = ""
    var updatedLat = 0.0
    var updatedLong = 0.0
    var tempArray : [NearestBarber] = []
    var arrFilterBarber: [NearestBarber] = []
    var arrSearchBarbers : [NearestBarber] = []
    var arrSearchServices : [Services] = []
    var arrSelectedServices : [Services]{
        return arrServices.filter{$0.isSelected}
    }
    let reach = try! Reachability()
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
        _defaultCenter.addObserver(self, selector: #selector(willEnterForeGround), name: UIApplication.willEnterForegroundNotification, object: nil)
        setupLocationManager()
        checkStatus()
        reachabilityCheck()
        _defaultCenter.addObserver(self, selector: #selector(getNotiData(_:)), name: NSNotification.Name("corrdinates"), object: nil)
    }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13, *) {
            return .darkContent
        } else {
            return .default
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    deinit {
        reach.stopNotifier()
    }
}

//MARK:- Others Methods
extension NewHomeVC{
    func prepareUI(){
        getNoDataCell()
        tableView.separatorStyle = .none
        tableView.contentInset = UIEdgeInsets(top: 15, left: 0, bottom: _tabBarHeight + 10, right: 0)
        lblCurrentLocation.text = strCurrentLocation
        if strCurrentLocation !=  "Current Location" {
            lblLocationTitle.text = "Change Address"
        } else {
            lblLocationTitle.text = "Select Address"
        }
    }
    
    
    
    @objc func getNotiData(_ noti : Notification){
        if let dict = noti.userInfo as NSDictionary?{
            if let location = dict["latLong"] as? CLLocation{
                updateLatitutde = location.coordinate.latitude
                updateLongitude = location.coordinate.longitude
                updatedLat = location.coordinate.latitude
                updatedLong = location.coordinate.longitude
                self.getNearbyBarber()
            }
        }
    }
    
    func filterServices(servicesName: [String]) -> [NearestBarber] {
        arrBarbers = tempArray
        arrFilterBarber = []
        for barber in arrBarbers {
            for service in barber.arrBarberServices {
                if let barberServiceDict = service.barberServiceDict {
                    for selectedService in servicesName{
                        if selectedService == barberServiceDict.name{
                            if !arrFilterBarber.contains(where: {$0.barberId == barber.barberId}){
                                arrFilterBarber.append(barber)
                            }
                        }
                    }
                }
            }
        }
        return arrFilterBarber
    }
    func setupLocationManager(){
        locationManager = CLLocationManager()
        locationManager.requestAlwaysAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.startUpdatingLocation()
        checkStatus()
    }
    
    @IBAction func btnSelectAddressTapped(_ sender: UIButton){
        self.performSegue(withIdentifier: "editLocation", sender: nil)
    }
    
    @IBAction func btnFilterTapped(_ sender: UIButton){
        isFilter = true
        self.performSegue(withIdentifier: "filter", sender: nil)
    }
    
    @IBAction func btnFavTapped(_ sender: UIButton){
        let objData = arrBarbers[sender.tag]
        objData.isFav.toggle()
        otherDict["user_id"] = _user.id
        otherDict["barber_id"] = objData.barberId
        if objData.isFav{
            otherDict["type"] = 1
            self.favUnFav(param: otherDict)
        }else{
            otherDict["type"] = 0
            self.favUnFav(param: otherDict)
        }
        self.tableView.reloadData()
    }
    
    @IBAction func btnNotificationTapped(_ sender: UIButton){
        self.performSegue(withIdentifier: "notifiction", sender: nil)
    }
    
    @IBAction func btnSearchTapped(_ sender: UIButton){
        sender.isSelected.toggle()
        if sender.isSelected{
            tfSearch.resignFirstResponder()
        }else{
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "filter"{
            let vc = segue.destination as! FilterVC
            vc.completion = {id in
                self.filterId = id
                if id == "1"{
                    self.arrBarbers = self.arrBarbers.sorted(by: {Double($0.avgRating)! > Double($1.avgRating)!})
                }else if id == "4"{
                    self.arrBarbers = self.arrBarbers.filter{$0.isAvaiable == 1}
                }else if id == "3"{
                    self.arrBarbers = self.arrBarbers.sorted(by: {Double($0.distance)! < Double($1.distance)!})
                }else if id == "2"{
                    self.arrBarbers = self.arrBarbers.sorted(by: { (o1, o2) -> Bool in
                        if !o1.arrBarberServices.isEmpty && !o2.arrBarberServices.isEmpty{
                            let price = o1.arrBarberServices.first!.servicePrice
                            let price1 = o2.arrBarberServices.first!.servicePrice
                            return Double(price)! < Double(price1)!
                        }else{
                            return false
                        }
                    })
                }
                self.tableView.reloadData()
            }
        }
    }
    
    func reachabilityCheck(){
        DispatchQueue.main.async {
            self.reach.whenReachable = {reach in
                if reach.connection == .wifi || reach.connection == .cellular{
                    self.getService()
                    self.addDeviceToken()
                    self.getNearbyBarber()
                    
                    print("Reachable through WiFi")
                }
            }
            self.reach.whenUnreachable = {_ in
                if #available(iOS 13.0, *) {
                    noInternetPage(mainVc: self, nav: self.navigationController!)
                } else {
                    // Fallback on earlier versions

                }
            }
            do{
                try self.reach.startNotifier()
            }catch{
                print("Not start Notifier")
            }
        }
    }

}

//MARK:- Check Permissions
extension NewHomeVC{
    func checkStatus(){
        let status = CLLocationManager.authorizationStatus()
        switch status{
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            return
        case .denied,.restricted:
            let location = EnableLocation(nibName: "EnableLocation", bundle: nil)
            location.modalPresentationStyle = .fullScreen
            self.present(location, animated: false, completion: nil)
            location.handleTappedAction { tapped in
                if tapped == .done{
                    UIApplication.shared.openURL(URL(string: UIApplication.openSettingsURLString)!)
                    self.dismiss(animated: true, completion: nil)
                }
            }
        case .authorizedWhenInUse,.authorizedAlways :
            self.dismiss(animated: true, completion: nil)
        default: break
        }
    }
    
    @objc func willEnterForeGround(){
        self.checkStatus()
    }
    
    func getCurrentLocation() -> (lat : Double, long : Double){
        var getLatLong  = (lat : 0.0, long: 0.0)
        if
            CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
                CLLocationManager.authorizationStatus() ==  .authorizedAlways
        {
            if let currLocation = locationManager.location{
                getLatLong.lat = currLocation.coordinate.latitude
                getLatLong.long = currLocation.coordinate.longitude
            }
            
        }
        return getLatLong
    }
}


//MARK:- TableView Delegate & DataSource Methods
extension NewHomeVC{
    func numberOfSections(in tableView: UITableView) -> Int {
        return arrEnumHome.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1{
            if arrBarbers.isEmpty{
                return 1
            }
            return arrBarbers.count
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionView = tableView.dequeueReusableCell(withIdentifier: "sectionCell") as! NewHomeTblCell
        sectionView.lblSectionTitle.text = arrEnumHome[section].sectionTitle
        sectionView.btnSection.isHidden = arrEnumHome[section] == .service ? true : false
        return sectionView
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 1{
            if arrBarbers.isEmpty{
                let cell : NoDataTableCell
                cell = tableView.dequeueReusableCell(withIdentifier: "noDataCell") as! NoDataTableCell
                cell.setText(str: "No Nearby Barber Found!!")
                return cell
            }
        }
        let cell : NewHomeTblCell
        cell = tableView.dequeueReusableCell(withIdentifier: arrEnumHome[indexPath.section].cellId, for: indexPath) as! NewHomeTblCell
        cell.parentVC = self
        if indexPath.section == 0{
            cell.serviceCollView.reloadData()
        }else{
            cell.btnFavorite.tag = indexPath.row
            cell.parpareBarber(data: arrBarbers[indexPath.row])
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1{
            if arrBarbers.isEmpty{
                return 200.widthRatio
            }
        }
        return arrEnumHome[indexPath.section].cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let storyboard = UIStoryboard(name: "Favorites", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier :"BarberDetailsVC") as! BarberDetailsVC

        let objBarber = arrBarbers[indexPath.row]
        vc.barberObject = objBarber
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30.widthRatio
    }
}


//MARK:- Get Service WebCall Methods
extension NewHomeVC{
    func getService(){
        showHud()
        KPWebCall.call.getServices(param: [:]) {[weak self] (json, statusCode) in
            guard let weakSelf = self, let dict = json as? NSDictionary else {return}
            weakSelf.arrServices = []
            if statusCode == 200{
                weakSelf.hideHud()
                //weakSelf.showSuccMsg(dict: dict)
                if let arrResult = dict["result"] as? [NSDictionary]{
                    for dictRes in arrResult{
                        let objData = Services(dict: dictRes)
                        weakSelf.arrServices.append(objData)
                    }
                }
                weakSelf.arrSearchServices = weakSelf.arrServices
                weakSelf.tableView.reloadData()
            }else{
                weakSelf.showError(data: json, view: weakSelf.view)
            }
        }
    }
}

//MARK:- Get NearBy Barber WebCall Methods
extension NewHomeVC{
    func paramBarberDict() -> [String:Any]{
        var dict : [String:Any] = [:]
        dict["latest_latitude"] = updatedLat == 0.0 ? getCurrentLocation().lat : updatedLat
        dict["latest_longitude"] = updatedLong == 0.0 ? getCurrentLocation().long : updatedLong
        return dict
    }
    
    func getNearbyBarber(){
        showHud()
        KPWebCall.call.getNearbyBarber(param: paramBarberDict()) {[weak self] (json, statusCode) in
            guard let weakSelf = self, let dict = json as? NSDictionary else {return}
            if statusCode == 200, let res = dict["result"] as? NSDictionary{
                weakSelf.hideHud()
                if let arrBarber = res["nearByBarbers"] as? [NSDictionary]{
                    weakSelf.arrBarbers = []
                    for nearBarberDict in arrBarber{
                        let objData = NearestBarber(dict: nearBarberDict)
                        weakSelf.arrBarbers.append(objData)
                    }
                    weakSelf.arrSearchBarbers = weakSelf.arrBarbers
                    weakSelf.tempArray = weakSelf.arrBarbers
                    weakSelf.tableView.reloadData()
                }
            }else{
                weakSelf.showError(data: json, view: weakSelf.view)
            }
        }
    }
}
//MARK:- Favorite & UnFavorite Barber WebCall Methods
extension NewHomeVC{
    func favUnFav(param:[String:Any]){
        showHud()
        KPWebCall.call.favoriteUnFavoriteBarber(param: param) {[weak self] (json, statusCode) in
            guard let weakSelf = self, let dict = json as? NSDictionary else {return}
            if statusCode == 200{
                weakSelf.hideHud()
                weakSelf.showSuccMsg(dict: dict)
            }else{
                weakSelf.showError(data: json, view: weakSelf.view)
            }
        }
    }
}

//MARK:- Add Device Id and Tokens
extension NewHomeVC{
    func paramDeviceIdTokenDict() -> [String:Any]{
        var dict : [String:Any] = [:]
        dict["device_id"] = _deviceId
        dict["push_token"] = _appDelegator.getFCMToken()
        dict["type"] = "1"
        dict["latest_latitude"] = getCurrentLocation().lat
        dict["latest_longitude"] = getCurrentLocation().long
        return dict
    }
    
    func addDeviceToken(){
        showHud()
        KPWebCall.call.setDeviceToken(param: paramDeviceIdTokenDict()) {[weak self] (json, statusCode) in
            guard let weakSelf = self else {return}
            weakSelf.hideHud()
            if statusCode == 200, let dict = json as? NSDictionary{
                if let result = dict["result"] as? NSDictionary{
                    if let isRead = result["is_read"] as? Bool{
                        weakSelf.isNotificationRead = isRead
                        weakSelf.notiView.isHidden = !isRead ? true : false
                        _userDefault.set(isRead, forKey: "readNotification")
                    }
                    let adminId = result.getIntValue(key: "customer_support_chat_id")
                    _userDefault.set(adminId, forKey: "adminChatId")
                }
            }else{
                weakSelf.showError(data: json, view: weakSelf.view)
            }
        }
    }
}

//MARK:- Search Methods
extension NewHomeVC{
    @IBAction func tfSearchEditingChanged(_ textField: UITextField){
        if tfSearch.text!.length != 0{
            self.arrBarbers.removeAll()
            self.arrServices.removeAll()
            
            for service in arrSearchServices{
                let range = service.name.lowercased().range(of: textField.text!, options: .caseInsensitive, range: nil, locale: nil)
                if range != nil{
                    self.arrServices.append(service)
                }
            }
            
            for barber in arrSearchBarbers{
                let range = barber.name.lowercased().range(of: textField.text!,options: .caseInsensitive,range: nil,locale: nil)
                if range != nil{
                    self.arrBarbers.append(barber)
                }
                
                for service in barber.arrBarberServices{
                    let range1 = service.barberServiceDict!.name.lowercased().range(of: textField.text!, options: .caseInsensitive, range: nil, locale: nil)
                    if range1 != nil{
                        if !arrBarbers.contains(where: {$0.barberId == barber.barberId}){
                            self.arrBarbers.append(barber)
                        }
                    }
                }
            }
        }else{
            self.arrServices = arrSearchServices
            self.arrBarbers = arrSearchBarbers
        }
        self.tableView.reloadData()
    }
}
