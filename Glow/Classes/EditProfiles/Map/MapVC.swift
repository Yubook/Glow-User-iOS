//
//  MapVC.swift
//  Fade
//
//  Created by Devang Lakhani  on 4/28/21.
//  Copyright © 2021 Devang Lakhani. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapVC: ParentViewController {
    @IBOutlet weak var mapView : MKMapView!
    //var locationManager: CLLocationManager!
    //var currentLocation = "Current Location"
    
    var userLocation: CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //determineCurrentLocation()
        
    }
}
/*
//MARK:- CLCoreLocation Delegate Methods
extension MapVC : CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let mUserLocation : CLLocation = locations[0] as CLLocation
        
        let centre = CLLocationCoordinate2D(latitude: mUserLocation.coordinate.latitude, longitude: mUserLocation.coordinate.longitude)
        
        let mRegion = MKCoordinateRegion(center: centre, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        mapView.setRegion(mRegion, animated: true)
        
        //Set Pin
        
        let mkAnnotation : MKPointAnnotation = MKPointAnnotation()
        CLLocationCoordinate2DMake(mUserLocation.coordinate.latitude, mUserLocation.coordinate.longitude)
        mkAnnotation.title = self.setUserClosestLocation(mLatitude: mUserLocation.coordinate.latitude, mLongitude: mUserLocation.coordinate.longitude)
        
        mapView.addAnnotation(mkAnnotation)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
} */

//MARK:- MKMapView Delegate Methods
extension MapVC: MKMapViewDelegate{
    
}

//MARK:- Instance Methods
extension MapVC{
   /* func determineCurrentLocation(){
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled(){
            locationManager.startUpdatingLocation()
        }
    } */
}

//MARK:- User Closest Location
extension MapVC{
   /* func setUserClosestLocation(mLatitude : CLLocationDegrees, mLongitude : CLLocationDegrees) -> String{
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: mLatitude, longitude: mLongitude)
        
        geoCoder.reverseGeocodeLocation(location) { (placemarks, error) in
            if let mPlacemarks = placemarks, mPlacemarks.count > 0{
                let place :CLPlacemark = mPlacemarks.last! as CLPlacemark
                if let addr = place.addressDictionary{
                    if let name = addr["Name"] as? String, let city = addr["City"] as? String{
                        self.currentLocation = name + ", " + city
                    }
                }
            }
        }
        
        return currentLocation
    } */
}
