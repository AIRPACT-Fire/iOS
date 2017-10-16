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

class MainMapViewController: UIViewController, UINavigationControllerDelegate, CLLocationManagerDelegate, UIImagePickerControllerDelegate, AirpactFireMapDelegate{

    let postManager = PostManager()
    
    @IBOutlet private weak var usernameLabel: UILabel!
    
    var username : String = ""
    
    @IBOutlet weak var map: AirpactFireMap!
    let locationManager = CLLocationManager()
    var picker : UIImagePickerController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.map.mapDelegate = self
        
        usernameLabel.text = username
        
        self.locationManager.delegate = self
        
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse || CLLocationManager.authorizationStatus() == .authorizedAlways{
            locationManager.startUpdatingLocation()
        }else{
            locationManager.requestWhenInUseAuthorization()
        }
        
        // Do any additional setup after loading the view.
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse || status == .authorizedAlways{
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let location = locations.first{
            let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, 500, 500)
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
    
    var single : Bool?
    
    func promptSingleOrDoubleImage(){
        let singleDoubleAlert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        singleDoubleAlert.addAction(UIAlertAction(title: "Single", style: .default, handler: {
            
            (action : UIAlertAction?) in
            
            self.single = true
            self.showPicker(true)
        
        }))
        singleDoubleAlert.addAction(UIAlertAction(title: "Double", style: .default, handler: {
            
            (action : UIAlertAction?) in
            
            self.single = false
            self.showPicker(false)
            
        }))
        singleDoubleAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(singleDoubleAlert, animated: true, completion: nil)
    }
    
    func initializePicker(_ source : UIImagePickerControllerSourceType){
        picker = UIImagePickerController()
        picker?.delegate = self
        picker?.sourceType = source
    }
    
    func showPicker(_ single : Bool){
        if let imagePicker = picker{
            present(imagePicker, animated: true, completion: {
                print("finished")
            })
        }
    }
    
    @IBAction func pickFromGallery() {
        initializePicker(.photoLibrary)
        promptSingleOrDoubleImage()
    }

    @IBAction func takePicture() {
        initializePicker(.camera)
        promptSingleOrDoubleImage()
    }

    func mapScrolled() {
        print("Scrolled")
    }
    
    func mapTapFired() {
        print("tapped")
    }
    
    //MARK: Image picker delegate
    
    func promptForSecondImage(){
        //take another image
        
        let secondImagePrompt = UIAlertController(title: "Please pick a second image", message: "(possibly of the same location)", preferredStyle: .alert)
        secondImagePrompt.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (action : UIAlertAction?) in
            self.showPicker(true)
            self.single = nil
        }))
        present(secondImagePrompt, animated: true, completion: {
            
            //after the user has acknowledged that they need to take the second image
            

            
        })
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: {
            
        })
        print("Cancelled")
    }
    
    var pickedImages = [UIImage]()
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
            pickedImages.append(image)
        }
        dismiss(animated: true, completion: {
            if self.single == false{
                self.promptForSecondImage()
            }else{
                self.performSegue(withIdentifier: "TargetSelectionSegue", sender: self) 
            }
        })
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    
        if let destinationView = segue.destination as? TargetSelectionViewController{
            destinationView.loadImages(images: self.pickedImages)
        }
    }
    

}























