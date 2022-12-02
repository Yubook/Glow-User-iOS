//
//  PaymentDetailsVC.swift
//  Fade
//
//  Created by Devang Lakhani  on 4/12/21.
//  Copyright © 2021 Devang Lakhani. All rights reserved.
//

import UIKit
import Cosmos
import Stripe
import Alamofire
import CoreLocation

class PaymentDetailsVC: ParentViewController {
    @IBOutlet weak var imgProfileView : UIImageView!
    @IBOutlet weak var lbldriverName : UILabel!
    @IBOutlet weak var ratingView : CosmosView!
    @IBOutlet weak var lblService : UILabel!
    @IBOutlet weak var lblBookedService : UILabel!
    @IBOutlet weak var lblTotalCost : UILabel!
    @IBOutlet weak var lblTimeDay : UILabel!
    @IBOutlet weak var lblDriverTotalReview : UILabel!
    
    var selctedImgView : UIImageView?
    var objData = PaymentDetails()
    var arrDriverData : [NearestDriver] = []
    var arrSlotData : [AppotnmentBooking] = []
    var arrSelectedServices : [BarberService] = []
    var objBarberData : NearestBarber!
    var bookedService : SelectServices?
    var bookId : String?
    var amount : Double?
    var secretKey : String?
    var totalCost : String?
    var serviceId: String?
    var driverId: String?
    var transactionNum : String?
    var isOfferSelected : Bool = false
    var isOfferAvailabel : Bool = false
    var isWalletSelected : Bool = false
    var objWallet : Wallet?
    var walletId : String = ""
    var walletBalnce : String = ""
    var selectedWalletImg : UIImageView?
    var stripeToken : String?
    var locManager = CLLocationManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUI()
    }
}

//MARK:- Others Methods
extension PaymentDetailsVC{
    func prepareUI(){
        locManager.requestWhenInUseAuthorization()
        prepareDriverData()
        objData.prepareData()
        tableView.allowsSelection = false
        tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 15, right: 0)
        tableView.separatorStyle = .none
        getStripeToken()
    }
    
    func getCardCell(row: Int, section: Int = 0) -> PaymentDetailsTblCell? {
        let cell = tableView.cellForRow(at: IndexPath(row: row, section: section)) as? PaymentDetailsTblCell
        return cell
    }
    
    @IBAction func btnContinueTapped(_ sender: UIButton){
        if isWalletSelected{
            self.bookSlotUsingWallet()
        }else{
            let validateData = objData.isValidData()
            if validateData.isValid{
                self.generateStripeToken()
            }else{
                self.showError(msg: validateData.error)
            }
        }
    }
    
    @IBAction func btnReviewTapped(_ sender: UIButton){
        let storyboard = UIStoryboard(name: "Profile", bundle: nil)
        let reviewVC = storyboard.instantiateViewController(withIdentifier :"ReviewListVC") as! ReviewListVC
        reviewVC.driverId = driverId!
        self.navigationController?.pushViewController(reviewVC, animated: true)
    }
    
    @IBAction func btnCheckBoxTapped(_ sender: UIButton){
        /* sender.isSelected = !sender.isSelected
         isOfferSelected = sender.isSelected
         guard let imgView = selctedImgView else {return}
         imgView.image = UIImage(named: sender.isSelected ? "ic_check-box" : "ic_blank-check-box")
         if isOfferSelected{
         isWalletSelected = false
         selectedWalletImg?.image = UIImage(named: "ic_blank-check-box")
         }*/
    }
    
    @IBAction func btnWalletBoxTapped(_ sender : UIButton){
        /* let totalAmount = Int(walletBalnce)
         if totalAmount! > amount!{
         sender.isSelected = !sender.isSelected
         isWalletSelected = sender.isSelected
         guard let imgView = selectedWalletImg else {return}
         imgView.image = UIImage(named: sender.isSelected ? "ic_check-box" : "ic_blank-check-box")
         if isWalletSelected{
         isOfferSelected = false
         selctedImgView?.image = UIImage(named: "ic_blank-check-box")
         }
         }else{
         let alert = UIAlertController(title: "Sorry", message: "You do not have sufficient wallet balance to Payment, Please go through Card Payment", preferredStyle: .alert)
         alert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: nil))
         self.present(alert, animated: true, completion: nil)
         }*/
    }
}

