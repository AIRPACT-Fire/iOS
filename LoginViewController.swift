//
//  LoginViewController.swift
//  Airpact Fire
//
//  Created by Edoardo Franco Vianelli on 9/2/17.
//  Copyright © 2017 Edoardo Franco Vianelli. All rights reserved.
//

import UIKit

protocol LoginDelegate {
    
    func loginSuccessfull(userProfile : Profile)
    func loginFailed()
    func loginInitiated()
    
}

class LoginViewController: UIViewController, LoginDelegate, CheckBoxButtonDelegate{

    let settings = Settings()
    
    @IBOutlet weak var rememberMeCheck: CheckBoxButton!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var loginSpinner: UIActivityIndicatorView!
    
    var rememberMe : Bool {
        get{
            return self.settings.rememberMe
        }set{
            self.settings.rememberMe = newValue
        }
    }
    
    var loginAgent : AirpactLogin?
    
    var password : String{
        get{
            return passwordField.text!
        }set{
            self.passwordField.text = newValue
        }
    }
    
    var username : String{
        get{
            return usernameField.text!
        }
        set{
            self.usernameField.text = newValue
        }
    }
    
    func loadStoredLoginDetails(){
        let storedUsername = self.settings.username
        let storedPassword = self.settings.password
        if (storedUsername == "" && storedPassword == ""){
            return
        }
        if self.settings.rememberMe{
            self.username = storedUsername
            self.password = storedPassword
            self.logIn(withUsername: self.username, withPassword: self.password)
        }
    }
    
    func loadRememberMe(){
        rememberMeCheck.checked = self.settings.rememberMe
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadRememberMe()
        self.loadStoredLoginDetails()
        self.rememberMeCheck.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signInRequested(_ sender: Any) {
        logIn(withUsername: self.username, withPassword: self.password)
    }
    
    func logIn(withUsername : String, withPassword : String){
        self.loginAgent = AirpactLogin()
        self.loginAgent?.delegate = self
        self.settings.username = withUsername
        self.settings.password = withPassword
        self.loginAgent?.initiateLogin(withUsername, withPassword)
    }
    
    func signUpTerminated(){
        
    }

    func signUpFailed(){
        
    }
    
    @IBAction func signUp(_ sender: Any) {
        if let signUpUrl = URL(string: "http://airpactfire.eecs.wsu.edu/user/register"){
            UIApplication.shared.open(signUpUrl, options: Dictionary<String,Any>(), completionHandler: {
                (completed : Bool) in
                
                if completed{
                    self.signUpTerminated()
                }else{
                    self.signUpFailed()
                }
                
            })
        }
    }
    
    @IBAction func getInfo() {
        if let infoUrl = URL(string: "http://airpactfire.eecs.wsu.edu/about"){
            UIApplication.shared.open(infoUrl, options: Dictionary<String, Any>(), completionHandler: {
                (completed : Bool) in
            })
        }
    }
    
    func loginTerminated(){
        DispatchQueue.main.async(execute: {
            self.loginSpinner.stopAnimating()
            self.loginSpinner.isHidden = true
        })
    }
    
    /*MARK: CheckBoxButton Delegate*/
    
    func tapped(checked: Bool) {
        rememberMe = !rememberMe
    }
        
    /*MARK: Login Delegate*/
    
    var userProfile : Profile?
    
    func loginSuccessfull(userProfile : Profile){
    
        var resultingProfile = userProfile
        
        print("Success")
        
        loginTerminated()
        
        if let storedProfile = LoginData.fetchProfile(userProfile){        //see if there is a profile with this name
            storedProfile.Logins += 1 //increase the logins by 1
            storedProfile.FirstLoginDate = userProfile.FirstLoginDate
            resultingProfile = storedProfile
        }else{ //there is no such profile
            resultingProfile.Logins += 1 //increase logins by 1
            LoginData.save(resultingProfile)
        }
        
        self.userProfile = resultingProfile
        
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "mainViewSegue", sender: self)
        }
    }
    
    func loginFailed(){
        DispatchQueue.main.async(execute: {
            self.loginTerminated()
            let failedAlert = UIAlertController(title: "Login failed", message: "Try a different username or password or try again later", preferredStyle: .alert)
            failedAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.show(failedAlert, sender: self)
        })
    }
    
    func loginInitiated(){
        loginSpinner.isHidden = false
        loginSpinner.startAnimating()
    }
    
    @IBAction func usernameEnterPressed() {
        usernameField.resignFirstResponder()
        passwordField.becomeFirstResponder()
    }

    @IBAction func passwordEnterPressed() {
        passwordField.resignFirstResponder()
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    
        if let destination = segue.destination as? MainMapViewController{
            destination.setProfile(userProfile: self.userProfile!)
        }
    }
    

}

























