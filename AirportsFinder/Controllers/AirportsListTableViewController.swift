//
//  AirportsListTableViewController.swift
//  AirportsFinder
//
//  Created by bodgar jair espinosa miranda on 21/03/20.
//  Copyright © 2020 Bodgar. All rights reserved.
//

import UIKit
import CoreLocation

class AirportsListTableViewController: UITableViewController, CLLocationManagerDelegate{

    var arrAirPorts: [AirPorts] = []
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTableView()
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.startMonitoringSignificantLocationChanges()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        do {
            let airportsObj = UserDefaults.standard.object(forKey: "Airports")
            let arrAirPorts = try JSONDecoder().decode([AirPorts].self, from: airportsObj as! Data)
            self.arrAirPorts = arrAirPorts
        }catch let err {
            print(err)
        }
    }
    
    private func setupTableView(){
        tableView.tableFooterView = UIView()
        tableView.register(UINib(nibName: "AirportsTableViewCell", bundle: nil),
        forCellReuseIdentifier: "AirportsTableViewCell")
        tableView.allowsSelection = false
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.arrAirPorts.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "AirportsTableViewCell", for: indexPath) as? AirportsTableViewCell {
            
            let airports = self.arrAirPorts[indexPath.row]
            
            cell.lblNameAirport.text = airports.name
            cell.lblCountryAirport.text = airports.city
            cell.lblDistanceAirport.text = "\(String(format: "%.2f", distanceBetweenTwoLocations(latitudeAirport: airports.latitude, longitudeAirport: airports.longitude))) kms"
            return cell
        }
        
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func distanceBetweenTwoLocations(latitudeAirport: Double?, longitudeAirport: Double?) -> Double {
        guard let location = locationManager.location,
            let longitude = longitudeAirport,
            let latitude = latitudeAirport else {return 0}
        
        let coordinateAirport = CLLocation(latitude: latitude, longitude: longitude)
        let coordinateUser = CLLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        
        let distanceInMeters = coordinateAirport.distance(from: coordinateUser)
        let kilometters = distanceInMeters / 1000
        
        return kilometters
    }

}