//MARK:- TableView Delegate & DataSource Methods
extension PaymentDetailsVC{
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objData.arrData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : PaymentDetailsTblCell
        let obj = objData.arrData[indexPath.row]
        cell = tableView.dequeueReusableCell(withIdentifier: obj.cellType.cellId, for: indexPath) as! PaymentDetailsTblCell
        cell.parentVC = self
        cell.perpareCell(data: obj, idx: indexPath.row)
        /* if obj.cellType == .radioCell{
         if let isOfferAvailable = _userDefault.object(forKey: "checkOffer") as? Bool{
         if isOfferAvailable{
         selctedImgView = cell.imgCheckBox
         if let discountPrice = _userDefault.object(forKey: "discount") as? String{
         cell.lblWalletBalance.text = "Available Discount:- \(discountPrice)%"
         }
         
         }else{
         cell.isHidden = true
         }
         }
         } else */
        if obj.cellType == .walletCell{
            if let walletBalance = objWallet{
                selectedWalletImg = cell.imgCheck
                cell.lblBalance.text = "Wallet Balance :- \(walletBalance.amount)£"
            }else{
                cell.isHidden = true
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return objData.arrData[indexPath.row].cellType.cellHeight
    }
}

//MARK:- Prepare Success Popup
extension PaymentDetailsVC{
    func showSuccessPopup(){
        let successVC = EnableLocation(nibName: "EnableLocation", bundle: nil)
        successVC.modalPresentationStyle = .overFullScreen
        self.present(successVC, animated: false, completion: nil)
        successVC.lblTitle.isHidden = true
        successVC.lblDescription.text = "Your Appointment booking is successfully."
        successVC.imgIcon.image = UIImage(named: "ic_true")
        successVC.handleTappedAction { tapped in
            if tapped == .done{
                self.dismiss(animated: true, completion: nil)
                let storyboard = UIStoryboard(name: "Entry", bundle: nil)
                let tabVC = storyboard.instantiateViewController(withIdentifier :"JTabBarController") as! JTabBarController
                tabVC.selectedIndex = 3
                tabVC.tabBarView.selectedIndexTintColor(index: 3)
                self.navigationController?.pushViewController(tabVC, animated: true)
            }
        }
    }
}

//MARK:- Prepare Driver Data
extension PaymentDetailsVC{
    func prepareDriverData(){
        /* if let wallet = objWallet{
         walletId = wallet.id
         walletBalnce = wallet.amount
         }
         if let driverDetail = arrDriverData.first{
         driverId = driverDetail.id
         imgProfileView.kf.setImage(with: driverDetail.profileUrl)
         lbldriverName.text = driverDetail.name
         ratingView.rating = Double(driverDetail.avgRating) ?? 1.0
         lblDriverTotalReview.text = "Reviews " + driverDetail.totalRating
         for serviceData in driverDetail.arrService{
         lblService.text = serviceData.name
         }
         }
         if let bookService = bookedService{
         serviceId = bookService.id
         lblBookedService.text = bookService.serviceName
         lblTotalCost.text = "£ " + bookService.servicePrice
         amount = Int(bookService.servicePrice)
         }
         for slotBooking in arrSlotData{
         if let slots = slotBooking.timeSlots{
         if slotBooking.isSelected{
         bookId = slotBooking.id
         let firstTime = String(slots.time.prefix(5))
         lblTimeDay.text = slotBooking.strDate + convertFormat(time: firstTime)
         }
         }
         }*/
        
        // For Barbers
        driverId = objBarberData.barberId
        imgProfileView.kf.setImage(with: objBarberData.profileUrl)
        lbldriverName.text = objBarberData.name
        ratingView.rating = Double(objBarberData.avgRating) ?? 0.0
        lblDriverTotalReview.text = "Reviews " + objBarberData.totalReview
        if !objBarberData.arrBarberServices.isEmpty{
            let barberService = objBarberData.arrBarberServices.map{$0.barberServiceDict!.name}.filter{!$0.isEmpty}.joined(separator: ",")
            lblService.text = barberService
            
        }
        
        
        // For Services
        //serviceId = bookService.id
        let totalBookedService = arrSelectedServices.map{$0.barberServiceDict!.name}.filter{!$0.isEmpty}.joined(separator: ",")
        
        lblBookedService.text = totalBookedService
        let totalPrice = arrSelectedServices.map{Double($0.servicePrice)!}
        let totalCost = totalPrice.reduce(0) { (x, y) in
            return x + y
        }
        lblTotalCost.text = "£" + "\(totalCost)"
        amount = totalCost
        
        //For Appoitnments
        if !arrSlotData.isEmpty{
            let selectedDate = arrSlotData.first!.strDate
            let selectedTime = arrSlotData.first!.timeSlots!.time
            let firstTime = String(selectedTime.prefix(5))
            lblTimeDay.text = selectedDate + convertFormat(time: firstTime)
        }
    }
    
