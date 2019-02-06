//
//  StationsModel.swift
//  Ecobici
//
//  Created by Pablo Ramirez on 1/31/19.
//  Copyright © 2019 Pablo Ramirez. All rights reserved.
//

import Foundation
import UIKit

struct Stations: Decodable {
    var stations: [Station]
}

struct Station: Decodable{
    var id: Int?
    var name: String?
    var address: String?
    var addressNumber: String?
    var zipCode: String?
    var districtCode: String?
    var districtName: String?
    var altitude: String?
    var nearbyStations: [Int]?
    var location: [String:AnyObject]?
    var stationType: String?
    
    init(from decoder: Decoder) throws {
        location = [:]
        nearbyStations = []
    }
}
