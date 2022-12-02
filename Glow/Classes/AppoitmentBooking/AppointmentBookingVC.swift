//
//  AppointmentBookingVC.swift
//  Fade
//
//  Created by Devang Lakhani  on 4/12/21.
//  Copyright © 2021 Devang Lakhani. All rights reserved.
//

import UIKit
import FSCalendar


class AppointmentBookingVC: ParentViewController {
    
    @IBOutlet weak var imgProfileView : UIImageView!
    @IBOutlet weak var lblName : UILabel!
    @IBOutlet weak var calander : FSCalendar!
    @IBOutlet weak var btnBack : UIButton!
    @IBOutlet weak var lblSelectedSlotNumber :  UILabel!
    var arrDriverDetails : [NearestDriver] = []
    var objBarber : NearestBarber!
    var arrAppoitnmentSlots : [AppotnmentBooking] = []
    var arrSelectedServices : [BarberService] = []
    var selectedDate : String?
    var driverId : String?
    var isSlotSelected : Bool = false
    var todayDate : Date!
    var oldSlotId : String?
    var selectedSlotId : String?
    var cancelDriverId : String?
    var isCancelOrder : Bool = false
    var driverImage : URL?
    var driverName : String?
    var objWalletDetails : Wallet?
    var slotRequire = 0
    var selctedSlot = 0
    
    var arrFilterAppoitnment : [AppotnmentBooking]{
        return arrAppoitnmentSlots.sorted { (s1, s2) -> Bool in
            return s1.timeSlots!.time.localizedStandardCompare(s2.timeSlots!.time) == .orderedAscending
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUI()
    }
}

//MARK:- Others Methods
extension AppointmentBookingVC{
    func prepareUI(){
        setCalander()
        prepareOtherData()
        btnBack.isHidden = isCancelOrder ? true : false
        collectionView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        todayDate = calander.today
        getAvailbleSlots()
        getCollNoDataCell()
    }
    
    func prepareOtherData(){
        lblSelectedSlotNumber.text = "Slots need to select : " + "\(arrSelectedServices.count)"
        imgProfileView.kf.setImage(with: objBarber.profileUrl)
        lblName.text = objBarber.name.capitalizingFirstLetter()
    }
    
    func getTodayDate() -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: todayDate)
    }
    
    func getTimeAndDate() -> String{
        let dateFormatter : DateFormatter = DateFormatter()
        //  dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        let date = Date()
        let dateString = dateFormatter.string(from: date)
        return dateString
    }
    
    func getCurrentTime() -> String{
        let date = Date()
        let getTime = date.getTime()
        return "\(getTime.hour)" + ":" + "\(getTime.minute)" + ":" + "\(getTime.seconds)"
    }
    
    @IBAction func btnRequestPayment(_ sender: UIButton){
        if isCancelOrder{
            isSlotSelected ? self.cancelBooking() : self.showError(msg: "Please Select Available Slot")
        }else{
            let arrSelectedSlot = arrAppoitnmentSlots.filter{$0.isSelected}
            if arrSelectedSlot.count > slotRequire{
                self.showError(msg: "You need to select minimum " + "\(slotRequire)")
            }else if arrSelectedSlot.count == slotRequire{
                let storyboard = UIStoryboard(name: "Home", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier :"PaymentDetailsVC") as! PaymentDetailsVC
                vc.arrSelectedServices = arrSelectedServices
                vc.objBarberData = objBarber
                vc.arrSlotData = arrSelectedSlot
                self.navigationController?.pushViewController(vc, animated: true)
            }else{
                self.showError(msg: "You need to select only " + "\(slotRequire)")
            }
            //isSlotSelected ? self.performSegue(withIdentifier: "selectServices", sender: (arrAppoitnmentSlots,arrDriverDetails,objWalletDetails)) : self.showError(msg: "Please Select Available Slot")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "selectServices"{
            let vc = segue.destination as! SelectServicesVC
            if let data = sender as? ([AppotnmentBooking], [NearestDriver],Wallet){
                vc.arrAppoitnmentSlots = data.0
                vc.arrDriversDetails = data.1
                vc.objWalletDetails = data.2
            }
        }
    }
    
    func getSubStringTime(time : String) -> String{
        let subStr = time.prefix(5)
        return String(subStr)
    }
    
    func getTimeDifferentFormate() -> String{
        let date = Date()
        let getTime = date.getTime()
        return "\(getTime.hour)" + ":" + "\(getTime.minute)"
    }
    
    func setSelectedSlot(ind : Int){
        for (idx,slot) in arrFilterAppoitnment.enumerated(){
            guard let timeSlots = slot.timeSlots else {return}
            let timeDate = slot.strSlotDate + " " + self.getSubStringTime(time: timeSlots.time)
            let timeDate1 = getTimeAndDate()
            if idx == ind{
                selectedSlotId = slot.id
                if slot.isBooked || timeDate < timeDate1{
                    slot.isSelected = false
                    isSlotSelected = slot.isSelected
                }else{
                    slot.isSelected.toggle()
                    isSlotSelected = slot.isSelected
                }
            }
        }
        self.collectionView.reloadData()
    }
    
}

