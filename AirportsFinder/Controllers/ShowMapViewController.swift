//
//  ShowMapViewController.swift
//  AirportsFinder
//
//  Created by bodgar jair espinosa miranda on 21/03/20.
//  Copyright © 2020 Bodgar. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ShowMapViewController: UIViewController, CLLocationManagerDelegate {

    var arrAirPorts: [AirPorts] = []
    
    @IBOutlet weak var mapKitView: MKMapView!
    var locationManager = CLLocationManager()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.startMonitoringSignificantLocationChanges()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        mapKitView.showsUserLocation = true
        
        do {
            let airportsObj = UserDefaults.standard.object(forKey: "Airports")
            let arrAirPorts = try JSONDecoder().decode([AirPorts].self, from: airportsObj as! Data)
            self.arrAirPorts = arrAirPorts
            
            for annotationAirports in self.arrAirPorts {
                let annotation = MKPointAnnotation()
                annotation.title = annotationAirports.name ?? "Desconocido"
                annotation.subtitle = annotationAirports.city ?? "Desconocido"
                annotation.coordinate = CLLocationCoordinate2D(latitude: annotationAirports.latitude ?? 19.00, longitude: annotationAirports.longitude ?? -99.00)
                mapKitView.addAnnotation(annotation)
                
            }
        }catch let err {
            print(err)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last{
            let distance = UserDefaults.standard.integer(forKey: "Distance")
            let region = MKCoordinateRegionMakeWithDistance(location.coordinate, CLLocationDistance(distance * 1000), CLLocationDistance(distance * 1000))
            self.mapKitView.setRegion(region, animated: true)
        }
    }
}
