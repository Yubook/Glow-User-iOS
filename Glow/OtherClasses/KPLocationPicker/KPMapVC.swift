

import UIKit
import MapKit
import Contacts
import MapKitGoogleStyler

class KPMapVC: UIViewController,UISearchBarDelegate {
    
    // IBOutlets
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet var imgPin: UIImageView!
    @IBOutlet var lblSelectedAddress: UILabel!
    @IBOutlet var tfSerach: UITextField!
    @IBOutlet var btnDone: UIButton!
    
    // Variables
    var pinAnimation: CABasicAnimation!
    var selectedAddress: SearchAddress!
    var callBackBlock: ((_ add: SearchAddress) -> Void)!
    
    // View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.initAnimation()
        self.addLableShadow()
        self.initSerchBar()
        configureOverlayOnMap()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.fetchUserLocation()
     //   self.performSegue(withIdentifier: "locationPickerSegue", sender: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "locationPickerSegue"{
            let searchCon = segue.destination as! KPSearchLocationVC
            searchCon.selectionBlock = {[unowned self](add) -> () in
                self.setMapResion(lat: add.lat, long: add.long)
                self.tfSerach.text = add.formatedAddress
                self.selectedAddress = add
            }
        }
    }
    
    func configureOverlayOnMap() {
        guard let overlayFileURLString = Bundle.main.path(forResource: "google_maps_style", ofType: "json") else {
            return
        }
        let overlayFileURL = URL(fileURLWithPath: overlayFileURLString)
        
        // After that, you can create the tile overlay using MapKitGoogleStyler
        guard let tileOverlay = try? MapKitGoogleStyler.buildOverlay(with: overlayFileURL) else {
            return
        }
        
        // And finally add it to your MKMapView
        mapView.addOverlay(tileOverlay)
    }
}


// MARK: - Actions
extension KPMapVC{
    
    @IBAction func getUserCurrentLocation(sender: UIButton){
        self.fetchUserLocation()
    }
    
    @IBAction func dismiassAction(sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func dismissKPPicker(sender: UIButton){
        if selectedAddress != nil{
            callBackBlock(selectedAddress)
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnSearchAddTap(sender: UIButton){
        self.performSegue(withIdentifier: "locationPickerSegue", sender: nil)
    }
}

// MARK: - Other methods
extension KPMapVC{

    /// Init pin rotation animation
    func initAnimation(){
        pinAnimation = CABasicAnimation(keyPath: "transform.rotation.y")
        pinAnimation.toValue = (.pi * 2.0 * 0.2)
        pinAnimation.duration = 0.2
        pinAnimation.isCumulative = true
        pinAnimation.repeatCount = Float.infinity
    }
    
    /// Add Shadow in address lable
    func addLableShadow(){
        lblSelectedAddress.layer.shadowColor = UIColor.black.cgColor
        lblSelectedAddress.layer.shadowRadius = 4.0
        lblSelectedAddress.layer.shadowOpacity = 0.7
        lblSelectedAddress.layer.shadowOffset = CGSize(width: 0, height: 0)
    }
    
    
    /// Add search icon and clear button in textfield search
    func initSerchBar(){
        // Add search icon
        let imgView = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: tfSerach.frame.size.height))
        imgView.image = UIImage(named: "searchIcon.png")
        imgView.contentMode = .center
        tfSerach.leftView = imgView
        tfSerach.leftViewMode = .always
    }

    
    /// Start pin rotation animation
    func startPinAnimation(){
        //self.imgPin.layer.add(self.pinAnimation, forKey: "rotationAnimation")
    }
    
    /// Stop pin rotation animation
    func stopPinAnimation(){
        //self.imgPin.layer.removeAllAnimations()
    }
    
    /// Fetch user current location with formatted address.
    func fetchUserLocation() {
        //self.startPinAnimation()
        self.btnDone.isHidden = true
        weak var controller: UIViewController! = self
        UserLocation.sharedInstance.fetchUserLocationForOnce(controller: controller) { (location, error) in
            if let _ = location{
                if !isGooleKeyFound{
                    KPAPICalls.shared.getAddressFromLatLong(lat: "\(location!.coordinate.latitude)", long: "\(location!.coordinate.longitude)", block: { (addres) in
                       // self.stopPinAnimation()
                        if let _ = addres{
                            self.lblSelectedAddress.text = addres?.formatedAddress
                            self.mapView.userLocation.title = addres?.formatedAddress
                            self.tfSerach.text = addres?.formatedAddress
                            self.setMapResion(lat: location!.coordinate.latitude, long: location!.coordinate.longitude)
                            self.selectedAddress = addres
                            self.btnDone.isHidden = false
                        }
                    })
                }else{
                    KPAPICalls.shared.addressFromlocation(location: location!, block: { (addres) in
                       // self.stopPinAnimation()
                        if let _ = addres{
                            self.lblSelectedAddress.text = addres?.formatedAddress
                            self.mapView.userLocation.title = addres?.formatedAddress
                            self.setMapResion(lat: location!.coordinate.latitude, long: location!.coordinate.longitude)
                            self.selectedAddress = addres
                            self.tfSerach.text = addres?.formatedAddress
                            self.btnDone.isHidden = false
                        }
                    })
                }
            }else{
              //  self.stopPinAnimation()
            }
        }
    }
}

// MARK: - MapView Delegate and fetch address.
extension KPMapVC: MKMapViewDelegate{
    
    /// Fetch new address on map grag by user.
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool){
        if !animated{
            self.startPinAnimation()
            self.tfSerach.text = "Loading..."
            self.btnDone.isHidden = true
            let cord = mapView.centerCoordinate
            if !isGooleKeyFound{
                KPAPICalls.shared.getAddressFromLatLong(lat: "\(cord.latitude)", long: "\(cord.longitude)", block: { (add) in
                    self.stopPinAnimation()
                    if let _ = add{
                        self.lblSelectedAddress.text = add?.formatedAddress
                        self.selectedAddress = add
                        self.tfSerach.text = add?.formatedAddress
                        self.btnDone.isHidden = false
                    }else{
                        self.tfSerach.text = "Error in location fetch"
                    }
                })
            }else{
                let loc = CLLocation(latitude: cord.latitude, longitude: cord.longitude)
                KPAPICalls.shared.addressFromlocation(location: loc, block: { (add) in
                    self.stopPinAnimation()
                    if let _ = add{
                        self.lblSelectedAddress.text = add?.formatedAddress
                        self.selectedAddress = add
                        self.tfSerach.text = add?.formatedAddress
                        self.btnDone.isHidden = false
                    }else{
                        self.tfSerach.text = "Error in location fetch"
                    }
                })
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) ->
    MKOverlayRenderer {
        // This is the final step. This code can be copied and pasted into your project
        // without thinking on it so much. It simply instantiates a MKTileOverlayRenderer
        // for displaying the tile overlay.
        if let tileOverlay = overlay as? MKTileOverlay {
            return MKTileOverlayRenderer(tileOverlay: tileOverlay)
        } else {
            return MKOverlayRenderer(overlay: overlay)
        }
        
    }
    
    /// Set resion on map with selected loaction
    func setMapResion(lat: Double, long: Double){
        var loc = CLLocationCoordinate2D()
        loc.latitude = lat
        loc.longitude = long
        
        var span = MKCoordinateSpan()
        span.latitudeDelta = 0.05
        span.longitudeDelta = 0.05
        
        var myResion = MKCoordinateRegion()
        myResion.center = loc
        myResion.span = span
        self.mapView.setRegion(myResion, animated: true)
    }
}
