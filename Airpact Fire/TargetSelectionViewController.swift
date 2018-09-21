//
//  TargetSelectionViewController.swift
//  Airpact Fire
//
//  Created by Edoardo Franco Vianelli on 10/15/17.
//  Copyright © 2017 Edoardo Franco Vianelli. All rights reserved.
//  Overhauled by Jesse Bruce 2018

import UIKit
import Foundation
import CoreLocation
import Photos


class TargetSelectionViewController: UIViewController {
    var page = 0
    var total_marker_count = 0
    var markers = [[CircularField]]()
    var singleImageSelection : Bool = true
    private var profile : Profile?
    private var locationName = ""
    private var locationManager = CLLocationManager()
    private var picker : UIImagePickerController?
    private var lastLocation : CLLocation?
    private var targetImages : [UIImage?] = []
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet var edgePan: UIScreenEdgePanGestureRecognizer!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var secondDistanceField: UITextField!
    @IBOutlet weak var firstDistanceField: UITextField!
    
    @IBAction func swiped(_ sender: Any) {
        
    }
    @IBAction func takePhoto(_ sender: Any) {
        
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            
            alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (alert:UIAlertAction!) -> Void in
                self.pickFromCamera()
            }))
            
            alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { (alert:UIAlertAction!) -> Void in
                self.pickFromGallery()
            }))
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
    }

    @IBAction func proceedPressed(_ sender: Any) {
        singlePhotoAlgorithmCall()
    }
    
    @IBAction func deletePhoto(_ sender: Any) {
        for photo in self.markers {
            for marker in photo {
                marker.removeFromSuperview()
            }
        }
        self.markers.removeAll()
        self.total_marker_count = 0
    }
    
    @IBAction func addMarker(_ sender: UIBarButtonItem) {
        if (total_marker_count < 2){
            let newMarkerFrame = CGRect(x: 30.0, y: 30.0, width: 50.0, height: 50.0)
            let newMarker = CircularField(frame: newMarkerFrame, text: "\(total_marker_count+1)", id: total_marker_count+1)
//            let index_to_add = singleImageSelection || (!singleImageSelection && total_marker_count < 1) ? 0 : 1
//            if markers.count <= index_to_add {
//                markers.append([CircularField]())
//            }
//            markers[index_to_add].append(newMarker)
            self.imageView.addSubview(newMarker)
            total_marker_count += 1
        }
        else {
            let maxReachedAlert = UIAlertController(title: "Limit reached", message: "You can only drop two markers", preferredStyle: .alert)
            maxReachedAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            present(maxReachedAlert, animated: true, completion: nil)
        }
    }
    
    func setProfile(newProfile : Profile){
        self.profile = newProfile
    }
    
    func pickFromCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let pickerController = UIImagePickerController()
            pickerController.delegate = self as? UIImagePickerControllerDelegate & UINavigationControllerDelegate;
            pickerController.sourceType = .camera
            pickerController.allowsEditing = true
            self.present(pickerController, animated: true, completion: nil)
        }
    }
    
    func pickFromGallery() {
        if targetImages.count == 1 && singleImageSelection {
            let maxReachedAlert = UIAlertController(title: "Limit reached", message: "Hit add to switch to double image selection", preferredStyle: .alert)
            maxReachedAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            maxReachedAlert.addAction(UIAlertAction(title: "Add", style: .default, handler:{ (action) -> () in
                self.singleImageSelection = false
                self.total_marker_count = 4
            }))
            present(maxReachedAlert, animated: true, completion: nil)
        } else {
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
                let pickerController = UIImagePickerController()
                pickerController.delegate = self as? UIImagePickerControllerDelegate & UINavigationControllerDelegate;
                pickerController.sourceType = .photoLibrary
                self.present(pickerController, animated: true, completion: nil)
            }
        }
    }
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.newImage(nImage: image)
            // self.targetImages.append(image)
            
        }else{
            print("image picker failed to grab image")
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func newImage(nImage: UIImage) {
        self.imageView.image = nImage
        self.targetImages.append(nImage)
        changedImage(index: self.targetImages.count-1)
    }
    
    func changedImage(index : Int) {
        
        for photo in self.markers {
            for marker in photo {
                marker.removeFromSuperview()
            }
        }
        self.imageView.image = self.targetImages[index]
        if !self.singleImageSelection{ //two images

            //switch to the previous markers

            if page < self.markers.count{
                self.markers[page].first?.removeFromSuperview()
            }
            //page = index
            if page < self.markers.count{
                self.view.addSubview(self.markers[page].first!)
            }
        }
        
    }
    
    func createLocationDescription(){
        lastLocation = locationManager.location
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(lastLocation!,
            completionHandler: { (placemarks, error) in
                if error == nil {
                    self.locationName = (placemarks?[0].name)!
                }
        })
    }
    
    func singlePhotoAlgorithmCall(){
        if self.markers.count < 2 {
            let alert = UIAlertController(title: "Incorrect number of markers", message: "Please ensure there are two markers set on the image", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
            return
        } else if (secondDistanceField.text?.isEmpty)! || (firstDistanceField.text?.isEmpty)!{
            let alert = UIAlertController(title: "Incorrect estimates", message: "Please ensure to input estiamted distances to each target", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
            return
        }
        createLocationDescription()
        print("send request")
        let uploadTask = URLSession.shared.dataTask(with: formSinglePhotoURL(), completionHandler: {
            (data : Data?, response : URLResponse?, error : Error?) in
            self.handleUploadResponse(data: data, response: response, error: error)
        })
        
        uploadTask.resume()
    }
    
    func formSinglePhotoURL() -> URLRequest {
        let uploadUrl = URL(string: "http://airpactfire.eecs.wsu.edu/file_upload/upload")
        var uploadURLRequest = URLRequest(url: uploadUrl!)
        uploadURLRequest.httpMethod = "POST"
        
        let jsonBody : NSMutableDictionary = NSMutableDictionary()
        
        jsonBody.setValue("AlgorithmOne", forKey: "algorithmType")
        jsonBody.setValue(self.profile!.Name, forKey: "user")
        jsonBody.setValue(self.profile!.Secret, forKey: "secretKey")
        jsonBody.setValue("Uploaded from my iPhone", forKey: "description")
        jsonBody.setValue(locationName, forKey: "location")
        jsonBody.setValue(lastLocation?.coordinate.latitude, forKey: "gpsLatitude")
        jsonBody.setValue(lastLocation?.coordinate.longitude, forKey: "gpsLongitude")
        if Int(firstDistanceField.text!)! < Int(secondDistanceField.text!)! {
            jsonBody.setValue(Int(self.markers[0][0].frame.origin.x), forKey: "nearX")
            jsonBody.setValue(Int(self.markers[0][0].frame.origin.y), forKey: "nearY")
            jsonBody.setValue(Int(self.markers[0][1].frame.origin.x), forKey: "farX")
            jsonBody.setValue(Int(self.markers[0][1].frame.origin.y), forKey: "farY")
            jsonBody.setValue(Int(firstDistanceField.text!), forKey: "nearDistance")
            jsonBody.setValue(Int(secondDistanceField.text!), forKey: "farDistance")
            jsonBody.setValue(8, forKey: "nearRadius")
            jsonBody.setValue(8, forKey: "farRadius")
        } else {
            jsonBody.setValue(Int(self.markers[0][1].frame.origin.x), forKey: "nearX")
            jsonBody.setValue(Int(self.markers[0][1].frame.origin.y), forKey: "nearY")
            jsonBody.setValue(Int(self.markers[0][0].frame.origin.x), forKey: "farX")
            jsonBody.setValue(Int(self.markers[0][0].frame.origin.y), forKey: "farY")
            jsonBody.setValue(Int(secondDistanceField.text!), forKey: "nearDistance")
            jsonBody.setValue(Int(firstDistanceField.text!), forKey: "farDistance")
            jsonBody.setValue(8, forKey: "nearRadius")
            jsonBody.setValue(8, forKey: "farRadius")
        }
        let imageData = UIImagePNGRepresentation(targetImages[0]!)!
        jsonBody.setValue (imageData.base64EncodedString(options: Data.Base64EncodingOptions.lineLength64Characters), forKey: "image")
        var bodyData : Data?
        do{
            bodyData = try JSONSerialization.data(withJSONObject: jsonBody, options: JSONSerialization.WritingOptions())
            uploadURLRequest.httpBody = bodyData
        } catch {
            print("error")
        }
        uploadURLRequest.addValue("XMLHttpRequest", forHTTPHeaderField: "X-Requested-With")
        uploadURLRequest.addValue("application/json;charset=utf-8", forHTTPHeaderField: "Content-Type")
        uploadURLRequest.addValue(String(data: bodyData!, encoding: .utf8)!, forHTTPHeaderField: "Content-Length")
        return uploadURLRequest
    }
    
    func handleUploadResponse(data : Data?, response : URLResponse?, error : Error?) {
        if let uploadError = error{
            print(uploadError)
        } else {
            if let u_data = data {
                do{
                    if let res = try JSONSerialization.jsonObject(with: u_data, options: JSONSerialization.ReadingOptions()) as? [String: Any]{
                        print(res["status"]!)
                        if let iID = res["imageID"] as? Int {
                            self.profile?.addImage(newImage: AirpactImage(i: targetImages.last!!, iid: iID, pid: 0, cR: (res["output"] as? Double)!, loc: locationName, coords: self.lastLocation!))
                        } else {
                            print("Upload failed")
                        }
                    } else {
                        print("error decoding json response")
                    }
                }catch{
                    print("error decoding json response")
                }
            }
        }
    }
    func swipeRight(sender: UIScreenEdgePanGestureRecognizer) {
        
    }
    
    func swipeLeft(sender: UIScreenEdgePanGestureRecognizer) {
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        var edgePanRight = UIScreenEdgePanGestureRecognizer(target: self,action: Selector(("swipeRight:")))
        var edgePanLeft = UIScreenEdgePanGestureRecognizer(target: self,action: Selector(("swipeLeft:")))
        edgePanRight.edges = .right
        edgePanLeft.edges = .left
        self.targetImages.append(UIImage(named: "ChugachMountains.jpg"))
        self.imageView.image = self.targetImages.last!
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
        AVCaptureDevice.requestAccess(for: AVMediaType.video) { response in
            if response {
                print("camera auth")
                //access granted
            } else {
                print("failed camera auth")
            }
        }
        
        //Photos
        let photos = PHPhotoLibrary.authorizationStatus()
        if photos == .notDetermined {
            PHPhotoLibrary.requestAuthorization({status in
                if status == .authorized{
                    print("gallery auth")
                } else {
                    print("failed gallery auth")
                }
            })
        }
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Pass the selected object to the new view controller.
        
    }
    @IBAction func prepareForCancelCreationUnwind(for segue: UIStoryboardSegue, sender: Any?){
        
    }
    

}















