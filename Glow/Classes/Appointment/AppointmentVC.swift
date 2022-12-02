//
//  AppointmentVC.swift
//  Fade
//
//  Created by Devang Lakhani  on 4/8/21.
//  Copyright © 2021 Devang Lakhani. All rights reserved.
//

import UIKit
import Reachability

class AppointmentVC: ParentViewController {
    @IBOutlet weak var bookingSegment : UISegmentedControl!
    
    var cellType : EnumAppoitnmentsDetails = .previousCell
    var arrUserBookings : [Orders] = []
    var loadMore = LoadMore()
    var isCompletedOrder : Bool = false
    var todayDate = Date()
    var objBook : BookingList?
    var pagination = Pagination()
    var arrFilterPrevious : [PreviousBooking]{
        return objBook!.arrPreviousBooked.filter{$0.isOrderCompleted == 0}
    }
    var arrFilterCurrent : [PreviousBooking]{
        return objBook!.arrCurrentBooked.filter{$0.isOrderCompleted == 0}
    }
    var arrFilterFuture : [PreviousBooking]{
        return objBook!.arrFeatureBooked.filter{$0.isOrderCompleted == 0}
    }
    var arrTestData : [PreviousBooking] = []
    var arrFilterData : [PreviousBooking]{
        return arrTestData.filter{$0.isOrderCompleted == 0}
    }
    
    let reach = try! Reachability()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reachabilityCheck()
        
    }
    
    deinit {
        reach.stopNotifier()
    }
}

