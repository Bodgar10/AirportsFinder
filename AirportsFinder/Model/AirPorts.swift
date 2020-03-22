//
//  AirPorts.swift
//  AirportsFinder
//
//  Created by bodgar jair espinosa miranda on 21/03/20.
//  Copyright © 2020 Bodgar. All rights reserved.
//

import Foundation

public struct AirPorts: Codable{
    public var airportId: String?
    public var code: String?
    public var name: String?
    public var longitude: Double?
    public var latitude: Double?
    public var cityId: String?
    public var city: String?
    public var countryCode: String?
    public var themes: [String]?
    public var pointsOfSale: [String]?
}
