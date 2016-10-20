//
//  MapViewController.swift
//  CARt
//
//  Created by Michael Ho on 10/17/16.
//  Copyright © 2016 cartrides.org. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

protocol HandleMapSearch {
    func dropPinZoomIn(placemark:MKPlacemark)
}

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var btnRequest: BorderedButton!
    @IBOutlet weak var edDestination: UITextField!
    @IBOutlet weak var ivDestination: UIImageView!
    
    var locationManager: CLLocationManager!
    var geocoder: CLGeocoder!
    var storeList:[MKMapItem] = []
    var selectedPin:MKPlacemark? = nil
    var storeLat: Double = 0.0
    var storeLng: Double = 0.0
    var storeAddr: String = ""
    
    let imgRequest = UIImage(named: "ic_request_click")! as UIImage
    let defaults = UserDefaults.standard
    
    struct addressKeys {
        static let myAddressKey = "myAddress"
        static let myAddressLat = "myAddressLat"
        static let myAddressLng = "myAddressLng"
        static let destAddressKey = "destAddressKey"
        static let destAddressLat = "destAddressLat"
        static let destAddressLng = "destAddressLng"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.locationManager = CLLocationManager()
        self.geocoder = CLGeocoder()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.startUpdatingLocation()
        self.mapView.showsUserLocation = true
        self.mapView.delegate = self
        btnRequest.setImage(imgRequest, for: .highlighted)
        edDestination.leftViewMode = UITextFieldViewMode.always
        edDestination.leftView = ivDestination
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        self.hideKeyboardWhenTappedAround()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //location delegate methods
    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]){
        let location = locations.last
//        let center = CLLocationCoordinate2D(latitude: Double(defaults.string(forKey: addressKeys.myAddressLat)!)!, longitude: Double(defaults.string(forKey: addressKeys.myAddressLng)!)!)
//        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
//        self.mapView.setRegion(region, animated: true)
        self.locationManager.stopUpdatingLocation()
        self.geocoder.reverseGeocodeLocation(location!, completionHandler: {(placemarks, error) -> Void in
            
            if error != nil {
                print("Reverse geocoder failed with error" + (error?.localizedDescription)!)
                return
            }
            
            if (placemarks?.count)! > 0 {
//                let pm = (placemarks?[0])! as CLPlacemark
//                self.edMyAddr.text = pm.name! + ", " + pm.locality! + ", " + pm.administrativeArea!
            }
            else {
                print("Problem with the data received from geocoder")
            }
        })
        searchTargetStore()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Errors: ", error.localizedDescription)
    }
    
    func searchTargetStore(){
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = "Meijer"
        request.region = mapView.region
        let search = MKLocalSearch(request: request)
        search.start { response, _ in
            guard let response = response else {
                return
            }
            self.storeList = response.mapItems
            //Clear existing pins
            self.mapView.removeAnnotations(self.mapView.annotations)
            for index in 0...self.storeList.count-1{
                let selectedItem = self.storeList[index].placemark
                self.dropPinZoomIn(placemark: selectedItem, sequence: index)
            }
        }
    }
    
    @IBAction func btnRequestPressed(_ sender: AnyObject) {
        let alert = UIAlertController(title: "Terms and Conditions", message: "Please read these Terms and Conditions before using service operated CARt. \n \n Your access to and use of the Service is conditioned on your acceptance of and compliance with these Terms. These Terms apply to all visitors, users and others who access or use the Service.\n \n By accessing or using the Service you agree to be bound by these Terms. If you disagree with any part of the terms then you may not access the Service.", preferredStyle: UIAlertControllerStyle.alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.destructive) { (result : UIAlertAction) -> Void in
//            print("Destructive")
        }
        let okAction = UIAlertAction(title: "Agree", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
            self.defaults.setValue(self.storeAddr, forKey: addressKeys.destAddressKey)
            self.defaults.setValue(self.storeLat, forKey: addressKeys.destAddressLat)
            self.defaults.setValue(self.storeLng, forKey: addressKeys.destAddressLng)
            self.defaults.synchronize()
            self.performSegue(withIdentifier: "mapToConfirmIdentifier", sender: self)
        }
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func dropPinZoomIn(placemark: MKPlacemark, sequence: Int){
        if sequence == 0 {
            edDestination.text = placemark.title!
            storeAddr = placemark.title!
            let request = MKDirectionsRequest()
            request.source = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: Double(defaults.string(forKey: addressKeys.myAddressLat)!)!, longitude: Double(defaults.string(forKey: addressKeys.myAddressLng)!)!), addressDictionary: nil))
            storeLat = placemark.coordinate.latitude
            storeLng = placemark.coordinate.longitude
            request.destination = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: placemark.coordinate.latitude, longitude: placemark.coordinate.longitude), addressDictionary: nil))
            request.requestsAlternateRoutes = false
            request.transportType = .automobile
            let directions = MKDirections(request: request)
            directions.calculate { [unowned self] response, error in
                guard let unwrappedResponse = response else { return }
                for route in unwrappedResponse.routes {
                    self.mapView.add(route.polyline)
//                    self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: false)
                }
            }
        }
        // cache the pin
        selectedPin = placemark
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        annotation.title = placemark.name
        if let city = placemark.locality,
            let state = placemark.administrativeArea {
            annotation.subtitle = "\(city)" + ", " + "\(state)"
        }
        mapView.addAnnotation(annotation)
        let center = CLLocationCoordinate2D(latitude: Double(defaults.string(forKey: addressKeys.myAddressLat)!)!, longitude: Double(defaults.string(forKey: addressKeys.myAddressLng)!)!)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.13, longitudeDelta: 0.13))
//        let span = MKCoordinateSpanMake(0.3, 0.3)
//        let region = MKCoordinateRegionMake(placemark.coordinate, span)
        mapView.setRegion(region, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(polyline: overlay as! MKPolyline)
        renderer.strokeColor = edDestination.tintColor
        return renderer
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
