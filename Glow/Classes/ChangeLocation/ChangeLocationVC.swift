//
//  ChangeLocationVC.swift
//  Fade
//
//  Created by Chirag Patel on 29/09/21.
//  Copyright © 2021 Devang Lakhani. All rights reserved.
//

import UIKit

class ChangeLocationVC: ParentViewController {
    var arrLists : [ChangeLocation] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUI()
    }
}

//MARK:- Others Methods
extension ChangeLocationVC{
    func prepareUI(){
        setupData()
        tableView.separatorStyle = .none
        tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
    }
}

//MARK:- Prepare Data
extension ChangeLocationVC{
    func setupData(){
        self.arrLists.append(contentsOf: [ChangeLocation(title: "Use current location", img: UIImage(named: "ic_location")),ChangeLocation(title: "Post code", img: UIImage(named: "ic_search")),ChangeLocation(title: "Enter manually", img: UIImage(named: "ic_edit"))])
    }
}

//MARK:- TableView Delegate & DataSource Methods
extension ChangeLocationVC{
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrLists.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : ChangeLocationTblCell
        cell = tableView.dequeueReusableCell(withIdentifier: "changeLocationCell", for: indexPath) as! ChangeLocationTblCell
        cell.selectionStyle = .none
        cell.prepareCellData(data: arrLists[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 1{
            self.performSegue(withIdentifier: "postCode", sender: nil)
        }else if indexPath.row == 2{
            self.performSegue(withIdentifier: "manuallyLocation", sender: nil)
        }else{
            self.performSegue(withIdentifier: "currLocation", sender: nil)
        }
    }
}
