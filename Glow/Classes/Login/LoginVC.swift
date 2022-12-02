//
//  LoginVC.swift
//  Fade
//
//  Created by Devang Lakhani  on 4/8/21.
//  Copyright © 2021 Devang Lakhani. All rights reserved.
//

import UIKit
import Reachability
class LoginVC: ParentViewController {
    
    var objModel = Login()
    let reach = try! Reachability()
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13, *) {
            return .darkContent
        } else {
            return .default
        }
    }

    deinit {
        reach.stopNotifier()
    }
}

//MARK:- Others Methods
extension LoginVC{
    func prepareUI(){
        objModel.prepareData()
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
        tableView.contentInset = UIEdgeInsets(top: 80, left: 0, bottom: 0, right: 0)
    }

    @IBAction func btnLoginRegisterTapped(_ sender: UIButton){
        let validate = objModel.validatetData()
        if validate.isValid {
            //checkUserExist()
            reachabilityCheck()
        }else {
            showError(msg: validate.error)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "otp"{
            if let vc = segue.destination as? OtpVC{
                if let data = sender as? String{
                    vc.phone = data
                }
            }
        }
    }
    func reachabilityCheck(){
        DispatchQueue.main.async {
            self.reach.whenReachable = {reach in
                if reach.connection == .wifi || reach.connection == .cellular{
                    let number = self.objModel.arrData[1].value
                    self.performSegue(withIdentifier: "otp", sender: number)
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
extension LoginVC{
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objModel.arrData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : LoginTblCell
        
        let objData = objModel.arrData[indexPath.row]
        
        cell = tableView.dequeueReusableCell(withIdentifier: objData.cellType.cellId, for: indexPath) as! LoginTblCell
        cell.prepareMobileCell(data: objData, index: indexPath.row)
        cell.parentVC = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return objModel.arrData[indexPath.row].cellType.cellHeight
    }
}
