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
        fetchProfile((profile?.Name)!, "")
        // Do any additional setup after loading the view.
    }
    
    func fetchProfile(_ username : String, _ password : String){

        
        self.profile = Profile(name: username, logins: 0, submittedPosts: 0, firstLoginDate: Date(timeIntervalSinceNow: 0))
        
        let serverRequest = formProfileURL()
        
        let loginTask = URLSession.shared.dataTask(with: serverRequest, completionHandler: {
            (data : Data?, response : URLResponse?, error : Error?) in
            self.handleProfileResponse(data: data, response: response, error: error)
        })
        
        loginTask.resume()
    }
    
    func formProfileURL() -> URLRequest{
        let loginUrl = URL(string: "http://airpactfire.eecs.wsu.edu/user/profile/" + (profile?.Name)!)
        
        var loginURLRequest = URLRequest(url: loginUrl!)
        
        loginURLRequest.httpMethod = "GET"
        
        let jsonBody : NSMutableDictionary = NSMutableDictionary()
        
//        jsonBody.setValue(username, forKey: "username")
//        jsonBody.setValue(password, forKey: "password")
        
        var bodyData : Data?
        
        do{
            bodyData = try JSONSerialization.data(withJSONObject: jsonBody, options: JSONSerialization.WritingOptions())
            loginURLRequest.httpBody = bodyData
        }catch {
            print("error")
        }
        
        loginURLRequest.addValue("XMLHttpRequest", forHTTPHeaderField: "X-Requested-With")
        loginURLRequest.addValue("application/json;charset=utf-8", forHTTPHeaderField: "Content-Type")
        loginURLRequest.addValue(String(data: bodyData!, encoding: .utf8)!, forHTTPHeaderField: "Content-Length")
        
        return loginURLRequest
    }
    
    func handleProfileResponse(data : Data?, response : URLResponse?, error : Error?){
    
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