    func convertFormat(time: String) -> String{
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "HH:mm"
        let showDate = inputFormatter.date(from: time)
        inputFormatter.dateFormat = "HH:mm a"
        let resultString = inputFormatter.string(from: showDate!)
        return resultString
    }
}


//MARK:- Create Stipe Key Web Call Methods
extension PaymentDetailsVC{
    /* func getStripeToken(){
     showHud()
     let finalAmt = amount! * 100
     let discountAmount = getDiscountPrice(amount: finalAmt)
     KPWebCall.call.getStripeKey(param: isOfferSelected ? ["amount": discountAmount] : ["amount": finalAmt]) { [weak self](json, statusCode) in
     guard let weakSelf = self else {return}
     weakSelf.hideHud()
     if statusCode == 200, let dict = json as? NSDictionary{
     if let testKey = dict["client_secret"] as? String{
     weakSelf.secretKey = testKey
     weakSelf.proceedForPayment(stripClientKey: testKey)
     }
     }else{
     weakSelf.showError(data: json, view: weakSelf.view)
     }
     }
     } */
    func getStripeToken(){
        showHud()
        KPWebCall.call.getStripeKey() { [weak self](json, statusCode) in
            guard let weakSelf = self else {return}
            weakSelf.hideHud()
            if statusCode == 200, let dict = json as? NSDictionary{
                if let testKey = dict["secret_key"] as? String{
                    weakSelf.secretKey = testKey
                }
            }else{
                weakSelf.showError(data: json, view: weakSelf.view)
            }
        }
    }
}
/*
 //MARK:- Stripe Payment Methods
 extension PaymentDetailsVC{
 func proceedForPayment(stripClientKey: String?) {
 guard let paymentIntentClientSecret = stripClientKey else {
 return
 }
 let cardParams = STPPaymentMethodCardParams()
 let creditCardDict = objData.prepareCardDict()
 cardParams.number = creditCardDict["card_number"] as? String
 cardParams.cvc = creditCardDict["cvv"] as? String
 
 let expMonthYear = creditCardDict["expiration_date"] as! String
 let month = Int(expMonthYear.components(separatedBy: "/")[0])
 let year = Int(expMonthYear.components(separatedBy: "/")[1])
 
 cardParams.expMonth = month as NSNumber?
 cardParams.expYear = year as NSNumber?
 
 let name = objData.arrData[1].value
 let email = _user.email
 let phone = _user.phone
 
 //This is temproray harcoded key
 
 let billingDetails = STPPaymentMethodBillingDetails()
 if !email.isEmpty {
 billingDetails.email = email
 }
 billingDetails.name = name
 billingDetails.phone = phone
 
 let billingAddres = STPPaymentMethodAddress()
 billingAddres.city = _user.address
 billingAddres.country = "GB"
 billingDetails.address = billingAddres
 
 let paymentMethodParams = STPPaymentMethodParams(card: cardParams, billingDetails: billingDetails, metadata: nil)
 let paymentIntentParams = STPPaymentIntentParams(clientSecret: paymentIntentClientSecret)
 paymentIntentParams.paymentMethodParams = paymentMethodParams
 
 // Submit the payment
 let paymentHandler = STPPaymentHandler.shared()
 paymentHandler.confirmPayment(withParams: paymentIntentParams, authenticationContext: self) { (status, paymentIntent, error) in
 self.hideHud()
 switch status {
 case .succeeded:
 guard let payIntent = paymentIntent else {
 return
 }
 self.totalCost = "\(payIntent.amount)"
 self.transactionNum = payIntent.stripeId
 self.bookUserSlot()
 case .canceled:
 guard let err = error else{return}
 self.showError(msg: err.localizedDescription)
 case .failed:
 guard let err = error else{return}
 self.showError(msg: err.localizedDescription)
 @unknown default:
 fatalError()
 break
 }
 }
 }
 }
 
 extension PaymentDetailsVC: STPAuthenticationContext {
 func authenticationPresentingViewController() -> UIViewController {
 return self
 }
 } */

//MARK:- Generate Stripe Token
extension PaymentDetailsVC{
    func generateStripeToken(){
        KPWebCall.call.setAccesTokenToHeader(token: secretKey!)
        let header : HTTPHeaders = [
            "Accept": "application/json"
        ]
        showHud()
        KPWebCall.call.paymentByStripe(param: objData.prepareCardDict(), header: header) {[weak self] (json, statusCode) in
            guard let weakSelf = self else {return}
            if statusCode == 200, let dict = json as? NSDictionary{
                if let token = dict["id"] as? String{
                    weakSelf.stripeToken = token
                }
                var dictData = weakSelf.paramDictArray(selectedServices: weakSelf.arrSelectedServices, selectedSlot: weakSelf.arrSlotData)
                weakSelf.getAddressFromLatLon(pdblLatitude: updateLatitutde == 0.0 ? weakSelf.getCurrentLocation().lat : updateLatitutde, withLongitude: updateLongitude == 0.0 ? weakSelf.getCurrentLocation().long : updateLongitude) { (strAddress) in
                    dictData["address"] = strAddress
                    weakSelf.bookUserSlot(param: dictData)
                }
            }else{
                if let errorDict = json as? NSDictionary, let err = errorDict["error"] as? NSDictionary{
                    if let msg = err["code"] as? String{
                        weakSelf.showError(msg: msg)
                    }
                }
            }
        }
    }
}

//MARK:- AddUser Slots Web Call Methods
extension PaymentDetailsVC{
    func paramDictArray(selectedServices: [BarberService], selectedSlot: [AppotnmentBooking]) -> [String: Any]{
        let finalAmt = amount! * 100
        var arrDict : [String:Any] = [:]
        arrDict["service_ids"] = selectedServices.map{Int($0.barberServiceDict!.id)!}
        arrDict["slot_ids"] = selectedSlot.map{Int($0.id)!}
        arrDict["amount"] = finalAmt
        arrDict["card_token"] = stripeToken
        arrDict["user_id"] = _user.id
        arrDict["barber_id"] = driverId
        arrDict["payment_type"] = 1
        arrDict["latitude"] = updateLatitutde == 0.0 ? getCurrentLocation().lat : updateLatitutde
        arrDict["longitude"] = updateLongitude == 0.0 ? getCurrentLocation().long : updateLongitude
        return arrDict
    }
    
