//
//  GeneralFunctions.swift
//  Ecobici
//
//  Created by Pablo Ramirez on 1/30/19.
//  Copyright © 2019 Pablo Ramirez. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import LocalAuthentication

let serviceManager: ServiceManager = ServiceManager()
let timerToken: TimerToken = TimerToken()

let regularFontSize: CGFloat = 16
let barColor = "#E1E2E3"

let setTimeOutRequest = 59.0
let setTimeOutResource = 59.0

let ACCESS_TOKEN_REQUEST: Int = 1
let REFRESH_TOKEN_REQUEST: Int = 2
let STATIONS_REQUEST: Int = 3

let CLIENT_ID: String = "1614_56est3sgy1kwsgok4c4ogc0c4sw0wkgsckk0kwkkog4o444osc"
let CLIENT_SECRET: String = "2jtvtsgt8fswg84wo4ock8g0s4kkw8k4cosc4s4cgkcg8c0oog"
var accessToken: String = ""
var refreshToken: String = ""

var countdownTimer: Timer!
var countSecondsTimer: Int!

let locationManager: CLLocationManager! = {
    let manager = CLLocationManager()
    manager.desiredAccuracy = kCLLocationAccuracyBest
    manager.requestAlwaysAuthorization()
    return manager
}()

func checkPermissions() -> Bool {
    if CLLocationManager.locationServicesEnabled() {
        
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined, .restricted, .denied:
            
            return false
        case .authorizedAlways, .authorizedWhenInUse:
            
            return true
        }
    } else {
        
        return false
    }
}

func getCurrentLocation() -> CLLocation{
    
    locationManager.requestAlwaysAuthorization()
    locationManager.startUpdatingLocation()
    locationManager.desiredAccuracy = kCLLocationAccuracyBest
    
    if let _ = locationManager.location {
        
        return locationManager.location!
    }
    else{
        
        print("no tenemos location")
        let aux_location = CLLocation(latitude: 0, longitude: 0)
        
        return aux_location
    }
}

