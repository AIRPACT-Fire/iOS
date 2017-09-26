//
//  LoginViewController.swift
//  Airpact Fire
//
//  Created by Edoardo Franco Vianelli on 9/2/17.
//  Copyright © 2017 Edoardo Franco Vianelli. All rights reserved.
//

import UIKit

protocol LoginDelegate {
    
    func loginSuccessfull()
    func loginFailed()
    func loginInitiated()
    
}

class LoginViewController: UIViewController, LoginDelegate{

    @IBOutlet weak var rememberMeCheck: UIButton!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var loginSpinner: UIActivityIndicatorView!
    var rememberMe : Bool = false
    var loginAgent : AirpactLogin?
    
    var password : String{
        return passwordField.text!
    }
    
    var username : String{
        return usernameField.text!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signInRequested(_ sender: Any) {
        loginAgent = AirpactLogin()
        loginAgent?.delegate = self
        loginAgent?.initiateLogin(username, password)
    }

    @IBAction func signUp(_ sender: Any) {
    }
    
    @IBAction func rememberMeTapped(_ sender: Any) {
        rememberMe = !rememberMe
    }
    
    @IBAction func getInfo() {
    }
    
    /*Login Delegate*/
    
    func loginSuccessfull(){
    
        print("Success")
        
        loginSpinner.stopAnimating()
        loginSpinner.isHidden = true
    
    }
    
    func loginFailed(){
        DispatchQueue.main.async(execute: {
            self.loginSpinner.stopAnimating()
            let failedAlert = UIAlertController(title: "Login failed", message: "Try a different username or password or try again later", preferredStyle: .alert)
            failedAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.show(failedAlert, sender: self)
        })
    }
    
    func loginInitiated(){
        loginSpinner.isHidden = false
        loginSpinner.startAnimating()
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