    func bookUserSlot(param: [String:Any]){
        KPWebCall.call.setAccesTokenToHeader(token: _appDelegator.getAuthorizationToken()!)
        showHud()
        KPWebCall.call.processPayment(param: param) {[weak self] (json, statusCode) in
            guard let weakSelf = self else {return}
            weakSelf.hideHud()
            if statusCode == 200, let dict = json as? NSDictionary{
                weakSelf.showSuccMsg(dict: dict)
                weakSelf.showSuccessPopup()
            }else{
                weakSelf.showError(data: json, view: weakSelf.view)
            }
        }
    }
}

//MARK:- Book User Slot using Wallet Balance
extension PaymentDetailsVC{
    func paramWalletDict() -> [String : Any]{
        var dict : [String : Any] = [:]
        dict["user_id"] = _user.id
        dict["slot_id"] = bookId
        dict["service_id"] = serviceId
        dict["driver_id"] = driverId
        dict["amount"] = amount
        dict["wallet_id"] = walletId
        return dict
    }
    
    func bookSlotUsingWallet(){
        showHud()
        KPWebCall.call.paymentUsingWallet(param: paramWalletDict()) {[weak self] (json, statusCode) in
            guard let weakSelf = self else {return}
            weakSelf.hideHud()
            if statusCode == 200, let dict = json as? NSDictionary{
                weakSelf.showSuccMsg(dict: dict)
                weakSelf.showSuccessPopup()
            }else{
                weakSelf.showError(data: json, view: weakSelf.view)
            }
        }
    }
}
//MARK:- Get Discount Price
extension PaymentDetailsVC{
    func getDiscountPrice(amount : Int?) -> Int{
        var discountAmount: Int = 0
        if let percentage = _userDefault.object(forKey: "discount") as? String{
            let intPercentage = Int(percentage)
            discountAmount = amount! - (amount! * intPercentage! / 100)
        }
        return discountAmount
    }
}


//MARK:- User Current LatLong and address
extension PaymentDetailsVC{
    func getCurrentLocation() -> (lat : Double, long : Double){
        var getLatLong  = (lat : 0.0, long: 0.0)
        if
            CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
                CLLocationManager.authorizationStatus() ==  .authorizedAlways
        {
            if let currLocation = locManager.location{
                getLatLong.lat = currLocation.coordinate.latitude
                getLatLong.long = currLocation.coordinate.longitude
            }
            
        }
        return getLatLong
    }
    
