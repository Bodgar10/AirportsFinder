//
//  ViewController.swift
//  AirportsFinder
//
//  Created by bodgar jair espinosa miranda on 21/03/20.
//  Copyright © 2020 Bodgar. All rights reserved.
//

import UIKit
import CoreLocation

class SearchViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var lblDistanceKm: UILabel!

    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    var valueKm = 10
    var airportsFounded: [AirPorts] = []

    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.startMonitoringSignificantLocationChanges()
    }
    
    func recoverAirportsWithRadius() {
        self.startActivityIndicator()
        guard let location = locationManager.location else {
            self.present(AlertFactory.simpleWith(message: "Hubo un error al recuperar tu ubicación, inténtalo más tarde."),
                         animated: true,
                         completion: nil)
            self.stopActivityIndicator()
            return
        }
        var params: AirportRequestParameters = AirportRequestParameters()
        params.lat = location.coordinate.latitude
        params.lng = location.coordinate.longitude
        params.radius = self.valueKm
        
        let requestAirports: AirportsFinder_WS = AirportsFinder_WS()
        requestAirports.executeService(parameters: params) { (arrAirports, error) in
            if error?.code == 0{
                self.stopActivityIndicator()
                if let arrAirports = arrAirports {
                    self.airportsFounded = arrAirports
                    if let encoded = try? JSONEncoder().encode(self.airportsFounded) {
                        UserDefaults.standard.set(encoded, forKey: "Airports")
                        UserDefaults.standard.set(self.valueKm, forKey: "Distance")
                        self.performSegue(withIdentifier: "SearchViewControllerToShowMapViewController", sender: self)
                    }
                }
            }else{
                self.stopActivityIndicator()
                self.present(AlertFactory.doubleWith(title: "Airports Finder",
                                                     message: "Hubo un error: \(error?.localizedDescription ?? "Desconocido")",
                    firstActionTitle: "Cancelar",
                    secondActionTitle: "Reintentar",
                    secondActionHandler: { (_) in
                    self.recoverAirportsWithRadius()
                }), animated: true,
                    completion: nil)
            }
        }
    }
    
    @IBAction func slideActionDistance(_ sender: UISlider) {
        valueKm = Int(sender.value)
        lblDistanceKm.text = String(Int(sender.value))
    }
    
    @IBAction func btnSearch(_ sender: ButtonExtension) {
        
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined, .restricted, .denied:
                AlertFactory.sendToSettings()
            case .authorizedAlways, .authorizedWhenInUse:
                self.recoverAirportsWithRadius()
            }
        } else {
            print("Location services are not enabled")
        }
    }
    
    func startActivityIndicator(){
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorView.Style.whiteLarge
        self.view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
    }
    
    func stopActivityIndicator(){
        activityIndicator.stopAnimating()
        UIApplication.shared.endIgnoringInteractionEvents()
    }
}
