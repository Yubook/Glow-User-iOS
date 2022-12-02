//
//  NotificationVC.swift
//  Fade
//
//  Created by Devang Lakhani  on 4/13/21.
//  Copyright © 2021 Devang Lakhani. All rights reserved.
//

import UIKit

class NotificationVC: ParentViewController {
    var arrNotifications : [NotificationList] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUI()
        getNotificationList()
    }
    
}

//MARK:- Others Methods
extension NotificationVC{
    func prepareUI(){
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
        tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 15, right: 0)
        getNoDataCell()
        
    }
    
}

//MARK:- TableView Delegate & DataSource Methods
extension NotificationVC{
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if arrNotifications.isEmpty{
            return 1
        }
        return arrNotifications.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if arrNotifications.isEmpty{
            let cell : NoDataTableCell
            cell = tableView.dequeueReusableCell(withIdentifier: "noDataCell") as! NoDataTableCell
            cell.setText(str: "You don't have any new notifications")
            return cell
        }
        let cell : NotificationTblCell
        
        cell = tableView.dequeueReusableCell(withIdentifier: "notificationCell", for: indexPath) as! NotificationTblCell
        cell.selectionStyle = .none
        cell.prepareCell(data: arrNotifications[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if arrNotifications.isEmpty{
            return 100.widthRatio
        }
        return 90.widthRatio
    }
}


//MARK:- Get Notification List WebCall Methods
extension NotificationVC{
    func getNotificationList(){
        showHud()
        KPWebCall.call.getNotification {[weak self] (json, statusCode) in
            guard let weakSelf = self else {return}
            weakSelf.hideHud()
            if statusCode == 200,let dict = json as? NSDictionary{
                if let arrResult = dict["result"] as? [NSDictionary]{
                    for data in arrResult{
                        let dict = NotificationList(dict: data)
                        weakSelf.arrNotifications.append(dict)
                    }
                }
                weakSelf.readAllNotification()
                weakSelf.tableView.reloadData()
            }else{
                weakSelf.showError(data: json, view: weakSelf.view)
            }
            
        }
    }
}

//MARK:- Read All Notification
extension NotificationVC{
    func readAllNotification(){
        showHud()
        KPWebCall.call.readAllNotification {[weak self] (json, statusCode) in
            guard let weakSelf = self else {return}
            weakSelf.hideHud()
            if statusCode != 200{
                weakSelf.showError(data: json, view: weakSelf.view)
            }
        }
    }
}