    func getAddressFromLatLon(pdblLatitude: Double, withLongitude pdblLongitude: Double, completion: @escaping ((String) -> ())) {
        var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
        let ceo: CLGeocoder = CLGeocoder()
        center.latitude = pdblLatitude
        center.longitude = pdblLongitude
        let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)
        ceo.reverseGeocodeLocation(loc, completionHandler:
                                    {(placemarks, error) in
                                        if (error != nil)
                                        {
                                            print("reverse geodcode fail: \(error!.localizedDescription)")
                                        }
                                        let pm = placemarks! as [CLPlacemark]
                                        if pm.count > 0 {
                                            let pm = placemarks![0]
                                            var addressString : String = ""
                                            if pm.subThoroughfare != nil{
                                                addressString = addressString + pm.subThoroughfare! + ", "
                                            }
                                            if pm.subLocality != nil {
                                                addressString = addressString + pm.subLocality! + ", "
                                            }
                                            if pm.thoroughfare != nil {
                                                addressString = addressString + pm.thoroughfare! + ", "
                                            }
                                            if pm.locality != nil {
                                                addressString = addressString + pm.locality! + ", "
                                            }
                                            if pm.country != nil {
                                                addressString = addressString + pm.country! + ", "
                                            }
                                            if pm.postalCode != nil {
                                                addressString = addressString + pm.postalCode! + " "
                                            }
                                            completion(addressString)
                                        }
                                    })
    }
}
