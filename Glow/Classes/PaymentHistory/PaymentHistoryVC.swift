//
//  PaymentHistoryVC.swift
//  Fade
//
//  Created by Devang Lakhani  on 4/13/21.
//  Copyright © 2021 Devang Lakhani. All rights reserved.
//

import UIKit

class PaymentHistoryVC: ParentViewController {
    @IBOutlet weak var lblTotalExpence : UILabel!
    var loadMore = LoadMore()
    var pagination = Pagination()
    var arrExpances : [TotalExpance] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        getPaymentHistory()
        prepareUI()
    }
}

//MARK:- Others Methods
extension PaymentHistoryVC{
    func prepareUI(){
        getNoDataCell()
        tableView.allowsSelection = false
        tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 15, right: 0)
    }
}

//MARK:- TableView Delegate & DataSource Methods
extension PaymentHistoryVC{
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if arrExpances.isEmpty{
            return 1
        }
        return arrExpances.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if arrExpances.isEmpty{
            let cell : NoDataTableCell
            cell = tableView.dequeueReusableCell(withIdentifier: "noDataCell") as! NoDataTableCell
            cell.setText(str: "No payment history was found")
            return cell
        }
        let cell : PaymentHistoryTblCell
        cell = tableView.dequeueReusableCell(withIdentifier: "historyCell", for: indexPath) as! PaymentHistoryTblCell
        cell.parentVC = self
        cell.prepareCell(data: arrExpances[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if arrExpances.isEmpty{
            return 100.widthRatio
        }
        return 75.widthRatio
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
                self.getPaymentHistory()
            }
        }
    }
}

//MARK:- Get Total Expances
extension PaymentHistoryVC{
    
    func getPaymentHistory(){
        showHud()
        KPWebCall.call.getPaymentHistory(param: ["page": pagination.pageNo]) {[weak self] (json, statusCode) in
            guard let weakSelf = self,let dict = json as? NSDictionary else {return}
            if statusCode == 200, let result = dict["result"] as? NSDictionary{
                weakSelf.hideHud()
                if let totalExpance = result["totalExpense"] as? Int{
                    weakSelf.lblTotalExpence.text = "£ " + "\(totalExpance)"
                }
                if let order = result["order"] as? NSDictionary{
                    if let arrData = order["data"] as? [NSDictionary]{
                        for data in arrData{
                            let objData = TotalExpance(dict: data)
                            weakSelf.arrExpances.append(objData)
                        }
                    }
                }
                weakSelf.tableView.reloadData()
            }
        }
    }
}
