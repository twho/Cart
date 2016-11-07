//
//  AddressViewController.swift
//  CARt
//
//  Created by Michael Ho on 10/19/16.
//  Copyright © 2016 cartrides.org. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class AddressViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var tvInstrucTitle: UILabel!
    @IBOutlet weak var tvInstruc: UILabel!
    @IBOutlet weak var edMyAddr: UITextField!
    @IBOutlet weak var btnSet: BorderedButton!
    
    var locationManager: CLLocationManager!
    var geocoder: CLGeocoder!
    
    let imgSetClicked = UIImage(named: "ic_finish_click")! as UIImage
    let imgSet = (UIImage(named: "ic_finish_click")?.maskWithColor(color: UIColor.gray)!)! as UIImage
    let defaults = UserDefaults.standard
    
    var lat: Double = 0.0
    var lng: Double = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.locationManager = CLLocationManager()
        self.geocoder = CLGeocoder()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.startUpdatingLocation()
        self.mapView.showsUserLocation = true
        
        btnSet.setImage(imgSetClicked, for: .highlighted)
        btnSet.setImage(imgSet, for: .normal)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        self.hideKeyboardWhenTappedAround()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    struct addressKeys {
        static let myAddressKey = "myAddress"
        static let myAddressLat = "myAddressLat"
        static let myAddressLng = "myAddressLng"
    }
    
    @IBAction func btnSetPressed(_ sender: BorderedButton) {
        defaults.setValue(edMyAddr.text, forKey: addressKeys.myAddressKey)
        defaults.setValue(lat, forKey: addressKeys.myAddressLat)
        defaults.setValue(lng, forKey: addressKeys.myAddressLng)
        defaults.synchronize()
    }
    
    //location delegate methods
    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]){
        let location = locations.last
        let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        lat = location!.coordinate.latitude
        lng = location!.coordinate.longitude
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
        self.mapView.setRegion(region, animated: true)
        self.locationManager.stopUpdatingLocation()
        self.geocoder.reverseGeocodeLocation(location!, completionHandler: {(placemarks, error) -> Void in
            
            if error != nil {
                print("Reverse geocoder failed with error" + (error?.localizedDescription)!)
                return
            }
            
            if (placemarks?.count)! > 0 {
                let pm = (placemarks?[0])! as CLPlacemark
                self.edMyAddr.text = pm.name! + ", " + pm.locality! + ", " + pm.administrativeArea!
            }
            else {
                print("Problem with the data received from geocoder")
            }
        })
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Errors: ", error.localizedDescription)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            self.view.frame.origin.y = self.view.frame.origin.y - keyboardSize.height
        }
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y = self.view.frame.origin.y + keyboardSize.height
            }
        }
    }
}
