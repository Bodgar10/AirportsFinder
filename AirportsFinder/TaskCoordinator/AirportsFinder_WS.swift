//
//  AirportsFinder_WS.swift
//  AirportsFinder
//
//  Created by bodgar jair espinosa miranda on 21/03/20.
//  Copyright © 2020 Bodgar. All rights reserved.
//

import UIKit

public class AirportsFinder_WS: AirPortTaskCoordinator {
    private let URL_Request = "https://cometari-airportsfinder-v1.p.rapidapi.com/api/airports/by-radius"
    public typealias CompletionBlock = ([AirPorts]?, CustomError?) -> Void
    
    public override init(){
        super.init()
        pathURL = URL_Request
    }
    
    public func executeService(parameters: AirportRequestParameters, handler: @escaping CompletionBlock){
        
        pathURL?.append("?radius=\(parameters.radius ?? 10)&lng=\(parameters.lng ?? 19.00)&lat=\(parameters.lat ?? -99.00)")
        DispatchQueue.global().async {
            self.requestService(nil, .get) { (result) in
                DispatchQueue.main.async {
                    if let error = result.error{
                        if error.code == 0 {
                            handler(self.getObjectArr(result.JSONArryDictionary), result.error)
                        }
                    }
                    handler(nil, result.error)
                }
            }
        }
    }
    
    public func getObjectArr(_ dctResponse: [[String: Any]]?) -> [AirPorts]? {
        guard let dctResponse = dctResponse else {return nil}
        var arrAirports: [AirPorts] = [AirPorts]()
        for objt in dctResponse{
            if let dctObject = self.getObject(objt) {
                arrAirports.append(dctObject)
            }
        }
        return arrAirports
    }
    
    public func getObject(_ dctResponse: [String: Any]?) -> AirPorts?{
        var objData: AirPorts = AirPorts()
        
        guard let dctResponse = dctResponse else {return nil}
        
        if let airportId = dctResponse[Constants.airportId] as? String {
            objData.airportId = airportId
        }
        
        if let code = dctResponse[Constants.code] as? String {
            objData.code = code
        }
        
        if let name = dctResponse[Constants.name] as? String {
            objData.name = name
        }
        
        if let location = dctResponse[Constants.location] as? NSDictionary {
            if let longitude = location[Constants.longitude] as? Double {
                objData.longitude = longitude
            }
            
            if let latitude = location[Constants.latitude] as? Double {
                objData.latitude = latitude
            }
        }
        
        if let cityId = dctResponse[Constants.cityId] as? String {
            objData.cityId = cityId
        }
        
        if let city = dctResponse[Constants.city] as? String {
            objData.city = city
        }
        
        if let countryCode = dctResponse[Constants.countryCode] as? String {
            objData.countryCode = countryCode
        }
        
        if let themes = dctResponse[Constants.themes] as? [String]{
            objData.themes = themes
        }
        
        if let pointsOfSale = dctResponse[Constants.pointsOfSale] as? [String]{
            objData.pointsOfSale = pointsOfSale
        }
        
        return objData
    }
}
