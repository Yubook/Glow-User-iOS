//
//  FavoritesVC.swift
//  Fade
//
//  Created by Chirag Patel on 27/09/21.
//  Copyright © 2021 Devang Lakhani. All rights reserved.
//

import UIKit
import Reachability

class FavoritesVC: ParentViewController {
    
    var arrFavBarbers : [NearestBarber] = []
    var otherDict : [String:Any] = [:]
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
extension FavoritesVC{
    func prepareUI(){
        getNoDataCell()
        tableView.contentInset = UIEdgeInsets(top: 22, left: 0, bottom: _tabBarHeight + 10, right: 0)
        tableView.separatorStyle = .none
    }
    
    @IBAction func btnFavTapped(_ sender: UIButton){
        let objData = arrFavBarbers[sender.tag]
        sender.isSelected.toggle()
        otherDict["user_id"] = _user.id
        otherDict["barber_id"] = objData.barberId
        if sender.isSelected{
            otherDict["type"] = 0
            self.favUnFav(param: otherDict)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "barberDetails"{
            let vc = segue.destination as! BarberDetailsVC
            if let objBarber = sender as? NearestBarber{
                vc.barberObject = objBarber
                vc.barberObject.isFav = true
            }
        }
    }
    func reachabilityCheck(){
        DispatchQueue.main.async {
            self.reach.whenReachable = {reach in
                if reach.connection == .wifi || reach.connection == .cellular{
                    self.getFavBarber()
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
extension FavoritesVC {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if arrFavBarbers.isEmpty{
            return 1
        }
        return arrFavBarbers.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if arrFavBarbers.isEmpty{
            let cell : NoDataTableCell
            cell = tableView.dequeueReusableCell(withIdentifier: "noDataCell") as! NoDataTableCell
            cell.setText(str: "You don't have a favourite barber")
            return cell
        }
        let cell : FavoritesTblCell
        cell = tableView.dequeueReusableCell(withIdentifier: "favBarberCell", for: indexPath) as! FavoritesTblCell
        cell.selectionStyle = .none
        cell.parpareBarber(data: arrFavBarbers[indexPath.row])
        cell.btnFavorite.tag = indexPath.row
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if arrFavBarbers.isEmpty{
            return 200.widthRatio
        }
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let objData = arrFavBarbers[indexPath.row]
        self.performSegue(withIdentifier: "barberDetails", sender: objData)
    }
}

//MARK:- Get Favorite Barber WebCall Methods
extension FavoritesVC{
    func getFavBarber(){
        showHud()
        KPWebCall.call.getFavBarber(param: [:]) {[weak self] (json, statusCode) in
            guard let weakSelf = self,let dict = json as? NSDictionary else {return}
            if statusCode == 200{
                weakSelf.hideHud()
               // weakSelf.showSuccMsg(dict: dict)
                weakSelf.arrFavBarbers = []
                if let arrResult = dict["result"] as? [NSDictionary]{
                    for dictRes in arrResult{
                        let objData = NearestBarber(dict: dictRes)
                        weakSelf.arrFavBarbers.append(objData)
                    }
                }
                weakSelf.tableView.reloadData()
            }else{
                weakSelf.showError(data: json, view: weakSelf.view)
            }
        }
    }
}

//MARK:- Unfavorite Barber WebCall Methods
extension FavoritesVC{
    func favUnFav(param:[String:Any]){
        showHud()
        KPWebCall.call.favoriteUnFavoriteBarber(param: param) {[weak self] (json, statusCode) in
            guard let weakSelf = self, let dict = json as? NSDictionary else {return}
            if statusCode == 200{
                weakSelf.hideHud()
                weakSelf.showSuccMsg(dict: dict)
                weakSelf.getFavBarber()
            }else{
                weakSelf.showError(data: json, view: weakSelf.view)
            }
        }
    }
}
