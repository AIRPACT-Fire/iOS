//
//  TargetSelectionViewController.swift
//  Airpact Fire
//
//  Created by Edoardo Franco Vianelli on 10/15/17.
//  Copyright © 2017 Edoardo Franco Vianelli. All rights reserved.
//

import UIKit

class TargetSelectionViewController: UIViewController, ImageCollectionDelegate, CircularFieldDelegate {
    
    func textEntered(text: String?, sender: CircularField) {
        if sender.ID == 1{
            firstDistanceField.text = text
        }else if sender.ID == 2{
            secondDistanceField.text = text
        }
    }

    
    var singleImageSelection : Bool{
        return self.images.count == 1
    }
    
    @IBOutlet weak var secondDistanceField: UITextField!
    @IBOutlet weak var firstDistanceField: UITextField!
    
    var mainMapDelegate : MainMapReturnDelegate?
    
    private var images = [UIImage]()
    
    @IBOutlet weak var imageShower: UIImageCollection!
    func loadImages(images : [UIImage]){
        self.images = images
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.imageShower.delegate = self
        self.imageShower.loadImages(self.images)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func goBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    
    @IBAction func retakePhoto() {
        self.dismiss(animated: true, completion: {
            self.mainMapDelegate?.requestedPictureRetake()
        })
    }
    
    var marker_locations = [[CircularField]]()

    private var total_marker_count = 0
    
    //if we have a single image, we can have two markers on it
    //if we have two images, we can have a marker in each
    
    @IBAction func addMarker(_ sender: UIBarButtonItem) {
        if (total_marker_count < 2){
            let newMarkerFrame = CGRect(x: 30.0, y: 30.0, width: 50.0, height: 50.0)
            let newMarker = CircularField(frame: newMarkerFrame, text: "\(total_marker_count+1)", id: total_marker_count+1)
            newMarker.CircularFieldDelegate = self
            let index_to_add = singleImageSelection  || (!singleImageSelection && total_marker_count < 1) ? 0 : 1
            if marker_locations.count <= index_to_add {
                marker_locations.append([CircularField]())
            }
            marker_locations[index_to_add].append(newMarker)
            self.imageShower.addSubview(newMarker)
            total_marker_count += 1
        }
        else {
            let maxReachedAlert = UIAlertController(title: "Limit reached", message: "You can only drop two markers", preferredStyle: .alert)
            maxReachedAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            present(maxReachedAlert, animated: true, completion: nil)
        }
    }
    
    var current_index = 0
    
    func changedImage(index: Int) {
        
        
        if !self.singleImageSelection{ //two images
            
            //switch to the previous markers
            
            if current_index < self.marker_locations.count{
                self.marker_locations[current_index].first?.removeFromSuperview()
            }
            current_index = index
            if current_index < self.marker_locations.count{
                self.view.addSubview(self.marker_locations[current_index].first!)
            }
        }
        
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
    }
    

}















