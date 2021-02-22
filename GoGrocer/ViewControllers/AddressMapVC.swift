//
//  AddressMapVC.swift
//  GoGrocer
//
//  Created by Pooja on 23/07/20.
//  Copyright © 2020 Komal Gupta. All rights reserved.
//

import UIKit
import MapKit

class AddressMapVC: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var viewSeach: UIView!
    @IBOutlet weak var lblShowLocation: UILabel!
    
        var getCurrenAddress = String()
        var mapData: MKMapItem!
        var selectedPin:MKPlacemark? = nil
        var mapHasCenteredOnce = false
        var resultSearchController:UISearchController? = nil
        let locationManager = CLLocationManager()
    
        override func viewDidLoad() {
            super.viewDidLoad()
            lblShowLocation.text = getCurrenAddress
            // Track user location
            mapView.delegate = self
            mapView.userTrackingMode = MKUserTrackingMode.follow
            mapView.showsUserLocation = true
        
            //Tap gesture to return to mapView when tapped on screen
            let singleTap = UITapGestureRecognizer(target:self, action:#selector(self.handleSingleTap(gesture:)))
            singleTap.numberOfTouchesRequired = 1
            singleTap.addTarget(self, action:#selector(self.handleSingleTap(gesture:)))
            mapView.isUserInteractionEnabled = true
            mapView.addGestureRecognizer(singleTap)
            
            let locationSearchTable = storyboard!.instantiateViewController(withIdentifier: "LocationSearchTableViewController") as! LocationSearchTableViewController
            resultSearchController = UISearchController(searchResultsController: locationSearchTable)
            resultSearchController?.searchResultsUpdater = locationSearchTable
            
            let searchBar = resultSearchController!.searchBar
            
            searchBar.placeholder = "Search your places"
            viewSeach.addSubview(searchBar)
            searchBar.setTextColor(color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
            searchBar.setPlaceholderTextColor(color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
            searchBar.setSearchImageColor(color: #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1))
            if #available(iOS 13.0, *) {
                searchBar.searchTextField.backgroundColor = #colorLiteral(red: 0.8374180198, green: 0.8374378085, blue: 0.8374271393, alpha: 1)
            } else {
                // Fallback on earlier versions
            }
            searchBar.barTintColor = #colorLiteral(red: 0.8374180198, green: 0.8374378085, blue: 0.8374271393, alpha: 1)
            searchBar.clipsToBounds = true
            searchBar.sizeToFit()
            resultSearchController?.hidesNavigationBarDuringPresentation = false
            resultSearchController?.dimsBackgroundDuringPresentation = true
            definesPresentationContext = true
            
            locationSearchTable.mapView = mapView
            locationSearchTable.handleMapSearchDelegate = self
        }
    
        //MARK:- IBAction:-
    
    @IBAction func BackAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func getLiveLoctionAction(_ sender: UIButton) {
    mapView.userTrackingMode = MKUserTrackingMode.follow
    mapView.showsUserLocation = true
        
    }
    
    //function called for Tap gesture
        @objc func handleSingleTap(gesture: UITapGestureRecognizer){
            view.endEditing(true)
        }
        //check the status for requestWhenInUseAuthorization
        override func viewDidAppear(_ animated: Bool) {
            locationAuthStatus()
        }
        //Request user Auth to use location services
        func locationAuthStatus() {
            if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
                mapView.showsUserLocation = true
            } else {
                locationManager.requestWhenInUseAuthorization()
            }
            
        }
    
    
        //display user location(blue dot) in mapView
        func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
            if status == .authorizedWhenInUse {
                mapView.showsUserLocation = true
            }
        }
        // Center mapView on userLocation
        func centerMapOnLocation(location : CLLocation) {
            let coordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 2000, longitudinalMeters: 2000)
            mapView.setRegion(coordinateRegion, animated: true)
            
        }
    
        func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
             var center = mapView.centerCoordinate
            print(center)
        }
        // checks mapHasCenteredOnce Flag
        func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
            if let loc = userLocation.location {
                if !mapHasCenteredOnce {
                    centerMapOnLocation(location: loc)
                    mapHasCenteredOnce = true
                }
            }
        }
        //Creates custom AnnotationView when Clicked on the pin
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?{
            if annotation is MKUserLocation {
                //return nil so map view draws "blue dot" for standard user location
                return nil
            }
            let reuseId = "pin"
            var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView?.pinTintColor = UIColor.orange
            pinView?.canShowCallout = true
            let smallSquare = CGSize(width: 30, height: 30)
            let button = UIButton(frame: CGRect(origin: .zero, size: smallSquare))
            button.setBackgroundImage(UIImage(named: "car"), for: [])
            button.addTarget(self, action: #selector(AddressMapVC.getDirections), for: .touchUpInside)
            pinView?.leftCalloutAccessoryView = button
            return pinView
        }
        //Launches driving directions with AppleMaps
        @objc func getDirections(){
            if let selectedPin = selectedPin {
                let mapItem = MKMapItem(placemark: selectedPin)
                let launchOptions = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving]
                mapItem.openInMaps(launchOptions: launchOptions)
            }
        }
        
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }

    }

//Drops Cutsom Pin Annotation In the mapView
extension AddressMapVC: HandleMapSearch {
   func dropPinZoomIn(placemark:MKPlacemark){
    
       
       lblShowLocation.text = placemark.locality
        // cache the pin
        selectedPin = placemark
        // clear existing pins
        mapView.removeAnnotations(mapView.annotations)
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        annotation.title = placemark.name
        if let city = placemark.locality,
            let state = placemark.administrativeArea {
            annotation.subtitle = "\(city) \(state)"
        }
        mapView.addAnnotation(annotation)
    let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    let region = MKCoordinateRegion(center: placemark.coordinate, span: span)
        mapView.setRegion(region, animated: true)
    }
    
}
