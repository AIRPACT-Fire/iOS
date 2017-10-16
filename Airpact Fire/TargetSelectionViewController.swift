//
//  TargetSelectionViewController.swift
//  Airpact Fire
//
//  Created by Edoardo Franco Vianelli on 10/15/17.
//  Copyright © 2017 Edoardo Franco Vianelli. All rights reserved.
//

import UIKit

class TargetSelectionViewController: UIViewController {
    
    private var images = [UIImage]()
    
    @IBOutlet weak var imageShower: UIImageCollection!
    func loadImages(images : [UIImage]){
        self.images = images
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.imageShower.loadImages(self.images)
        
        //self.currentImageView.clipsToBounds = true
        //self.currentImageView.isUserInteractionEnabled = true
        //self.currentImage = self.images[0]
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func goBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    var markers = [CircularLabel]()
    
    @IBAction func addMarker(_ sender: UIBarButtonItem) {
        if (markers.count < 2){
            let newMarkerFrame = CGRect(x: 30.0, y: 30.0, width: 50.0, height: 50.0)
            let newMarker = CircularLabel(frame: newMarkerFrame, text: "\(markers.count+1)")
            //self.currentImageView.addSubview(newMarker)
            markers.append(newMarker)
        }else{
            let maxReachedAlert = UIAlertController(title: "Limit reached", message: "You can only drop two markers", preferredStyle: .alert)
            maxReachedAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            present(maxReachedAlert, animated: true, completion: nil)
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