//MARK:- CollectionView Delegate & DataSource Methods
extension AppointmentBookingVC : UICollectionViewDelegate, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if arrFilterAppoitnment.isEmpty{
            return 1
        }
        return arrFilterAppoitnment.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if arrFilterAppoitnment.isEmpty{
            let cell : EmptyCollCell
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "noDataCell", for: indexPath) as! EmptyCollCell
            cell.setText(str: "No Available Slots")
            return cell
        }else{
            let cell : AppoitnmentBookCollCell
            let objData = arrFilterAppoitnment[indexPath.row]
            
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "timeCell", for: indexPath) as! AppoitnmentBookCollCell
            cell.parent = self
            cell.prepareCell(data: objData)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        setSelectedSlot(ind: indexPath.row)
        let selectedData = arrFilterAppoitnment.filter{$0.isSelected}
        print(selectedData)
    }
}


//MARK:- CollectionView Delegate Flow Layout Methods
extension AppointmentBookingVC : UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if arrFilterAppoitnment.isEmpty{
            let collHeight = 50.widthRatio
            let collWidth = collectionView.frame.size.width
            return CGSize(width: collWidth, height: collHeight)
        }
        let collHeight = 33.widthRatio
        let collWidth = collectionView.frame.size.width / 6.2
        return CGSize(width: collWidth, height: collHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
}


//MARK:- FSCalander Delegate & DataSource Methods
extension AppointmentBookingVC : FSCalendarDelegate, FSCalendarDataSource{
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let selectedDt = Date.localDateString(from: date)
        selectedDate = selectedDt
        self.getAvailbleSlots()
    }
    
    func minimumDate(for calendar: FSCalendar) -> Date {
        return calendar.today ?? Date()
    }
    
    func maximumDate(for calendar: FSCalendar) -> Date {
        return Date().getMaxBookingDate()
    }
}

//MARK:- FSCalander Others Methods
extension AppointmentBookingVC{
    func setCalander(){
        calander.allowsMultipleSelection = false
        calander.locale = Locale.current
        calander.placeholderType = .none
        calander.today = Date()
    }
}

//MARK:- Available Slots WebCall Methods
extension AppointmentBookingVC{
    func paramDict() -> [String : Any]{
        var dict : [String : Any] = [:]
        var totalTime = 0
        for data in arrSelectedServices{
            if let services = data.barberServiceDict{
                if let times = Int(services.time){
                    totalTime += times
                }
            }
        }
        dict["barber_id"] = objBarber.barberId
        dict["total_time"] = totalTime
        dict["date"] = selectedDate ?? getTodayDate()
        //  dict["driver_id"] = driverId ?? cancelDriverId
        return dict
    }
    
    func getAvailbleSlots(){
        showHud()
        KPWebCall.call.getBookingSlots(param: paramDict()) {[weak self] (json, statusCode) in
            guard let weakSelf = self else {return}
            weakSelf.hideHud()
            weakSelf.arrAppoitnmentSlots = []
            if statusCode == 200, let dict = json as? NSDictionary, let result = dict["result"] as? NSDictionary{
                if let slotRequire = result["slots_required"] as? Int{
                    weakSelf.slotRequire = slotRequire
                }
                if let slotsData = result["available_slots"] as? [NSDictionary]{
                    for dictData in slotsData{
                        let data = AppotnmentBooking(dict: dictData)
                        weakSelf.arrAppoitnmentSlots.append(data)
                    }
                    weakSelf.collectionView.reloadData()
                }
                
            }else{
                weakSelf.showError(data: json, view: weakSelf.view)
            }
        }
    }
}

//MARK:- Re-Schedual Order WebCall Methods
extension AppointmentBookingVC{
    func paramCancelOrder() -> [String: Any]{
        var dict : [String: Any] = [:]
        dict["old_slot_id"] = oldSlotId
        dict["new_slot_id"] = selectedSlotId
        dict["driver_id"] = cancelDriverId
        return dict
    }
    
    func cancelBooking(){
        showHud()
        KPWebCall.call.cancalBooking(param: paramCancelOrder()) {[weak self] (json, statusCode) in
            guard let weakSelf = self else{return}
            weakSelf.hideHud()
            if statusCode == 200, let dict = json as? NSDictionary{
                weakSelf.showSuccMsg(dict: dict)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    weakSelf.navigationController?.popViewController(animated: true)
                }
            }else{
                weakSelf.showError(data: json, view: weakSelf.view)
            }
        }
    }
}
