//
//  NearByVC.swift
//  Fade
//
//  Created by Devang Lakhani  on 4/8/21.
//  Copyright © 2021 Devang Lakhani. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Cosmos

class NearByVC: ParentViewController {
    @IBOutlet weak var lblBookingLocation : UILabel!
    @IBOutlet weak var tfInput : UITextField!
    @IBOutlet weak var appoitmentView : UIView!
    @IBOutlet weak var mapView : MKMapView!
    @IBOutlet weak var lblDName : UILabel!
    @IBOutlet weak var imgProfileView : UIImageView!
    @IBOutlet weak var lblDriverService : UILabel!
    @IBOutlet weak var ratingView : CosmosView!
    @IBOutlet weak var lblTotalRating : UILabel!
    @IBOutlet weak var readView : UIView!
    
    var currentLocation : CLLocation!
    var selectedAddress: SearchAddress!
    var locationManager : CLLocationManager!
    var arrNearestDriver : [NearestDriver] = []
    var isOfferAvailable : Bool = false
    var objOffer : Offer?
    var objWallet : Wallet?
    var driverId : String?
    var isNotificationRead : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupLocationManager()
        self.appoitmentView.isHidden = true
        readView.isHidden = isNotificationRead ? true : false
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.appoitmentView.isHidden  = false
            self.prepareAppoitmentView()
        }
    }
}

//MARK:- Others Methods
extension NearByVC{
    func prepareUI(){
        //getNearestDrivers()
        setupLocationManager()
        prepareLeftView()
        addDeviceToken()
        self.appoitmentView.isHidden = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.appoitmentView.isHidden  = false
            self.prepareAppoitmentView()
        }
        readView.isHidden = isNotificationRead ? true : false
    }
    
    func setupLocationManager(){
        locationManager = CLLocationManager()
        locationManager.requestAlwaysAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
        checkStatus()
    }
    
    @IBAction func btnBookAppoitmentTapped(_ sender: UIButton){
        self.performSegue(withIdentifier: "appoitnmentVC", sender: (self.arrNearestDriver,objWallet))
    }
    
    @IBAction func btnNotificationTapped(_ sender: UIButton){
        navToNotification()
    }
    
    func navToNotification() {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "notifiction", sender: nil)
        }
    }
    
    @IBAction func btnReviewTapped(_ sender: UIButton){
        let storyboard = UIStoryboard(name: "Profile", bundle: nil)
        
        let reviewVC = storyboard.instantiateViewController(withIdentifier :"ReviewListVC") as! ReviewListVC
        reviewVC.driverId = driverId!
        self.navigationController?.pushViewController(reviewVC, animated: true)
    }
    //MARK:- Location Search Methods
    @IBAction func btnSearchAddTap(sender: UIButton){
        self.performSegue(withIdentifier: "locationPickerSegue", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "appoitnmentVC"{
            let vc = segue.destination as! AppointmentBookingVC
            if let data = sender as? ([NearestDriver],Wallet){
                vc.arrDriverDetails = data.0
                vc.objWalletDetails = data.1
            }
        } else if segue.identifier == "locationPickerSegue"{
            let searchCon = segue.destination as! KPSearchLocationVC
            searchCon.selectionBlock = {[unowned self](add) -> () in
                self.setMapResion(lat: add.lat, long: add.long)
                self.tfInput.text = add.formatedAddress
                self.selectedAddress = add
                self.lblBookingLocation.text = add.address1
                self.addNewSearchBooking(param: ["latitude" : "\(add.lat)", "longitude" : "\(add.long)"])
            }
        }
    }
    
    func setMapResion(lat: Double, long: Double){
        var loc = CLLocationCoordinate2D()
        loc.latitude = lat
        loc.longitude = long
        
        var span = MKCoordinateSpan()
        span.latitudeDelta = 0.05
        span.longitudeDelta = 0.05
        
        var myResion = MKCoordinateRegion()
        myResion.center = loc
        myResion.span = span
        self.mapView.setRegion(myResion, animated: true)
    }
    
    func prepareLeftView(){
        tfInput.attributedPlaceholder = NSAttributedString(string: "Add a new booking location",attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        tfInput.layer.cornerRadius = 10
        tfInput.layer.borderWidth = 1
        tfInput.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    }
}

//MARK:- AddPin Annotation
extension NearByVC{
    func addCustomPin(){
        let obj = arrNearestDriver.first
        
        guard let data = obj else {return}
        guard let lati = Double(data.latitude) else {return}
        guard let long = Double(data.longitude) else {return}
        lblBookingLocation.text = data.address
        
        let location = CLLocationCoordinate2D(latitude: lati, longitude: long)
        let region = MKCoordinateRegion(center: location, span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005))
        self.mapView.setRegion(region, animated: true)
        //Pin
        let pin = CustomPin(pinTitle: data.name, pinSubtitle: data.address, location: location)
        mapView.addAnnotation(pin)
        mapView.delegate = self
    }
}

//MARK:- Get Current Location
extension NearByVC{
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

//MARK:- MKMapView Delegate Methods
extension NearByVC : MKMapViewDelegate, CLLocationManagerDelegate{
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation{
            return nil
        }
        
        let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "customannotation")
        annotationView.image = UIImage(named: "ic_truck_pin")
        annotationView.canShowCallout = true
        return annotationView
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location: CLLocation = manager.location else { return }
        fetchCityAndCountry(from: location) { city, country, locality,code,error in
            guard let city = city, let country = country,let locality = locality,let code = code, error == nil else { return }
            self.lblBookingLocation.text = city + ", " + country + "," + locality + "," + code
        }
    }
}


