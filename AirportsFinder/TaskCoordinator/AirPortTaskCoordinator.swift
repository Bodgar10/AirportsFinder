//
//  AirPortTaskCoordinator.swift
//  AirportsFinder
//
//  Created by bodgar jair espinosa miranda on 21/03/20.
//  Copyright © 2020 Bodgar. All rights reserved.
//

import UIKit

public class AirPortTaskCoordinator: NSObject{
    private let strBaseURL = ""
    var pathURL: String?
    
    // MARK: - Type Alias
    typealias JSONDictionary     = [String:Any]
    typealias JSONArryDictionary = [[String:Any]]
    typealias ResultsQuery       = (_ result: Results) -> Void
    
    private var httpBody: Data?
    
    func requestService(_ dctRequest: [String: Any]? = nil,
                        _ httpMethod: HttpMethod = .post,
                        completion: @escaping ResultsQuery) {
        
        //Create a configurations session
        let configurationSession = URLSessionConfiguration.default
        
        //Create sesion
        let session = URLSession(configuration: configurationSession)
        
        guard let request = prepareURLRequest(httpMethod, with: dctRequest) else {return}
        
        //Create the task
        let task = session.dataTask(with: request) { (data, response, error) in
            if error != nil{
                completion(Results(withError: CustomError.request(error: error)))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else{
                completion(Results(withError: CustomError.errorHTTPResponseCode))
                return
            }
            
            guard let data = data else {
                completion(Results(withError: NSError(domain: "dataNilError", code: -10011, userInfo: nil)))
                return
            }
            
            if let strResponse = String.init(data: data, encoding: .ascii) {
                print("Response taskcoordinator", strResponse)
            }
            self.parseData(with: data, httpMethod, response, completion: completion)
        }
        task.resume()
    }
    
    func parseData(with data: Data,
                   _ httpMethod: HttpMethod = .post,
                   _ response: URLResponse?,
                   completion: ResultsQuery) {
        switch httpMethod {
        case .post:
            do {
                if let dataResponse = String.init(data: data, encoding: .ascii)?.data(using: .utf8){
                    guard let parseData = try JSONSerialization.jsonObject(with: dataResponse, options: .mutableContainers) as? JSONDictionary else {
                        return completion(Results(withError: CustomError.errorHTTPResponseCode))
                    }
                    completion(Results(withData: data, dictionary: parseData, response: Response(fromURLResponse: response), error: CustomError.success))
                }
            }catch let error {
                completion(Results(withError: CustomError.errorHTTPResponseCode))
                print("Error JSONDictionary", error.localizedDescription)
            }
        default:
            do {
                if let dataResponse = String.init(data: data, encoding: .ascii)?.data(using: .utf8){
                    guard let parseData = try JSONSerialization.jsonObject(with: dataResponse, options: .mutableContainers) as? JSONArryDictionary else{
                        return completion(Results(withError: CustomError.errorHTTPResponseCode))
                    }
                    completion(Results(withData: data, arrayDic: parseData, response: Response(fromURLResponse: response), error: CustomError.success))
                }
            }catch let error {
                completion(Results(withError: CustomError.errorHTTPResponseCode))
                print("Error JSONArryDictionary", error.localizedDescription)
            }
        }
    }
    
    func prepareURLRequest(_ httpMethod: HttpMethod = .post,
                           with dctRequest: [String: Any]? = nil) -> URLRequest?{
        guard let pathURL = pathURL, let url = URL(string: String(format: "%@%@", strBaseURL, pathURL)) else {return nil}
        
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue
        
        switch httpMethod {
        case .post:
            request.addValue("text/plain", forHTTPHeaderField: "Content-Type")
            request.addValue("text/plain", forHTTPHeaderField: "Accept")
            request.httpBody = self.getHTTPBody(with:dctRequest)
        case .get:
            let headers = [
                "x-rapidapi-host": "cometari-airportsfinder-v1.p.rapidapi.com",
                "x-rapidapi-key": "7cf7191745mshcdf00469873d934p1a4df6jsn44355785aa3c"
            ]
            request.httpBody = self.getHTTPBody(with:dctRequest)
            request.allHTTPHeaderFields = headers
        }
        return request
    }
    
    private func getHTTPBody(with dctRequest: [String: Any]?, _ httpMethod: HttpMethod = .post) -> Data?{
        switch httpMethod {
        case .post, .get:
            if let dctRequest = dctRequest{
                var bodyData = Data()
                guard let json = try? JSONSerialization.data(withJSONObject: dctRequest, options: .prettyPrinted) else {return nil}
                
                bodyData.append(json)
                return bodyData
            }
        }
        return nil
    }
}

extension AirPortTaskCoordinator{
    enum HttpMethod: String {
        case get
        case post
    }
    
    // Managing the response
    struct Response {
        var response: URLResponse? // Data
        var httpStatusCode: Int = 0 // code response
        
        init(fromURLResponse response: URLResponse?) {
            guard let response = response else { return }
            self.response = response
            httpStatusCode = (response as? HTTPURLResponse)?.statusCode ?? 0
        }
    }
    
    struct Results {
        var JSONDictionary: [String : Any]? //post
        var JSONArryDictionary: [[String : Any]]? //get
        
        var data: Data?
        var response: Response?
        var error: CustomError? = .success
        
        init(withData data: Data?,
             arrayDic: [[String: Any]]? = nil,
             dictionary: [String: Any]? = nil,
             response: Response?, error: Error?) {
            self.data = data
            self.response = response
            self.error = error as? CustomError
            self.JSONDictionary = dictionary
            self.JSONArryDictionary = arrayDic
        }
        
        init(withError error: Error) {
            self.error = error as? CustomError
        }
    }
    
    public enum CustomError: Error {
        case success
        case failedToCreateRequest
        case errorHTTPResponseCode
        case request(error: Error?)
        case noInternetConnection(error: Error?)
        
        public var domain: Error{
            switch self {
            case .errorHTTPResponseCode, .failedToCreateRequest:
                return NSError(domain: "AirportsFinder.AirPortTaskCoordinator", code: -1001, userInfo: nil)
            case .request(let error):
                return NSError(domain: (error! as NSError).domain, code: (error! as NSError).code, userInfo: nil)
            case .noInternetConnection:
                return NSError(domain: "AirportsFinder.AirPortTaskCoordinator", code: 0, userInfo: nil)
            default:
                return NSError(domain: "AirportsFinder.AirPortTaskCoordinator", code: 0, userInfo: nil)
            }
        }
        public var code: Int {
            switch self {
            case .errorHTTPResponseCode, .failedToCreateRequest:
                return (domain as NSError).code
            default:
                return (domain as NSError).code
            }
        }
    }
}

extension AirPortTaskCoordinator.CustomError : LocalizedError{
    public var localizedDescription: String {
        switch self {
        case .errorHTTPResponseCode, .failedToCreateRequest:
            return NSLocalizedString("Unable to create the URLRequest object", comment: "")
        case .success:
            return NSLocalizedString("Success", comment: "")
        case .request(let error):
            return NSLocalizedString(error?.localizedDescription ?? "Error request dataTask", comment: "")
        case .noInternetConnection(let error):
            return NSLocalizedString( error?.localizedDescription ?? "No hay conexión a internet", comment: "")
        }
    }
}
