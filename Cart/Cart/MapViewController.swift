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
import DropDown

protocol HandleMapSearch {
    func dropPinZoomIn(placemark:MKPlacemark)
}

struct addressKeys {
    static let myAddressKey = "myAddress"
    static let myAddressLat = "myAddressLat"
    static let myAddressLng = "myAddressLng"
    static let destAddressKey = "destAddressKey"
    static let destAddressLat = "destAddressLat"
    static let destAddressLng = "destAddressLng"
}

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var btnRequest: BorderedButton!
    @IBOutlet weak var btnPrev: BorderedButton!
    @IBOutlet weak var btnDestination: UIButton!
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
    var storeDistance: [Double] = []
    var storeDropDownList: [MKPlacemark] = []
    
    let defaults = UserDefaults.standard
    let imageResources = ImageResources()
    
    let storeDropDown = DropDown()
    lazy var dropDowns: [DropDown] = {
        return [
            self.storeDropDown
        ]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initLocationManager()
        initUIViews()
        
        storeDropDown.dataSource = []
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        self.hideKeyboardWhenTappedAround()
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
        self.mapView.showsUserLocation = true
        self.mapView.delegate = self
    }
    
    func initUIViews(){
        btnRequest.setImage(imageResources.imgRequestClicked, for: .highlighted)
        btnRequest.setImage(imageResources.imgRequestClicked, for: .normal)
        btnPrev.setImage(imageResources.imgPrevClicked, for: .highlighted)
        btnPrev.setImage(imageResources.imgPrev, for: .normal)
    }
    
    //location delegate methods
    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]){
        let location = locations.last
        self.locationManager.stopUpdatingLocation()
        self.geocoder.reverseGeocodeLocation(location!, completionHandler: {(placemarks, error) -> Void in
            
            if error != nil {
                print("Reverse geocoder failed with error" + (error?.localizedDescription)!)
                return
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
            for index in 0...1{
                let selectedItem = self.storeList[index].placemark
                if selectedItem.name!.lowercased().range(of:"pharmacy") == nil && selectedItem.name!.lowercased().range(of:"gas") == nil{
                    self.dropPinZoomIn(placemark: selectedItem, sequence: index)
                }
            }
        }
    }
    
    @IBAction func btnOpenListPressed(_ sender: UIButton) {
        customizeDropDown(storeDropDown)
        storeDropDown.show()
    }
    
    @IBAction func btnDestinationPressed(_ sender: UIButton) {
        customizeDropDown(storeDropDown)
        storeDropDown.show()
    }
    
    
    @IBAction func btnRequestPressed(_ sender: BorderedButton) {
        let alert = UIAlertController(title: "Are you sure you want to request a ride?", message: "By tapping request, you agree to pay $10 at Meijer for your round trip.", preferredStyle: UIAlertControllerStyle.alert)
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
    
    func customizeDropDown(_ sender: AnyObject) {
        let appearance = DropDown.appearance()
        
        appearance.cellHeight = 60
        appearance.backgroundColor = UIColor(white: 1, alpha: 1)
        appearance.selectionBackgroundColor = UIColor(red: 0.6494, green: 0.8155, blue: 1.0, alpha: 0.2)
        appearance.cornerRadius = 10
        appearance.shadowColor = UIColor(white: 0.6, alpha: 1)
        appearance.shadowOpacity = 0.9
        appearance.shadowRadius = 25
        appearance.animationduration = 0.25
        appearance.textColor = btnDestination.tintColor
        appearance.direction = .top
        
        dropDowns.forEach {
            /*** FOR CUSTOM CELLS ***/
            $0.cellNib = UINib(nibName: "DropDownListCell", bundle: nil)
            
            $0.customCellConfiguration = { (index: Index, item: String, cell: DropDownCell) -> Void in
                guard let cell = cell as? DropDownListCell else { return }
                // Setup your custom UI components
                cell.suffixLabel.text = "\(self.storeDistance[index]) miles"
            }
        }
        
        storeDropDown.selectionAction = { [unowned self] (index, item) in
            self.btnDestination.setTitle(item, for: .normal)
            self.storeLat = self.storeDropDownList[index].coordinate.latitude
            self.storeLng = self.storeDropDownList[index].coordinate.longitude
            self.storeAddr = self.storeDropDownList[index].title!
            self.mapView.removeOverlays(self.routes)
            self.drawRoute(sourceLocation: CLLocationCoordinate2D(latitude: Double(self.defaults.string(forKey: addressKeys.myAddressLat)!)!, longitude: Double(self.defaults.string(forKey: addressKeys.myAddressLng)!)!), destinationLocation: CLLocationCoordinate2D(latitude: self.storeLat, longitude: self.storeLng))
        }
    }
    
    func dropPinZoomIn(placemark: MKPlacemark, sequence: Int){
        if !self.storeDropDown.dataSource.contains(placemark.title!){
            self.storeDropDown.dataSource.append(placemark.title!)
            self.storeDropDownList.append(placemark)
        }
        self.calculateDistance(sourceLocation: CLLocationCoordinate2D(latitude: Double(defaults.string(forKey: addressKeys.myAddressLat)!)!, longitude: Double(defaults.string(forKey: addressKeys.myAddressLng)!)!), destinationLocation: CLLocationCoordinate2D(latitude: placemark.coordinate.latitude, longitude: placemark.coordinate.longitude))
        if sequence == 0 && !self.ifRouteDrawn {
            btnDestination.setTitle(placemark.title!, for: .normal)
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
            }
        }
    }
    
    func calculateDistance(sourceLocation: CLLocationCoordinate2D, destinationLocation: CLLocationCoordinate2D){
        let request = MKDirectionsRequest()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: sourceLocation, addressDictionary: nil))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: destinationLocation, addressDictionary: nil))
        request.requestsAlternateRoutes = false
        request.transportType = .automobile
        let directions = MKDirections(request: request)
        directions.calculate { [unowned self] response, error in
            guard let unwrappedResponse = response else { return }
            let distance = Double(round(100*(Double((response!.routes.first?.distance)!)/1609))/100)
            if !self.storeDistance.contains(distance){
                self.storeDistance.append(distance)
            }
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
            btnDestination.setTitle(storeAddr, for: .normal)
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
