//
//  ManuallyLocationVC.swift
//  Fade
//
//  Created by Chirag Patel on 29/09/21.
//  Copyright © 2021 Devang Lakhani. All rights reserved.
//

import UIKit
import CoreLocation

class ManuallyLocationVC: ParentViewController {
    var objData = ManuallyLocation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUI()
    }
}
//MARK:- Others Methods
extension ManuallyLocationVC{
    func prepareUI(){
        objData.prepareData()
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
        tableView.contentInset = UIEdgeInsets(top: 25, left: 0, bottom: 0, right: 0)
    }
    
    @IBAction func btnContinueTapped(_ sender: UIButton){
        let validateData = objData.validateData()
        if validateData.isValid{
            let houseNum = objData.arrData[1].value
            let address = objData.arrData[0].value
            let city = objData.arrData[2].value
            let country = objData.arrData[4].value
            let postCode = objData.arrData[3].value
           // let finalAddress = houseNum + address + "," + city + "," + country + "," + postCode
            let finalAddress = houseNum + address + city + country + postCode
            self.getLatlongOnAddress(str: finalAddress) { loc in
                _defaultCenter.post(name: NSNotification.Name(rawValue: "corrdinates"), object: nil, userInfo: ["latLong" : loc])
                self.performSegue(withIdentifier: "manualLocationHome", sender: nil)
            }
        }else{
            self.showError(msg: validateData.err)
        }
    }
}

//MARK:- TableView Delegate & DataSource Methods
extension ManuallyLocationVC{
   
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objData.arrData.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let obj = objData.arrData[indexPath.row]
        let cell : ManuallyLocationTblCell
        cell = tableView.dequeueReusableCell(withIdentifier: obj.cellType.cellId, for: indexPath) as! ManuallyLocationTblCell
        cell.parentVC = self
        cell.prepareCell(data: obj, index: indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let obj = objData.arrData[indexPath.section]
        return obj.cellType.cellHeight
    }
}

//MARK:- GeoCode Methods
extension ManuallyLocationVC{
    func getLatlongOnAddress(str: String,completion : @escaping ((CLLocation) -> ())){
        guard  let testUrl = try?"https://maps.googleapis.com/maps/api/geocode/json?address=\(str)&key=\(googleKey)".asURL() else {return}
        guard let data = try? Data(contentsOf: testUrl) else {return}
        if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary{
            if let result = json["results"] as? [NSDictionary] {
                if let geometry = result[0]["geometry"] as? NSDictionary {
                    if let location = geometry["location"] as? NSDictionary {
                        let latitude = location["lat"] as! Double
                        let longitude = location["lng"] as! Double
                        let loc = CLLocation(latitude: latitude, longitude: longitude)
                        completion(loc)
                    }
                }
            }
        }else{
            print("Some error occured")
        }
//        let geoCoder = CLGeocoder()
//        geoCoder.geocodeAddressString(str) { (placeMark, err) in
//            guard let placemarks = placeMark, let location = placemarks.first?.location else {
//                self.showError(msg: err!.localizedDescription)
//                return
//            }
//            completion(location)
//        }
    }
}
