//
//  FilterVC.swift
//  Fade
//
//  Created by Chirag Patel on 12/11/21.
//  Copyright © 2021 Devang Lakhani. All rights reserved.
//

import UIKit

class FilterVC: ParentViewController {
    
    var arrData : [FilterNew] = []
    var completion : ((String) -> ()) = {_ in}
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareData()
    }
}

//MARK:- TableView Delegate & DataSource Methods
extension FilterVC{
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : FilterTblCell
        cell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath) as! FilterTblCell
        cell.prepareCell(data: arrData[indexPath.row], idx: indexPath.row)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let objData = arrData[indexPath.row]
        objData.isSelected.toggle()
        _userDefault.set(indexPath.row, forKey: "index")
        _userDefault.set(objData.isSelected, forKey: "selectedFilter")
        completion(objData.id)
        self.tableView.reloadRows(at: [indexPath], with: .automatic)
        self.dismiss(animated: true, completion: nil)
    }
}


//MARK:- Static Methods
extension FilterVC{
    func prepareData(){
        self.arrData.append(contentsOf: [FilterNew(str: "Rating", id: "1"),FilterNew(str: "Price", id: "2"),FilterNew(str: "Distance", id: "3"),FilterNew(str: "Availability", id: "4")])
    }
}
