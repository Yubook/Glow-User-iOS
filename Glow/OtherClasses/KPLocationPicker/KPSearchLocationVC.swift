

import UIKit
import MapKit

class SearchAddress{
    
    // For google search
    var name: String!
    var refCode: String!
    
    // For Geocode search
    var lat: Double = 0.0
    var long: Double = 0.0
    
    var address1: String = ""
    var address2: String = ""
    var street: String = ""
    var city: String = ""
    var state: String = ""
    var country: String = ""
    var zipcode: String = ""
    var formatedAddress: String = ""
    
    var location: CLLocation {
        return CLLocation(latitude: lat, longitude: long)
    }
    
    init() {}
    
    init(googleData: NSDictionary) {
        name = googleData.getStringValue(key: "description")
        refCode = googleData.getStringValue(key: "reference")
    }

    init(geoCodeData: CLPlacemark) {
        refCode = ""
        name = ""
        if let addDict = geoCodeData.addressDictionary as NSDictionary?{
            kprint(items: addDict)
            if let arr = addDict["FormattedAddressLines"] as? NSArray{
                formatedAddress = arr.componentsJoined(by: ",")
            }
            name = addDict.getStringValue(key: "Name")
            address1 = addDict.getStringValue(key: "Name")
            street = addDict.getStringValue(key: "Street")
            city = addDict.getStringValue(key: "City")
            state = addDict.getStringValue(key: "State")
            country = addDict.getStringValue(key: "Country")
            zipcode = addDict.getStringValue(key: "ZIP")
            
            if address1 == street{
                street = ""
            }
            
            if city.isEmpty{
                city = addDict.getStringValue(key: "SubAdministrativeArea")
            }
        }
        
        if let loc = geoCodeData.location{
            lat = loc.coordinate.latitude
            long = loc.coordinate.longitude
        }
    }
    
    init(dict: NSDictionary) {
        formatedAddress = dict.getStringValue(key: "formatted_address")
        city = dict.getStringValue(key: "name")
        if let geo = dict["geometry"] as? NSDictionary, let loc = geo["location"] as? NSDictionary{
            lat = loc.getDoubleValue(key: "lat")
            long = loc.getDoubleValue(key: "lng")
        }
    }
}

class addressCell: UITableViewCell {
    @IBOutlet var lblName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

enum ResponceType:Int{
    case success = 0
    case loading
    case noResult
    case netWorkError
}

class KPSearchLocationVC: UIViewController{
    
    // IBOutlet
    @IBOutlet var tfSerach: UITextField!
    @IBOutlet var tblView: UITableView!
    
    // Variable
    var isLoading: Bool = false
    var isNoResult: Bool = false
    var sessionDataTask: URLSessionDataTask!
    var arrData :[SearchAddress] = []
    var loadType : ResponceType!
    var selectionBlock: ((_ add: SearchAddress) -> Void)!
    
    // Life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        loadType = .success
        tblView.rowHeight = UITableView.automaticDimension
        tblView.tableFooterView = UIView()
        tfSerach.addTarget(self, action: #selector(KPSearchLocationVC.searchTextDidChange), for: .editingChanged)
        initSerchBar()
        prepareForkeyboardNotification()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tfSerach.becomeFirstResponder()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - Action Method
extension KPSearchLocationVC{
   
    @IBAction func cancelBtnTap(sender: UIButton){
        self.dismiss(animated: false, completion: nil)
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
}

// MARK: - Other method
extension KPSearchLocationVC{

    /// Add search icon and clear button in textfield search
    func initSerchBar(){
        // Add search icon
        let imgView = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: tfSerach.frame.size.height))
        imgView.image = UIImage(named: "searchIcon.png")
        imgView.contentMode = .center
        tfSerach.leftView = imgView
        tfSerach.leftViewMode = .always
        
        // Add clear button
        let btnClear = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: tfSerach.frame.size.height))
        btnClear.setImage(UIImage(named: "cancelIcon.png"), for: .normal)
        btnClear.addTarget(self, action: #selector(KPSearchLocationVC.textFieldClear), for: .touchUpInside)
        tfSerach.rightView = btnClear
        tfSerach.rightViewMode = .always
    }
}

//MARK:- search and textfield
extension KPSearchLocationVC: UITextFieldDelegate{
    
    @objc func textFieldClear(sender: UIButton){
        tfSerach.text = ""
        self.searchTextDidChange(textField: tfSerach)
    }
    
    @objc func searchTextDidChange(textField: UITextField){
        if sessionDataTask != nil{
            sessionDataTask.cancel()
        }
        
        self.arrData = []
        loadType = .loading
        self.tblView.reloadData()
        
        let str = textField.text?.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        if str!.count > 0{
            if isGooleKeyFound{
                sessionDataTask = KPAPICalls.shared.getReferenceFromSearchText(text: str!, block: { (addresses, resType) in
                    self.loadType = resType
                    self.arrData = addresses
                    self.tblView.reloadData()
                })
            }else{
                KPAPICalls.shared.searchAddressBygeocode(str: str!, block: { (adds, restype) in
                    self.loadType = restype
                    self.arrData = adds
                    self.tblView.reloadData()
                })
            }
        }else{
            self.loadType = .success
            self.arrData = []
            self.tblView.reloadData()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        tfSerach.resignFirstResponder()
        return true
    }
}

// MARK: - Tableview methods
extension KPSearchLocationVC: UITableViewDelegate,UITableViewDataSource{
   
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return arrData.count + 1
        }else{
            return 1
        }
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        if indexPath.section == 0{
            if indexPath.row == 0{
                cell.selectionStyle = .none
                if loadType == ResponceType.loading{
                    cell.textLabel?.text = "Loading..."
                }else if loadType == ResponceType.noResult{
                    cell.textLabel?.text = "No result found"
                }else{
                    cell.textLabel?.text = "Please try again"
                }
            }else{
                cell.selectionStyle = .default
                cell.textLabel?.text = arrData[indexPath.row - 1].name
            }
        }else{
            cell.textLabel?.text = "Set location on map"
        }
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.font = UIFont(name: "Avenir-Book", size: 15.0)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0{
            if indexPath.row == 0{
                if loadType == ResponceType.success {
                    return 0.0
                }else{
                    return 44.0
                }
            }else{
                return UITableView.automaticDimension
            }
        }else{
            return 44
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0{
            if indexPath.row == 0{
                return 0.0
            }else{
                return 44.0
            }
        }else{
            return 44.0
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0{
            if indexPath.row != 0{
                if isGooleKeyFound{
                    KPAPICalls.shared.getLocationFromReference(ref: arrData[indexPath.row - 1].refCode, block: { (address, error) in
                        if error == nil{
                            self.selectionBlock(address!)
                            self.dismiss(animated: false, completion: nil)
                        }
                    })
                }else{
                    self.selectionBlock(arrData[indexPath.row - 1])
                    self.dismiss(animated: false, completion: nil)
                }
                tblView.deselectRow(at: indexPath, animated: true)
            }
        }else{
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableCell(withIdentifier: "headerCell") as! addressCell
        view.lblName.text = "Search result"
        return view
    }
}

// MARK: - Keyboard Extension
extension KPSearchLocationVC {
    func prepareForkeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(KPSearchLocationVC.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(KPSearchLocationVC.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification){
        if let kbSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            tblView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: kbSize.height, right: 0)
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification){
        tblView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
    }
}
