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

class AddressViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UITextFieldDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var edMyAddr: UITextField!
    @IBOutlet weak var btnShowMap: UIButton!
    @IBOutlet weak var btnHideMap: UIButton!
    @IBOutlet weak var btnPrev: BorderedButton!
    @IBOutlet weak var btnNext: BorderedButton!
    
    var locationManager: CLLocationManager!
    var geocoder: CLGeocoder!
    var lat: Double = 0.0
    var lng: Double = 0.0
    
    let imgPrevClicked = UIImage(named: "ic_prev_click")! as UIImage
    let imgPrev = (UIImage(named: "ic_prev_click")?.maskWithColor(color: UIColor.gray)!)! as UIImage
    let imgNextClicked = UIImage(named: "ic_next_click")! as UIImage
    let imgNext = (UIImage(named: "ic_next_click")?.maskWithColor(color: UIColor.gray)!)! as UIImage
    let defaults = UserDefaults.standard
    
    var ifMapShown: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.locationManager = CLLocationManager()
        self.geocoder = CLGeocoder()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.startUpdatingLocation()
        self.mapView.showsUserLocation = true
        self.edMyAddr.delegate = self
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        btnPrev.setImage(imgPrevClicked, for: .highlighted)
        btnPrev.setImage(imgPrev, for: .normal)
        btnNext.setImage(imgNextClicked, for: .highlighted)
        btnNext.setImage(imgNext, for: .normal)
        self.mapView.isHidden = true
        self.btnShowMap.isHidden = false
        self.btnHideMap.isHidden = true
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
    
    
    @IBAction func btnNextClicked(_ sender: BorderedButton) {
        defaults.setValue(self.edMyAddr.text, forKey: addressKeys.myAddressKey)
        defaults.setValue(lat, forKey: addressKeys.myAddressLat)
        defaults.setValue(lng, forKey: addressKeys.myAddressLng)
        defaults.synchronize()
    }
    
    @IBAction func btnShowMapClicked(_ sender: UIButton) {
        self.mapView.isHidden = false
        self.btnShowMap.isHidden = true
        self.btnHideMap.isHidden = false
        self.btnNext.frame.origin.y = self.btnNext.frame.origin.y + 337
        self.btnPrev.frame.origin.y = self.btnPrev.frame.origin.y + 337
    }
    
    @IBAction func btnHideMapClicked(_ sender: UIButton) {
        self.mapView.isHidden = true
        self.btnShowMap.isHidden = false
        self.btnHideMap.isHidden = true
        self.btnNext.frame.origin.y = self.btnNext.frame.origin.y - 337
        self.btnPrev.frame.origin.y = self.btnPrev.frame.origin.y - 337
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
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
