//
//  ProfileDetailViewController.swift
//  Airpact Fire
//
//  Created by Edoardo Franco Vianelli on 10/17/17.
//  Copyright © 2017 Edoardo Franco Vianelli. All rights reserved.
//

import UIKit

class ProfileDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var usernameLabel: UILabel!
    private var profile : Profile?
    @IBOutlet weak var profileTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.profileTable.delegate = self
        self.profileTable.dataSource = self
        self.usernameLabel.text = self.profile?.Name
        
        // Do any additional setup after loading the view.
    }
    
    func setProfile(profile : Profile){
        self.profile = profile
    }
    
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    let images = [UIImage(named:"ic_cake_48pt_3x.png"),
                  UIImage(named:"ic_insert_chart_48pt_3x.png"),
                  UIImage(named:"ic_check_48pt_3x.png")]
    
    let titles = ["First login date",
                  "Number of login sessions",
                  "Number of submitted posts"]

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currentCell = tableView.dequeueReusableCell(withIdentifier: "profileInfoCell", for: indexPath)
        
        let subtitles = [profile!.FirstLoginDate.description,
                         "\(profile!.Logins)",
                         "\(profile!.SubmittedPosts)"]
        
        currentCell.textLabel?.text = self.titles[indexPath.row]
        currentCell.imageView?.image = self.images[indexPath.row]
        currentCell.detailTextLabel?.text = subtitles[indexPath.row]
        
        return currentCell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
