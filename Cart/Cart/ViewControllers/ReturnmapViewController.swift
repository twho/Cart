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
    @IBOutlet weak var btnConfirmRide: BorderedButton!
    @IBOutlet weak var tvInfoDetails: UILabel!
    
    var locationManager: CLLocationManager!
    var geocoder: CLGeocoder!
    var time: Float = 0.0
    var timer = Timer()
    
    let defaults = UserDefaults.standard
    let imageResources = ImageResources()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initLocationManager()
        initUIViews()
        drawRoute()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func initLocationManager(){
        self.locationManager = CLLocationManager()
        self.geocoder = CLGeocoder()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.startUpdatingLocation()
        self.returnMapView.delegate = self
    }
    
    func initUIViews(){
        self.tvInfoDetails.text = "Request your ride home to " + defaults.string(forKey: addressKeys.myAddressKey)!
        self.btnConfirmRide.setImage(imageResources.imgConfirmClicked, for: .highlighted)
        self.btnConfirmRide.setImage(imageResources.imgConfirmClicked, for: .normal)
    }
    
    //location delegate methods
    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]){
        let location = locations.last
        self.locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Errors: ", error.localizedDescription)
    }
    
    func drawRoute(){
        let request = MKDirectionsRequest()
        let sourcePlacemark = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: Double(defaults.string(forKey: addressKeys.destAddressLat)!)!, longitude: Double(defaults.string(forKey: addressKeys.destAddressLng)!)!), addressDictionary: nil)
        
        // Set up request
        request.source = MKMapItem(placemark: sourcePlacemark)
        let destPlacemark = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: Double(defaults.string(forKey: addressKeys.myAddressLat)!)!, longitude: Double(defaults.string(forKey: addressKeys.myAddressLng)!)!), addressDictionary: nil)
        request.destination = MKMapItem(placemark: destPlacemark)
        request.requestsAlternateRoutes = false
        request.transportType = .automobile
        
        // Drop pins at destination and start point
        dropPinZoomIn(placemark: destPlacemark, locationTag: 0)
        dropPinZoomIn(placemark: sourcePlacemark, locationTag: 1)
        
        // Draw destination route
        let directions = MKDirections(request: request)
        directions.calculate { [unowned self] response, error in
            guard let unwrappedResponse = response else { return }
            for route in unwrappedResponse.routes {
                self.returnMapView.add(route.polyline)
            }
        }
    }
    
    func dropPinZoomIn(placemark: MKPlacemark, locationTag: Int){
        if locationTag == 0 {
            let pinAnnotation = PinAnnotation()
            pinAnnotation.title = "My Home"
            pinAnnotation.subtitle = defaults.string(forKey: addressKeys.myAddressKey)
            pinAnnotation.setCoordinate(newCoordinate: placemark.coordinate)
            returnMapView.addAnnotation(pinAnnotation)
            
            // Set map camera
            let center = CLLocationCoordinate2D(latitude: Double(defaults.string(forKey: addressKeys.myAddressLat)!)!, longitude: Double(defaults.string(forKey: addressKeys.myAddressLng)!)!)
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.13, longitudeDelta: 0.13))
            self.returnMapView.setRegion(region, animated: true)
        } else {
            let annotation = MKPointAnnotation()
            annotation.coordinate = placemark.coordinate
            annotation.title = "Store Location"
            annotation.subtitle = defaults.string(forKey: addressKeys.destAddressKey)
            returnMapView.addAnnotation(annotation)
        }
    }
    
    func fadeInContents(withDuration duration: TimeInterval = 2.0) {
        UIView.animate(withDuration: duration, animations: {
            self.tvInfoDetails.alpha = 1.0
            self.btnConfirmRide.alpha = 1.0
        })
        startCounter()
    }
    
    func changeViewContent(withDuration duration: TimeInterval = 2.0) {
        UIView.animate(withDuration: duration, animations: {
            self.btnConfirmRide.alpha = 0.0
            self.tvInfoDetails.alpha = 0.0
        })
        self.tvInfoDetails.text = "You'll received a confirmation text within 10 minutes with your driver's details."
        self.fadeInContents()
    }
    
    @IBAction func btnRequestPressed(_ sender: BorderedButton) {
        self.performSegue(withIdentifier: "returnToEndIdentifier", sender: self)
    }
    
    @IBAction func btnCancelPressed(_ sender: AnyObject) {
        let alert = UIAlertController(title: "Confirm Cancellation", message: "Are you sure that you want to cancel the ride?", preferredStyle: UIAlertControllerStyle.alert)
        let yesAction = UIAlertAction(title: "Yes", style: UIAlertActionStyle.destructive) { (result : UIAlertAction) -> Void in
            self.performSegue(withIdentifier: "returnToEndIdentifier", sender: self)
        }
        let noAction = UIAlertAction(title: "No", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
        }
        alert.addAction(yesAction)
        alert.addAction(noAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func startCounter(){
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector:#selector(ReturnmapViewController.jumpToEnd), userInfo: nil, repeats: true)
    }
    
    func jumpToEnd(){
        time += 0.1
        if time >= 16 {
            self.performSegue(withIdentifier: "returnToEndIdentifier", sender: self)
        }
    }
    
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(polyline: overlay as! MKPolyline)
        renderer.strokeColor = UIColor.gray
        return renderer
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is PinAnnotation {
            let pinAnnotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "myPin")
            pinAnnotationView.pinTintColor = UIColor(red: 108, green: 149, blue: 182)
            pinAnnotationView.isDraggable = true
            pinAnnotationView.canShowCallout = true
            pinAnnotationView.animatesDrop = true
            return pinAnnotationView
        }
        
        return nil
    }
}
