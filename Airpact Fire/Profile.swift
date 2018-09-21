//
//  Profile.swift
//  Airpact Fire
//
//  Created by Edoardo Franco Vianelli on 10/17/17.
//  Copyright © 2017 Edoardo Franco Vianelli. All rights reserved.
//  Overhauled by Jesse Bruce 2018
import Foundation



class Profile{
    
    private var loginCode = ""
    private var name : String = ""
    private var logins : Int = 0
    private var submittedPosts : Int = 0
    private var firstLoginDate : Date = Date(timeIntervalSinceNow: 0)
    var images : [AirpactImage?]
    
    var Secret : String{
        get{
            return self.loginCode
        }set{
            self.loginCode = newValue
        }
    }
    
    var Name : String{
        get{
            return self.name
        }set{
            self.name = newValue
        }
    }
    
    var Logins : Int{
        get{
            return self.logins
        }set{
            self.logins = newValue
        }
    }
    
    var SubmittedPosts : Int{
        get{
            return self.submittedPosts
        }set{
            self.submittedPosts = newValue
        }
    }
    
    var FirstLoginDate : Date {
        get{
            return self.firstLoginDate
        }set{
            self.firstLoginDate = newValue
        }
    }
    
    init(name : String, logins : Int, submittedPosts : Int, firstLoginDate : Date){
        self.name = name
        self.logins = logins
        self.submittedPosts = submittedPosts
        self.firstLoginDate = firstLoginDate
        self.images = [AirpactImage]()
    }
    
    func addImage(newImage : AirpactImage){
        images.append(newImage)
        //UserDefaults.standard.set(images, forKey: "airpactImages")
    }

}










