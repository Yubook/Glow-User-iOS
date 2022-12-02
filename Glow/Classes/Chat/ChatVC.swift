//
//  ChatVC.swift
//  Fade
//
//  Created by Devang Lakhani  on 4/8/21.
//  Copyright © 2021 Devang Lakhani. All rights reserved.
//

import UIKit
import Reachability

class ChatVC: ParentViewController {
    var arrSectionIndex : [(key : String, value: [DriversOnChat])] = []
    var driverObj : ChatList?
    var arrDrivers : [DriversOnChat] = []
    var arrAdmin : [DriversOnChat]{
        return arrDrivers.filter{$0.role == "admin"}
    }
    var arrBarber : [DriversOnChat]{
        return arrDrivers.filter{$0.role == "barber"}
    }
    let reach = try! Reachability()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUI()
        prepareConnectionObserver()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        reachabilityCheck()
    }
    
    deinit {
        reach.stopNotifier()
    }
}

//MARK:- Others Methods
extension ChatVC{
    func prepareUI(){
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: _tabBarHeight + 10, right: 0)
        refresh.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        tableView.addSubview(refresh)
        getNoDataCell()
    }
    
    @objc func refreshData() {
        SocketManager.shared.getInboxList()
    }
    
    func prepareConnectionObserver(){
        _defaultCenter.addObserver(self, selector: #selector(gotInboxList(noti:)), name: NSNotification.Name.init(_observerInboxListData), object: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "messageList"{
            let vc = segue.destination as! MessagesListVC
            if let objDriver = sender as? DriversOnChat{
                vc.objDataInbox = objDriver
            }
        }
    }
    
    func reachabilityCheck(){
        DispatchQueue.main.async {
            self.reach.whenReachable = {reach in
                if reach.connection == .wifi || reach.connection == .cellular{
                    if SocketManager.shared.socket.status == .connected{
                        SocketManager.shared.getInboxList()
                    }
                    
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
extension ChatVC{
    func numberOfSections(in tableView: UITableView) -> Int {
        if arrAdmin.count > 0  && arrBarber.count > 0{
            return 2
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionView = tableView.dequeueReusableCell(withIdentifier: "sectionCell") as! ChatListTblCell
        if section == 0{
            sectionView.lblRoleName.text = "Admin"
        }else if arrBarber.count > 0{
            sectionView.lblRoleName.text = "Barbers"
        }
        return sectionView
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? arrAdmin.count : arrBarber.isEmpty ? 1 : arrBarber.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            let cell : ChatListTblCell
            cell = tableView.dequeueReusableCell(withIdentifier: "msglistCell", for: indexPath) as! ChatListTblCell
            cell.prepareInboxUI(data: arrAdmin[indexPath.row])
            cell.selectionStyle = .none
            return cell
        }else{
            if arrBarber.isEmpty{
                let cell: NoDataTableCell
                cell = tableView.dequeueReusableCell(withIdentifier: "noDataCell", for: indexPath) as! NoDataTableCell
                cell.setText(str: "You have no messages")
                cell.selectionStyle = .none
                return cell
            }else if arrBarber.count > 0 {
                let cell : ChatListTblCell
                cell = tableView.dequeueReusableCell(withIdentifier: "msglistCell", for: indexPath) as! ChatListTblCell
                cell.prepareInboxUI(data: arrBarber[indexPath.row])
                cell.selectionStyle = .none
                return cell
            } else {
                return UITableViewCell()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return  40.widthRatio
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 0 ? 80.widthRatio : arrBarber.isEmpty ? 100.widthRatio : 80.widthRatio
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1{
            guard !arrBarber.isEmpty else{return}
            let objBarber = arrBarber[indexPath.row]
            if objBarber.role == "user" &&  !objBarber.arrOrders.isEmpty{
                let data = objBarber.arrOrders.first!
                let service = data.arrServices.first!
                if data.isOrderCompleted == 0 && service.getTimeAndDate() > service.startChatTime && service.getTimeAndDate() < service.chatEndTime{
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: "messageList", sender: objBarber)
                    }
                }else{
                    self.showAlert(title: "", msg: "You can Chat with Barber Before 1 Hour of your Order Time")
                }
            }else{
                self.showAlert(title: "", msg: "You can Chat with Barber Order is Completed!!")
            }
        }else{
            let objAdmin = arrAdmin[indexPath.row]
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "messageList", sender: objAdmin)
            }
        }
    }
}


//MARK:- Get Inbox Data
extension ChatVC{
    
    func setListByDriver() {
        guard let obj = driverObj else {return}
        let inboxDict =  Dictionary(grouping: obj.arrDrivers, by: { $0.name })
        self.arrSectionIndex = Array(inboxDict)
        self.arrSectionIndex.sort { (obj, obj1) -> Bool in
            return obj1.key > obj.key
        }
        self.tableView.reloadData()
    }
    
    @objc func gotInboxList(noti : NSNotification){
        if !refresh.isRefreshing {
            showHud()
        }
        if let jsonData = noti.userInfo?["inboxData"] as? NSDictionary {
            self.arrDrivers = []
            if let driverDict = jsonData["barbers"] as? [NSDictionary]{
                for dictDriver in driverDict{
                    let data = DriversOnChat(dict: dictDriver)
                    self.arrDrivers.append(data)
                }
            }
            if let adminDict = jsonData["admin"] as? [NSDictionary]{
                for dictAdmin in adminDict{
                    let admin = DriversOnChat(dict: dictAdmin)
                    self.arrDrivers.append(admin)
                }
            }
            self.hideHud()
            self.refresh.endRefreshing()
            self.tableView.reloadData()
        }else {
            self.showError(msg: kInternalError)
        }
    }
    
    func showAlert(title : String, msg: String){
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