//MARK:- Others Methods
extension AppointmentVC{
    func prepareUI(){
        prepareSegment()
        getNewUserBookings()
        tableView.separatorStyle = .none
        tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: _tabBarHeight + 10, right: 0)
        getNoDataCell()
    }
    
    func prepareSegment() {
        let selectedTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        let normalTextAttributes = [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.1333333333, green: 0.137254902, blue: 0.1529411765, alpha: 1)]
        bookingSegment.setTitleTextAttributes(selectedTitleTextAttributes, for: .selected)
        bookingSegment.setTitleTextAttributes(normalTextAttributes, for: .normal)
    }
    
    @IBAction func segmentTapped(_ segment: UISegmentedControl){
        self.cellType = EnumAppoitnmentsDetails(idx: segment.selectedSegmentIndex)
        prepareSegment()
        if objBook != nil{
            if cellType == .previousCell{
                if arrFilterPrevious.isEmpty{
                    self.tableView.isHidden = true
                }else{
                    self.tableView.isHidden = false
                    tableView.reloadData()
                    tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
                }
            }else if cellType == .currentCell{
                if  arrFilterCurrent.isEmpty{
                    self.tableView.isHidden = true
                }else{
                    self.tableView.isHidden = false
                    tableView.reloadData()
                    tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
                }
            }else if cellType == .featureCell{
                if arrFilterFuture.isEmpty{
                    self.tableView.isHidden = true
                }else{
                    self.tableView.isHidden = false
                    tableView.reloadData()
                    tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
                }
            }
        }
    }
    
    @IBAction func btnCancelBookingTapped(_ sender: UIButton){
        var otherDictData : [String:Any] = [:]
        if objBook != nil {
            if cellType == .currentCell{
                let objCurrentData = arrFilterCurrent[sender.tag]
                otherDictData["user_id"] = _user.id
                if let barberData = objCurrentData.users{
                    otherDictData["barber_id"] = barberData.id
                }
                otherDictData["order_id"] = objCurrentData.orderId
            }else if cellType == .featureCell{
                let objfutureData = arrFilterFuture[sender.tag]
                otherDictData["user_id"] = _user.id
                if let barberData = objfutureData.users{
                    otherDictData["barber_id"] = barberData.id
                }
                otherDictData["order_id"] = objfutureData.orderId
            }
            otherDictData["cancle_by"] = "user"
            self.cancelOrderbyUser(param: otherDictData)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "barberData"{
            let vc = segue.destination as! BarberDataVC
            if let obj = sender as? PreviousBooking{
                vc.objBooking = obj
                if let barber = obj.users{
                    vc.barberObject = barber
                }
            }
        }
    }
    
    func reachabilityCheck(){
        DispatchQueue.main.async {
            self.reach.whenReachable = {reach in
                if reach.connection == .wifi || reach.connection == .cellular{
                    self.getNewUserBookings()
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
extension AppointmentVC{
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if objBook != nil{
            switch cellType{
            case .previousCell:
                return arrFilterPrevious.count
            case .currentCell:
                return arrFilterCurrent.count
            case .featureCell:
                return arrFilterFuture.count
            }
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : AppoitnmentTblCell
        if objBook != nil{
            cell = tableView.dequeueReusableCell(withIdentifier: "bookingDetailsCell", for: indexPath) as! AppoitnmentTblCell
            cell.selectionStyle = .none
            cell.parent = self
            if cellType == .currentCell{
                let obj = arrFilterCurrent[indexPath.row]
                cell.currentCell(current: obj)
                cell.btnCancal.tag = indexPath.row
            }else if cellType == .featureCell{
                let obj = arrFilterFuture[indexPath.row]
                cell.currentCell(current: obj)
                cell.btnCancal.tag = indexPath.row
            }else{
                let obj = arrFilterPrevious[indexPath.row]
                cell.currentCell(current: obj)
                cell.btnCancal.tag = indexPath.row
            }
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if objBook != nil{
            if cellType == .previousCell{
                let objPrevious = arrFilterPrevious[indexPath.row]
                self.performSegue(withIdentifier: "barberData", sender: objPrevious)
            }else if cellType == .currentCell{
                let objCurrent = arrFilterCurrent[indexPath.row]
                self.performSegue(withIdentifier: "barberData", sender: objCurrent)
            }else{
                let objFuture = arrFilterFuture[indexPath.row]
                self.performSegue(withIdentifier: "barberData", sender: objFuture)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if objBook != nil{
            if cellType == .previousCell || cellType == .currentCell || cellType == .featureCell{
                return UITableView.automaticDimension
            }
        }
        return 0
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.pagination.isDataLoading = false
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if ((tableView.contentOffset.y + tableView.frame.size.height) >= tableView.contentSize.height)
        {
            if !self.pagination.isDataLoading{
                self.pagination.isDataLoading = true
                self.pagination.pageNo = self.pagination.pageNo + 1
                self.pagination.limit = self.pagination.limit + 10
                self.pagination.offset = self.pagination.limit * self.pagination.pageNo
                self.getNewUserBookings()
            }
        }
    }
    
}

//MARK:- Get UserBookings Web Call Methods
extension AppointmentVC{
    func getNewUserBookings(){
        showHud()
        KPWebCall.call.getUserBookings(param: ["page_number": pagination.pageNo]) {[weak self] (json, statusCode) in
            guard let weakSelf = self, let dict = json as? NSDictionary else {return}
            weakSelf.hideHud()
           // weakSelf.showSuccMsg(dict: dict)
            if statusCode == 200{
                if let arrRes = dict["result"] as? NSDictionary{
                    let objData = BookingList(dict: arrRes)
                    weakSelf.objBook = objData
                    weakSelf.tableView.isHidden = objData.arrPreviousBooked.isEmpty ? true : false
                    weakSelf.tableView.isHidden = weakSelf.arrFilterFuture.isEmpty ? true : weakSelf.arrFilterCurrent.isEmpty ? true : false
                    weakSelf.tableView.reloadData()
                }
            }else{
                weakSelf.showError(data: json, view: weakSelf.view)
            }
        }
    }
}

//MARK:- CancelOrder by User WebCall Methods
extension AppointmentVC{
    func cancelOrderbyUser(param: [String:Any]){
        showHud()
        KPWebCall.call.cancelOrderUser(param: param) {[weak self] (json, statusCode) in
            guard let weakSelf = self, let dict = json as? NSDictionary else {return}
            if statusCode == 200{
                weakSelf.hideHud()
                weakSelf.showSuccMsg(dict: dict)
                weakSelf.getNewUserBookings()
            }else{
                weakSelf.showError(data: json, view: weakSelf.view)
            }
        }
    }
}

//MARK:- ActionSheet Method
extension AppointmentVC{
    func previewActionSheet(completion : ((UIAlertAction) -> Void)?){
        let alert = UIAlertController(title: "Cancel Order?", message: "Are you Sure want cancel this Order? This Order will not cancel permenent you need to book another new slot", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: completion))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

//MARK:- Date&Time Methods
extension AppointmentVC{
    func getTodayDateTime() -> String{
        let dateFormatter : DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        let date = Date()
        let dateString = dateFormatter.string(from: date)
        return dateString
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
}
