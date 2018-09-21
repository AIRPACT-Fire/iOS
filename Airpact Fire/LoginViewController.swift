//
//  LoginViewController.swift
//  Airpact Fire
//
//  Created by Edoardo Franco Vianelli on 9/2/17.
//  Copyright © 2017 Edoardo Franco Vianelli. All rights reserved.
//  Overhauled by Jesse Bruce 2018

import UIKit

protocol LoginDelegate {
    
    func loginSuccessful(newProfile : Profile)
    func loginFailed()
    func loginInitiated()
    
}

class LoginViewController: UIViewController, LoginDelegate, CheckBoxButtonDelegate{

    let settings = Settings()
    var loginAgent : AirpactLogin?
    var profile : Profile?
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
        if let saved = UserDefaults.value(forKey: "AirpactSaved") as? [String] {
            usernameField.text = saved[0]
            passwordField.text = saved[1]
        } else if self.rememberMeCheck.checked {
            UserDefaults.setValue([usernameField.text!, passwordField.text!], forKey: "AirpactSaved")
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
        self.usernameField.isEnabled = false
        self.passwordField.isEnabled = false
        self.username = usernameField.text!
        self.password = passwordField.text!
        logIn(withUsername: self.username, withPassword: self.password)
    }
    
    func logIn(withUsername : String, withPassword : String) {
        self.loginAgent = AirpactLogin()
        self.loginAgent?.delegate = self
        self.loginAgent?.initiateLogin(withUsername, withPassword)
    }
    
    func signUpTerminated() {
        print("signup terminated")
    }

    func signUpFailed() {
        print("signup failed")
    }
    
    @IBAction func signUp(_ sender: Any) {
        if let signUpUrl = URL(string: "http://airpactfire.eecs.wsu.edu/user/register") {
            UIApplication.shared.open(signUpUrl, options: Dictionary<String,Any>(), completionHandler: {
                (completed : Bool) in
                if completed {
                    self.signUpTerminated()
                } else {
                    self.signUpFailed()
                }
            })
        }
    }
    
    @IBAction func getInfo() {
        if let infoUrl = URL(string: "http://airpactfire.eecs.wsu.edu/about") {
            UIApplication.shared.open(infoUrl, options: Dictionary<String, Any>(), completionHandler: {
                (completed : Bool) in
            })
        }
    }
    
    func loginCompleted() {
        DispatchQueue.main.async(execute: {
            self.loginSpinner.stopAnimating()
            self.loginSpinner.isHidden = true
            self.usernameField.isEnabled = true
            self.passwordField.isEnabled = true
        })
    }
    
    /*MARK: CheckBoxButton Delegate*/
    
    func tapped(checked: Bool) {
        rememberMe = !rememberMe
    }
        
    /*MARK: Login Delegate*/
    
    
    func loginSuccessful(newProfile : Profile) {
        print("login success")
        self.profile = newProfile
        if UserDefaults.standard.value(forKey: "AirpactProfile-" + usernameField.text!) != nil {
            self.profile = (UserDefaults.standard.value(forKey: "AirpactProfile-" + usernameField.text!) as? Profile)!
        } else {
            if self.rememberMeCheck.checked {
                UserDefaults.setValue([usernameField.text!, passwordField.text!], forKey: "AirpactSaved")
            }
            self.profile?.images = [AirpactImage]()
        }
        loginCompleted()
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "mainViewSegue", sender: self)
        }
    }
    
    func loginFailed(){
        DispatchQueue.main.async(execute: {
            self.loginCompleted()
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
    
        if let destination = segue.destination as? ProfileDetailViewController{
            destination.setProfile(newProfile: self.profile!)
        }
    }
    @IBAction func prepareForLogout(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
}

























