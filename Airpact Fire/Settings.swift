//
//  Settings.swift
//  Airpact Fire
//
//  Created by Edoardo Franco Vianelli on 10/1/17.
//  Copyright © 2017 Edoardo Franco Vianelli. All rights reserved.
//  Overhauled by Jesse Bruce 2018

import Foundation

class Settings{
    
    var username : String{
        get{
            if let stored = UserDefaults.standard.value(forKey: "username") as? String{
                return stored
            }
            return ""
        }set{
                UserDefaults.standard.set(newValue, forKey: "username")
        }
    }
    
    var password : String{
        get{
            if let stored = UserDefaults.standard.value(forKey: "password") as? String{
                return stored
            }
            return ""
        }set{
            UserDefaults.standard.set(newValue, forKey: "password")
        }
    }
    
    var rememberMe : Bool {
        get{
            if let stored = UserDefaults.standard.value(forKey: "rememberMe") as? Bool{
                return stored
            }
            return false
        }set{
            UserDefaults.standard.set(newValue, forKey: "rememberMe")
        }
    }
    
    
    
    
}














