//
//  PostCodeVC.swift
//  Fade
//
//  Created by Devang Lakhani  on 11/13/21.
//  Copyright © 2021 Devang Lakhani. All rights reserved.
//

import UIKit
import CoreLocation

class PostCodeVC: ParentViewController {
    @IBOutlet weak var tfSearch : UITextField!
    var finalPostCode = ""
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
//MARK:- Others Methods
extension PostCodeVC{
    @IBAction func btnContinueTapped(_ sender: UIButton){
        if finalPostCode != ""{
           /* self.getLatLong(str: finalPostCode, completion: {loc in
                _defaultCenter.post(name: NSNotification.Name("corrdinates"), object: nil, userInfo: ["latLong" : loc])
                self.performSegue(withIdentifier: "postCodeHome", sender: nil)
            })*/
            self.getLatLngForZip(zipCode: finalPostCode) { (location) in
                _defaultCenter.post(name: NSNotification.Name("corrdinates"), object: nil, userInfo: ["latLong" : location])
                self.performSegue(withIdentifier: "postCodeHome", sender: nil)
            }
        }else{
            self.showError(msg: "Enter PostCode")
        }
    }
   /* func getLatLong(str: String, completion : @escaping ((CLLocation) -> ())){
        
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(str) { (placeMark, err) in
            guard let placemarks = placeMark, let location = placemarks.first?.location else {
                
                return
            }
            completion(location)
        }
    }
 */
    
    func getLatLngForZip(zipCode: String,completion : @escaping ((CLLocation) -> ())) {
        guard  let testUrl = try?"https://maps.googleapis.com/maps/api/geocode/json?address=\(zipCode)&key=\(googleKey)".asURL() else {return}
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
    }
}

//MARK:- TextField Delegate Methods
extension PostCodeVC : UITextFieldDelegate{
    @IBAction func tfEditingChanged(_ textField: UITextField){
        if let str = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines){
            finalPostCode = str
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        tfSearch.resignFirstResponder()
        return true
    }
}
