//
//  AirpactLogin.swift
//  Airpact Fire
//
//  Created by Edoardo Franco Vianelli on 9/2/17.
//  Copyright © 2017 Edoardo Franco Vianelli. All rights reserved.
//  Overhauled by Jesse Bruce 2018

import Foundation

class AirpactLogin : NSObject, URLSessionDelegate{
    
    private var userProfile : Profile?
    
    var delegate : LoginDelegate?
    
    override init() {
        super.init()
    }
    
    private func formURLRequest(_ username : String, _ password : String) -> URLRequest{

        let loginUrl = URL(string: "http://airpactfire.eecs.wsu.edu/user/appauth")

        var loginURLRequest = URLRequest(url: loginUrl!)
        
        loginURLRequest.httpMethod = "POST"
        
        let jsonBody : NSMutableDictionary = NSMutableDictionary()
        
        jsonBody.setValue(username, forKey: "username")
        jsonBody.setValue(password, forKey: "password")
        
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
    
    private func isAuthenticationSuccessful(response : [String: Any]) -> Bool{
        if (response.index(forKey: "isUser") != nil){
            self.userProfile!.Secret = response["secretKey"]! as! String
            return response["isUser"] as! String == "true"
        }
        return false
    }
    
    private func handleLoginResponse(data : Data?, response : URLResponse?, error : Error?){
        if let loginError = error{
            print(loginError)
            self.delegate?.loginFailed()
        }else{
            
            if let u_data = data{
                do{
                    if let jsonEncoding = try JSONSerialization.jsonObject(with: u_data, options: JSONSerialization.ReadingOptions()) as? [String: Any]{
                        if isAuthenticationSuccessful(response: jsonEncoding){
                            self.userProfile?.Secret = jsonEncoding["secretKey"]! as! String
                            delegate?.loginSuccessful(newProfile: self.userProfile!)
                        }else{
                            delegate?.loginFailed()
                        }
                    }
                }catch{
                    print("error decoding json response")
                }
            }
        }
    }
        
    func initiateLogin(_ username : String, _ password : String){
        delegate?.loginInitiated()
        
        /*Form the URL*/
        
        self.userProfile = Profile(name: username, logins: 0, submittedPosts: 0, firstLoginDate: Date(timeIntervalSinceNow: 0))
        
        let serverRequest = formURLRequest(username, password)
            
        let loginTask = URLSession.shared.dataTask(with: serverRequest, completionHandler: {
            (data : Data?, response : URLResponse?, error : Error?) in
            self.handleLoginResponse(data: data, response: response, error: error)
        })
        
        loginTask.resume()
    }
    
}
















