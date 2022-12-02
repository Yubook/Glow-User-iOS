//
//  CurrentLocationVC.swift
//  Fade
//
//  Created by Chirag Patel on 13/11/21.
//  Copyright © 2021 Devang Lakhani. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import MapKitGoogleStyler

class CurrentLocationVC: ParentViewController {
    @IBOutlet weak var mapView : MKMapView!
    @IBOutlet weak var lblAddress : UILabel!
    
    var currentLocation : CLLocation!
    var locationManager : CLLocationManager!
    let newPin = MKPointAnnotation()
    var regionRadius: CLLocationDistance = 900
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUI()
    }
    
}
//MARK:- Others Methods
extension CurrentLocationVC{
    func prepareUI(){
        setupLocationManager()
    }
    
    @IBAction func btnContinueTapped(_ sender: UIButton){
        self.performSegue(withIdentifier: "home", sender: currentLocation)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "home"{
            if let latLong = sender as? CLLocation{
                _defaultCenter.post(name: NSNotification.Name(rawValue: "corrdinates"), object: nil, userInfo: ["latLong" : latLong])
            }
        }
    }
    
    func setupLocationManager(){
        mapView.delegate = self
        configureOverlayOnMap()
        locationManager = CLLocationManager()
        locationManager.requestAlwaysAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
        checkStatus()
        
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
    
    func checkStatus(){
        let status = CLLocationManager.authorizationStatus()
        switch status{
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            return
        case .denied,.restricted:
            let location = EnableLocation(nibName: "EnableLocation", bundle: nil)
            location.modalPresentationStyle = .fullScreen
            self.present(location, animated: false, completion: nil)
            location.handleTappedAction { tapped in
                if tapped == .done{
                    UIApplication.shared.openURL(URL(string: UIApplication.openSettingsURLString)!)
                }
            }
        default: break
        }
    }
    
    func getCurrentLocation() -> (lat : Double, long : Double){
        var getLatLong  = (lat : 0.0, long: 0.0)
        if
            CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
                CLLocationManager.authorizationStatus() ==  .authorizedAlways
        {
            if let currLocation = locationManager.location{
                getLatLong.lat = currLocation.coordinate.latitude
                getLatLong.long = currLocation.coordinate.longitude
            }
            
        }
        return getLatLong
    }
    
    func centerMapOnLocation(location: CLLocation)
    {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate,
                                                  latitudinalMeters: regionRadius * 2.0, longitudinalMeters: regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
}

//MARK:- Location Delegate Methods
extension CurrentLocationVC : MKMapViewDelegate,CLLocationManagerDelegate{
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        guard !(annotation is MKUserLocation) else {
            let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "userLocation")
            annotationView.image = UIImage(named:"ic_pin")
            return annotationView
        }
        return nil
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last! as CLLocation
        centerMapOnLocation(location: location)
        let userLocation:CLLocation = locations[0] as CLLocation
        currentLocation = userLocation
        getAddressFromLatLon(pdblLatitude: userLocation.coordinate.latitude, withLongitude: userLocation.coordinate.longitude) { (address) in
            self.lblAddress.text = address
            strCurrentLocation = address
        }
        let myAnnotation: MKPointAnnotation = MKPointAnnotation()
        myAnnotation.coordinate = CLLocationCoordinate2DMake(userLocation.coordinate.latitude, userLocation.coordinate.longitude)
        myAnnotation.title = "Current location"
        mapView.addAnnotation(myAnnotation)
        locationManager.startUpdatingLocation()
        mapView.showsUserLocation = true
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
}


//MARK:- Address Methods
extension CurrentLocationVC{
    func getAddressFromLatLon(pdblLatitude: Double, withLongitude pdblLongitude: Double, completion: @escaping ((String) -> ())) {
        var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
        let ceo: CLGeocoder = CLGeocoder()
        center.latitude = pdblLatitude
        center.longitude = pdblLongitude
        let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)
        ceo.reverseGeocodeLocation(loc, completionHandler:
            {(placemarks, error) in
                if (error != nil)
                {
                    print("reverse geodcode fail: \(error!.localizedDescription)")
                }
                let pm = placemarks! as [CLPlacemark]
                if pm.count > 0 {
                    let pm = placemarks![0]
                    var addressString : String = ""
                    if pm.subThoroughfare != nil{
                        addressString = addressString + pm.subThoroughfare! + ", "
                    }
                    if pm.subLocality != nil {
                        addressString = addressString + pm.subLocality! + ", "
                    }
                    if pm.thoroughfare != nil {
                        addressString = addressString + pm.thoroughfare! + ", "
                    }
                    if pm.locality != nil {
                        addressString = addressString + pm.locality! + ", "
                    }
                    if pm.country != nil {
                        addressString = addressString + pm.country! + ", "
                    }
                    if pm.postalCode != nil {
                        addressString = addressString + pm.postalCode! + " "
                    }
                    completion(addressString)
                }
        })
    }
}
