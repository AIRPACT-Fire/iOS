//
//  ProfileDetailViewController.swift
//  Airpact Fire
//
//  Created by Edoardo Franco Vianelli on 10/17/17.
//  Copyright © 2017 Edoardo Franco Vianelli. All rights reserved.
//  Overhauled by Jesse Bruce 2018

import UIKit
import CoreLocation

class ProfileDetailViewController: UIViewController {
    private var profile : Profile?
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var firstLoginLabel: UILabel!
    
    @IBOutlet weak var numberLoginsLabel: UILabel!
    @IBOutlet weak var numberPostsLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        firstLoginLabel?.text = self.profile?.FirstLoginDate.description
        numberLoginsLabel.text = String(format: "%d", (self.profile?.Logins)!)
        numberPostsLabel.text = String(format: "%d", (self.profile?.SubmittedPosts)!)
        self.usernameLabel.text = self.profile?.Name
        
        //test image
        if profile?.images.count == 0 {
            profile?.images.append(AirpactImage(i: UIImage(named: "az.jpg")!, iid: 0, pid: 0, cR: 12.4567, loc: "Arizona", coords: CLLocation(latitude: 34.354366, longitude: -111.738357)))
        }
        
        // Do any additional setup after loading the view.
    }

    
   
    func setProfile(newProfile : Profile){
        self.profile = newProfile
    }
    
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
    */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let destination = segue.destination as? MainMapViewController {
            destination.setProfile(newProfile: self.profile!)
        } else if let destination = segue.destination as? TableViewController {
            destination.setProfile(newProfile: self.profile!)
        } else if let destination = segue.destination as? TargetSelectionViewController {
            destination.setProfile(newProfile: self.profile!)
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    @IBAction func prepareForUnwind(for segue: UIStoryboardSegue, sender: Any?){
        
    }

}