//MARK:- OfferView Methods
extension NearByVC{
    func fetchCityAndCountry(from location: CLLocation, completion: @escaping (_ city: String?, _ country:  String?,_ locality : String?, _ sub : String?  ,_ error: Error?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
            completion(placemarks?.first?.name,
                       placemarks?.first?.subLocality,
                       placemarks?.first?.country,
                       placemarks?.first?.locality,
                       error)
        }
    }
    func prepareOfferView(){
        let offerView = OffersPopup(nibName: "OffersPopup", bundle: nil)
        offerView.modalPresentationStyle = .overFullScreen
        self.present(offerView, animated: false, completion: nil)
        if let offerData = self.objOffer{
            offerView.lblPrice.text = "Get \(offerData.offerDiscount)% Off"
            if let offerService = offerData.offerService{
                offerView.lblDescription.text = "\(offerService.serviceName)"
            }
        }
        offerView.handleTappedAction { tapped in
            if tapped == .cancel{
                offerView.dismiss(animated: false, completion: nil)
            }else{
                
                offerView.dismiss(animated: false, completion: nil)
            }
        }
    }
}

//MARK:- Check Permissions
extension NearByVC{
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
                }
            }
        default: break
        }
    }
}

//MARK:- PrepareAppoitment View Methods
extension NearByVC{
    func prepareAppoitmentView(){
        if !appoitmentView.isHidden && !arrNearestDriver.isEmpty{
            if let driverData = arrNearestDriver.first{
                driverId = driverData.id
                imgProfileView.kf.setImage(with: driverData.profileUrl)
                lblDName.text = driverData.name
                let rounded = Double(driverData.avgRating)?.rounded()
                ratingView.rating = rounded ?? 0.0
                lblTotalRating.text = "Reviews " + driverData.totalRating
                for serviceData in driverData.arrService{
                    lblDriverService.text = serviceData.name
                }
            }
        }else{
            appoitmentView.isHidden = true
        }
    }
}

//MARK:- Web Call Methods
extension NearByVC{
    func getNearestDrivers(){
        showHud()
        KPWebCall.call.getDrivers {[weak self] (json, statusCode) in
            guard let weakSelf = self else {return}
            weakSelf.hideHud()
            if statusCode == 200, let dict = json as? NSDictionary, let result = dict["result"] as? [NSDictionary]{
                for res in result{
                    let objDict = NearestDriver(dict: res)
                    weakSelf.arrNearestDriver.append(objDict)
                    weakSelf.addCustomPin()
                }
            }else{
                weakSelf.showError(data: json, view: weakSelf.view)
            }
        }
    }
}

//MARK:- Add DeviceId & Token WebCall Methods
extension NearByVC{
    func paramDeviceIdTokenDict() -> [String : Any]{
        var dict : [String : Any] = [:]
        dict["device_id"] = _deviceId
        dict["push_token"] = _appDelegator.getFCMToken()
        dict["type"] = "1"
        dict["latest_latitude"] = "\(getCurrentLocation().lat)"
        dict["latest_longitude"] = "\(getCurrentLocation().long)"
        return dict
    }
    
    func addDeviceToken(){
        showHud()
        KPWebCall.call.setDeviceToken(param: paramDeviceIdTokenDict()) {[weak self] (json, statusCode) in
            guard let weakSelf = self else {return}
            weakSelf.hideHud()
            if statusCode == 200, let dict = json as? NSDictionary{
                weakSelf.getNearestDrivers()
                if let result = dict["result"] as? NSDictionary{
                    if let isRead = result["is_read"] as? Bool{
                        weakSelf.isNotificationRead = isRead
                        _userDefault.set(isRead, forKey: "readNotification")
                    }
                    if let checkOffer = result["checkoffer"] as? Bool{
                        weakSelf.isOfferAvailable = checkOffer
                        _userDefault.set(checkOffer, forKey: "checkOffer")
                        if checkOffer{
                            if let offerDict = result["offer"] as? NSDictionary{
                                let objOfferData = Offer(dict: offerDict)
                                weakSelf.objOffer = objOfferData
                                weakSelf.prepareOfferView()
                                _userDefault.set(objOfferData.offerDiscount, forKey: "discount")
                                _userDefault.set(objOfferData.offerService?.serviceName, forKey: "service")
                            }
                        }else{
                            _userDefault.removeObject(forKey: "discount")
                            _userDefault.removeObject(forKey: "service")
                        }
                    }
                    if let wallet = result["wallet"] as? NSDictionary{
                        let dictWallet = Wallet(dict: wallet)
                        weakSelf.objWallet = dictWallet
                    }
                }
            }else{
                weakSelf.showError(data: json, view: weakSelf.view)
            }
        }
    }
}


//MARK:- Add new Location Booking WebCall Methods
extension NearByVC{
    func addNewSearchBooking(param: [String: Any]){
        showHud()
        KPWebCall.call.searchOtherDrivers(param: param) {[weak self] (json, statusCode) in
            guard let weakSelf = self else {return}
            weakSelf.hideHud()
            weakSelf.arrNearestDriver = []
            if statusCode == 200, let dict = json as? NSDictionary{
                if let result = dict["result"] as? [NSDictionary]{
                    if result.isEmpty{
                        weakSelf.showError(msg: "No Driver found in NearBy Area")
                    }else{
                        for res in result{
                            let objDict = NearestDriver(dict: res)
                            weakSelf.arrNearestDriver.append(objDict)
                            weakSelf.addCustomPin()
                        }
                        weakSelf.appoitmentView.isHidden = false
                        weakSelf.prepareAppoitmentView()
                    }
                }
            }else{
                weakSelf.showError(data: json, view: weakSelf.view)
            }
        }
    }
}
