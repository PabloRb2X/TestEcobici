//
//  TokenModel.swift
//  Ecobici
//
//  Created by Pablo Ramirez on 1/31/19.
//  Copyright © 2019 Pablo Ramirez. All rights reserved.
//

import Foundation

struct AccessToken: Decodable {
    var access_token: String?
    var expires_in: Int?
    var token_type: String?
    var scope: String?
    var refresh_token: String?
}

