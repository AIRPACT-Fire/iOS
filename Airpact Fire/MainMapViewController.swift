//
//  MainMapViewController.swift
//  Airpact Fire
//
//  Created by Edoardo Franco Vianelli on 9/26/17.
//  Copyright © 2017 Edoardo Franco Vianelli. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

//implement queued photos when phone is not connected


class MainMapViewController: UIViewController, UINavigationControllerDelegate, CLLocationManagerDelegate{

    private var currentProfile : Profile?
    @IBOutlet weak var map: MKMapView!
    private let locationManager = CLLocationManager()
    
    func dropPins(){
        for loc in (currentProfile?.images)! {
            let marker = MKPointAnnotation()
            marker.coordinate = (loc?.coordinates.coordinate)!
            marker.title = loc?.imageLocation
            marker.subtitle = String(format: "Visual Range: %.3fKM", (loc?.calulatedRange)!)
            map.addAnnotation(marker)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.locationManager.delegate = self
        
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse || CLLocationManager.authorizationStatus() == .authorizedAlways{
            locationManager.startUpdatingLocation()
        }else{
            locationManager.requestWhenInUseAuthorization()
        }
        dropPins()
        // Do any additional setup after loading the view.
    }
    
    
    
    func setProfile(newProfile : Profile){
        //self.profile = newProfile
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse || status == .authorizedAlways{
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let location = locations.first{
            let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, 50000, 50000)
            map.setRegion(coordinateRegion, animated: true)
            manager.stopUpdatingLocation()
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func mapScrolled() {
        print("scrolled")
    }
    
    func mapTapFired() {
        print("tapped")
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    
    }
    
}























