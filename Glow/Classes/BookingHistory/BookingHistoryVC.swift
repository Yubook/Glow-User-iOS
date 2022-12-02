//
//  BookingHistoryVC.swift
//  Fade
//
//  Created by Devang Lakhani  on 5/6/21.
//  Copyright © 2021 Devang Lakhani. All rights reserved.
//

import UIKit

class BookingHistoryVC: ParentViewController {
    @IBOutlet weak var segmentControl : UISegmentedControl!
    var statusType :EnumBookingStatus = .completed
    var arrOrders : [PreviousBooking] = []
    var objBook : BookingList?
    var pagination = Pagination()
    
    var arrCompletedOrders: [PreviousBooking] {
        return arrOrders.filter{$0.orderStatus == .completed}
    }
    
    var arrCancelledOrders: [PreviousBooking] {
        return arrOrders.filter{$0.orderStatus == .cancel}
    }
    
    var loadMore = LoadMore()
    var isOrderCancel : Int = 0
    var driverId : String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUI()
        getNewUserBookings()
        self.tableView.reloadData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // getOrders()
        
    }
}

//MARK:- Others Methods
extension BookingHistoryVC{
    func prepareUI(){
        tableView.separatorStyle = .none
        tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 15, right: 0)
        getNoDataCell()
        prepareSegment()
    }
    func prepareSegment() {
        let selectedTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        let normalTextAttributes = [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.1333333333, green: 0.137254902, blue: 0.1529411765, alpha: 1)]
        segmentControl.setTitleTextAttributes(selectedTitleTextAttributes, for: .selected)
        segmentControl.setTitleTextAttributes(normalTextAttributes, for: .normal)
    }
    
    @IBAction func statusSegmentTapped(_ segment : UISegmentedControl){
        if segment.selectedSegmentIndex == 0{
            self.statusType = EnumBookingStatus(val: 1)
        }else{
            self.statusType = EnumBookingStatus(val: 2)
        }
        prepareSegment()
        if statusType == .completed && arrCompletedOrders.isEmpty || statusType == .cancel && arrCancelledOrders.isEmpty{
            tableView.isHidden = true
        }else{
            tableView.reloadData()
            tableView.isHidden = false
            tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        }
    }
    
    @IBAction func btnAddReviewTapped(_ sender: UIButton){
        let storyboard = UIStoryboard(name: "Appointment", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier :"BarberDataVC") as! BarberDataVC

        if statusType == .completed{
            let objCompleted = arrCompletedOrders[sender.tag]
            vc.objBooking = objCompleted
            if let barber = objCompleted.users{
                vc.barberObject = barber
            }
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK:- TableView Delegate & DataSource Methods
extension BookingHistoryVC{
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return statusType == .completed ? arrCompletedOrders.count : arrCancelledOrders.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : BookingHistoryCell
        cell = tableView.dequeueReusableCell(withIdentifier: "bookingHistory", for: indexPath) as! BookingHistoryCell
        if !arrCompletedOrders.isEmpty || !arrCancelledOrders.isEmpty{
            let objOrder = statusType == .completed ? arrCompletedOrders[indexPath.row] : arrCancelledOrders[indexPath.row]
            cell.selectionStyle = .none
            cell.btnAddReview.tag = indexPath.row
            cell.prepareOrders(data: objOrder)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Appointment", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier :"BarberDataVC") as! BarberDataVC
        
        if statusType == .completed{
            let objData = arrCompletedOrders[indexPath.row]
            vc.objBooking = objData
            if let barber = objData.users{
                vc.barberObject = barber
            }
        }else if statusType == .cancel{
            let objData = arrCancelledOrders[indexPath.row]
            vc.objBooking = objData
            if let barber = objData.users{
                vc.barberObject = barber
            }
        }
        self.navigationController?.pushViewController(vc, animated: true)
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


//MARK:- Get Booked Service WebCall Methods
extension BookingHistoryVC{
    func getNewUserBookings(){
        showHud()
        KPWebCall.call.getUserBookings(param: ["page": pagination.pageNo]) {[weak self] (json, statusCode) in
            guard let weakSelf = self, let dict = json as? NSDictionary else {return}
            weakSelf.hideHud()
            //weakSelf.showSuccMsg(dict: dict)
            if statusCode == 200{
                if let arrRes = dict["result"] as? NSDictionary{
                    if let previousDict = arrRes["previous"] as? NSDictionary{
                        if let previousData = previousDict["data"] as? [NSDictionary]{
                            for data in previousData{
                                let dictData = PreviousBooking(dict: data)
                                weakSelf.arrOrders.append(dictData)
                            }
                        }
                    }
                    if let nextDict = arrRes["next"] as? NSDictionary{
                        if let nextData = nextDict["data"] as? [NSDictionary]{
                            for data in nextData{
                                let dictData = PreviousBooking(dict: data)
                                weakSelf.arrOrders.append(dictData)
                            }
                        }
                    }
                    if let currentDict = arrRes["today"] as? NSDictionary{
                        if let currData = currentDict["data"] as? [NSDictionary]{
                            for data in currData{
                                let dictData = PreviousBooking(dict: data)
                                weakSelf.arrOrders.append(dictData)
                            }
                        }
                    }
                    weakSelf.tableView.isHidden = weakSelf.arrOrders.isEmpty ? true : false
                    weakSelf.tableView.reloadData()
                }
            }else{
                weakSelf.showError(data: json, view: weakSelf.view)
            }
        }
    }
}
