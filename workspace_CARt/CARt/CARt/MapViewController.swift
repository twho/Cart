//
//  MapViewController.swift
//  CARt
//
//  Created by Michael Ho on 10/17/16.
//  Copyright © 2016 cartrides.org. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreLocation

protocol HandleMapSearch {
    func dropPinZoomIn(placemark:MKPlacemark)
}

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var btnRequest: BorderedButton!
    @IBOutlet weak var btnPrev: BorderedButton!
    @IBOutlet weak var edDestination: UITextField!
    @IBOutlet weak var ivDestination: UIImageView!
    @IBOutlet weak var tvDestination: UILabel!
    
    var locationManager: CLLocationManager!
    var geocoder: CLGeocoder!
    var storeList:[MKMapItem] = []
    var routes:[MKOverlay] = []
    var selectedPin:MKPlacemark? = nil
    var storeLat: Double = 0.0
    var storeLng: Double = 0.0
    var storeAddr: String = ""
    var ifRouteDrawn: Bool = false
    var currentPrice: Double = 0.0
    
    let imgRequestClicked = UIImage(named: "ic_request_click")! as UIImage
    let imgRequest = (UIImage(named: "ic_request_click")?.maskWithColor(color: UIColor.gray)!)! as UIImage
    let imgPrevClicked = UIImage(named: "ic_prev_click")! as UIImage
    let imgPrev = (UIImage(named: "ic_prev_click")?.maskWithColor(color: UIColor.gray)!)! as UIImage
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
        btnRequest.setImage(imgRequestClicked, for: .highlighted)
        btnRequest.setImage(imgRequest, for: .normal)
        btnPrev.setImage(imgPrevClicked, for: .highlighted)
        btnPrev.setImage(imgPrev, for: .normal)
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
                if selectedItem.name!.lowercased().range(of:"pharmacy") == nil && selectedItem.name!.lowercased().range(of:"gas") == nil{
                    self.dropPinZoomIn(placemark: selectedItem, sequence: index)
                }
            }
        }
    }
    
    @IBAction func btnRequestPressed(_ sender: BorderedButton) {
        let alert = UIAlertController(title: "Are you sure you want to request a ride?", message: "By tapping request, you agree to pay $10 at Meijer for your ride.", preferredStyle: UIAlertControllerStyle.alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.destructive) { (result : UIAlertAction) -> Void in
            //            print("Destructive")
        }
        let okAction = UIAlertAction(title: "Request", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
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
        if sequence == 0 && !self.ifRouteDrawn {
            edDestination.text = placemark.title!
            storeAddr = placemark.title!
            storeLat = placemark.coordinate.latitude
            storeLng = placemark.coordinate.longitude
            drawRoute(sourceLocation: CLLocationCoordinate2D(latitude: Double(defaults.string(forKey: addressKeys.myAddressLat)!)!, longitude: Double(defaults.string(forKey: addressKeys.myAddressLng)!)!), destinationLocation: CLLocationCoordinate2D(latitude: placemark.coordinate.latitude, longitude: placemark.coordinate.longitude))
            let center = CLLocationCoordinate2D(latitude: Double(defaults.string(forKey: addressKeys.myAddressLat)!)!, longitude: Double(defaults.string(forKey: addressKeys.myAddressLng)!)!)
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.13, longitudeDelta: 0.13))
            mapView.setRegion(region, animated: true)
            ifRouteDrawn = true
        }
        // cache the pin
        let pinAnnotation = PinAnnotation()
        pinAnnotation.title = placemark.name!
        pinAnnotation.subtitle = "\(placemark.title!)"
        pinAnnotation.setCoordinate(newCoordinate: placemark.coordinate)
        mapView.addAnnotation(pinAnnotation)
    }
    
    func drawRoute(sourceLocation: CLLocationCoordinate2D, destinationLocation: CLLocationCoordinate2D){
        let request = MKDirectionsRequest()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: sourceLocation, addressDictionary: nil))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: destinationLocation, addressDictionary: nil))
        request.requestsAlternateRoutes = false
        request.transportType = .automobile
        let directions = MKDirections(request: request)
        directions.calculate { [unowned self] response, error in
            guard let unwrappedResponse = response else { return }
            let distance = Double(round(100*(Double((response!.routes.first?.distance)!)/1609))/100)
            self.tvDestination.text = "The selected Meijer is \(distance) mi away. This trip will cost you $10."
            self.currentPrice = Double(round(10*(distance*2.05)/10))
            self.routes = []
            for route in unwrappedResponse.routes {
                self.mapView.add(route.polyline)
                self.routes.append(route.polyline)
//                self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: false)
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(polyline: overlay as! MKPolyline)
        renderer.strokeColor = edDestination.tintColor
        return renderer
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is PinAnnotation {
            let pinAnnotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "myPin")
            
            pinAnnotationView.pinTintColor = .red
            pinAnnotationView.isDraggable = true
            pinAnnotationView.canShowCallout = true
            pinAnnotationView.animatesDrop = true
            
            let setDestination = UIButton(type: UIButtonType.custom) as UIButton
            setDestination.frame.size.width = 40
            setDestination.frame.size.height = 40
            setDestination.backgroundColor = UIColor.white
            setDestination.setImage(UIImage(named: "ic_destination"), for: .normal)
            
            pinAnnotationView.leftCalloutAccessoryView = setDestination
            
            return pinAnnotationView
        }
        
        return nil
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if let annotation = view.annotation as? PinAnnotation {
            //do things when the annotation is clicked
            storeLat = annotation.coordinate.latitude
            storeLng = annotation.coordinate.longitude
            storeAddr = annotation.subtitle!
            edDestination.text = storeAddr
            self.mapView.removeOverlays(routes)
            drawRoute(sourceLocation: CLLocationCoordinate2D(latitude: Double(defaults.string(forKey: addressKeys.myAddressLat)!)!, longitude: Double(defaults.string(forKey: addressKeys.myAddressLng)!)!), destinationLocation: CLLocationCoordinate2D(latitude: annotation.coordinate.latitude, longitude: annotation.coordinate.longitude))
        }
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
