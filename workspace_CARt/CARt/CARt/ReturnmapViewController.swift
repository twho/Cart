//
//  ReturnmapViewController.swift
//  CARt
//
//  Created by Michael Ho on 10/19/16.
//  Copyright © 2016 cartrides.org. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ReturnmapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var returnMapView: MKMapView!
    @IBOutlet weak var btnConfirm: BorderedButton!
    @IBOutlet weak var rideInfo: UILabel!
    
    var locationManager: CLLocationManager!
    var geocoder: CLGeocoder!
    
    let defaults = UserDefaults.standard
    let imgConfirm = UIImage(named: "ic_request_click")! as UIImage
    
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
//        self.returnMapView.showsUserLocation = true
        self.returnMapView.delegate = self
        
        btnConfirm.setImage(imgConfirm, for: .highlighted)
        drawRoute()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //location delegate methods
    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]){
        let location = locations.last
//        let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
//        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
//        self.returnMapView.setRegion(region, animated: true)
        self.locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Errors: ", error.localizedDescription)
    }
    
    func drawRoute(){
        let request = MKDirectionsRequest()
        let sourcePlacemark = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: Double(defaults.string(forKey: addressKeys.destAddressLat)!)!, longitude: Double(defaults.string(forKey: addressKeys.destAddressLng)!)!), addressDictionary: nil)
        request.source = MKMapItem(placemark: sourcePlacemark)
        let destPlacemark = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: Double(defaults.string(forKey: addressKeys.myAddressLat)!)!, longitude: Double(defaults.string(forKey: addressKeys.myAddressLng)!)!), addressDictionary: nil)
        request.destination = MKMapItem(placemark: destPlacemark)
        dropPin(placemark: destPlacemark, locationTag: 1)
        dropPin(placemark: sourcePlacemark, locationTag: 0)
        request.requestsAlternateRoutes = false
        request.transportType = .automobile
        let directions = MKDirections(request: request)
        directions.calculate { [unowned self] response, error in
            guard let unwrappedResponse = response else { return }
            for route in unwrappedResponse.routes {
                self.returnMapView.add(route.polyline)
            }
        }
    }
    
    func dropPin(placemark: MKPlacemark, locationTag: Int){
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        annotation.title = placemark.name
                if let city = placemark.locality,
            let state = placemark.administrativeArea {
            annotation.subtitle = "\(city)" + ", " + "\(state)"
        }
        returnMapView.addAnnotation(annotation)
        if locationTag == 0 {
            returnMapView.addAnnotation(annotation)
            let center = CLLocationCoordinate2D(latitude: Double(defaults.string(forKey: addressKeys.myAddressLat)!)!, longitude: Double(defaults.string(forKey: addressKeys.myAddressLng)!)!)
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.13, longitudeDelta: 0.13))
            self.returnMapView.setRegion(region, animated: true)
        }
    }
    
    @IBAction func btnConfirmPressed(_ sender: BorderedButton) {
        let alert = UIAlertController(title: "Terms and Conditions", message: "Please read these Terms and Conditions before using service operated CARt. \n \n Your access to and use of the Service is conditioned on your acceptance of and compliance with these Terms. These Terms apply to all visitors, users and others who access or use the Service.\n \n By accessing or using the Service you agree to be bound by these Terms. If you disagree with any part of the terms then you may not access the Service.", preferredStyle: UIAlertControllerStyle.alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.destructive) { (result : UIAlertAction) -> Void in
        }
        let okAction = UIAlertAction(title: "Agree", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
            self.performSegue(withIdentifier: "returnToEndIdentifier", sender: self)
        }
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(polyline: overlay as! MKPolyline)
        renderer.strokeColor = btnConfirm.tintColor
        return renderer
    }
}
