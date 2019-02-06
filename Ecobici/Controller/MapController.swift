//
//  MapController.swift
//  Ecobici
//
//  Created by Pablo Ramirez on 1/30/19.
//  Copyright © 2019 Pablo Ramirez. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation

class MapController: UIViewController, GMSMapViewDelegate, MapDelegate {
    
    let mapCView: MapView = MapView()
    
    var map: GMSMapView!
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        initView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        serviceManager.stationsService(referenceController: self)
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }
    
    func initView(){
        self.view = mapCView.initView(reference: self, view: self.view)
        self.map = mapCView.map
        self.map.delegate = self
        map.isMyLocationEnabled = true
        map.settings.myLocationButton = true
        mapCView.mapDelegate = self
        
    }
    
    func showStationsInMap(stations: [[String:AnyObject]]){
        mapCView.hideLoader()
        
        print("show markers")
        mapCView.showMarkersStations(stations: stations)
    }
    
    func sessionExpired(){
        mapCView.showAlertSessionExpired(reference: self)
        
        //serviceManager.refreshTokenService(referenceController: self)
    }
    
    func errorsEvents(){
        mapCView.hideLoader()
        ////////////////////// Mostrar una ventana de error
        
        mapCView.showAlertError(reference: self, titleText: "Error", textMessage: "Error al cargar las estaciones cercanas")
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        
        let camera: GMSCameraPosition = GMSCameraPosition.camera(withLatitude: marker.position.latitude, longitude: marker.position.longitude, zoom: 18.0)
        map.animate(to: camera)
        mapView.delegate = self
        
        if let userData = marker.userData as? [String:AnyObject] {
            print("name = \(userData["name"])")
            if mapCView.isDetailViewActive{
                mapCView.hideDetailsMarker(showAgain: true, userData: userData)
            }
            else{
                mapCView.showDetailsMarker(userData: userData)
            }
        }
        
        return true
    }
    
    public func didTapMyLocationButton(for mapView: GMSMapView) -> Bool {
        print("tap en mylocationbutton")
        
        return true
    }
    
    public func mapView(_ mapView: GMSMapView, didTap overlay: GMSOverlay) {
        print("tap en el mapa")
        if mapCView.isDetailViewActive{
            mapCView.hideDetailsMarker(showAgain: false)
        }
    }
    
    @objc func onButtonPressed(sender: UIButton){
        dismiss(animated: true, completion: nil)
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

// MARK: - CLLocationManagerDelegate
extension MapController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        guard status == .authorizedWhenInUse else {
            return
        }
        
        locationManager.startUpdatingLocation()
        
        map.isMyLocationEnabled = true
        map.settings.myLocationButton = true
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }
        
        map.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
        
        locationManager.stopUpdatingLocation()
    }
}
