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

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var btnRequest: BorderedButton!
    @IBOutlet weak var edMyAddr: UITextField!
    @IBOutlet weak var edDestination: UITextField!
    @IBOutlet weak var ivMyAddr: UIImageView!
    @IBOutlet weak var ivDestination: UIImageView!
    
    var locationManager: CLLocationManager!
    var geocoder: CLGeocoder!
    
    let imgRequest = UIImage(named: "ic_request_click")! as UIImage
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.locationManager = CLLocationManager()
        self.geocoder = CLGeocoder()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.startUpdatingLocation()
        self.mapView.showsUserLocation = true
        btnRequest.setImage(imgRequest, for: .highlighted)
        edMyAddr.leftViewMode = UITextFieldViewMode.always
        edDestination.leftViewMode = UITextFieldViewMode.always
        edMyAddr.leftView = ivMyAddr
        edDestination.leftView = ivDestination
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //location delegate methods
    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]){
        let location = locations.last
        let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
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
        searchTargetStore()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Errors: ", error.localizedDescription)
    }
    
    func searchTargetStore(){
        
    }
    
    @IBAction func btnRequestPressed(_ sender: AnyObject) {
        let alert = UIAlertController(title: "Terms and Conditions", message: "Please read these Terms and Conditions before using service operated CARt. \n \n Your access to and use of the Service is conditioned on your acceptance of and compliance with these Terms. These Terms apply to all visitors, users and others who access or use the Service.\n \n By accessing or using the Service you agree to be bound by these Terms. If you disagree with any part of the terms then you may not access the Service.", preferredStyle: UIAlertControllerStyle.alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.destructive) { (result : UIAlertAction) -> Void in
//            print("Destructive")
        }
        let okAction = UIAlertAction(title: "Agree", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
            self.performSegue(withIdentifier: "mapToConfirmIdentifier", sender: self)
        }
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
}
