//
//  LoginData.swift
//  Airpact Fire
//
//  Created by Edoardo Franco Vianelli on 11/10/17.
//  Copyright © 2017 Edoardo Franco Vianelli. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class LoginData {
    
    static var viewContext : NSManagedObjectContext {
        get{
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            return appDelegate.persistentContainer.viewContext
        }
    }
    
    static func stringToDate(_ dateString : String) -> Date{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss" //Your date format
        //dateFormatter.timeZone = TimeZone(abbreviation: "+0000") //Current time zone
        let date = dateFormatter.date(from: dateString.replacingOccurrences(of: "+0000", with: "")) //according to date format your date string
        return date!
    }
    
    static func hasProfile(_ userProfile : Profile, allProfiles : [Profile]) -> Profile?{
        
        for profile in allProfiles{
            if (profile.Name == userProfile.Name){ return profile }
        }
        
        return nil
    }
    
    static func objectToProfile(profile : NSManagedObject) -> Profile?{
        guard let name = profile.value(forKey: "name") as? String else { return nil }
        guard let logins = profile.value(forKey: "logins") as? Int else{ return nil }
        guard let submittedPosts = profile.value(forKey: "submittedPosts") as? Int else{ return nil }
        guard let firstLoginDate = profile.value(forKey: "firstLoginDate") as? String else{ return nil }
        
        let savedProfile = Profile(name: name,
                                   logins: logins,
                                   submittedPosts: submittedPosts,
                                   firstLoginDate: stringToDate(firstLoginDate))
        return savedProfile
    }
    
    static func getAllProfileObjects() -> [NSManagedObject]{
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "CoreProfile")
        var profiles = [NSManagedObject]()
        do{
            profiles = try viewContext.fetch(fetchRequest)
            return profiles
        }catch{
            
        }
        return [NSManagedObject]()
    }
    
    static func deleteAllProfiles(){
        for profile in getAllProfileObjects(){
            viewContext.delete(profile)
        }
        do { try viewContext.save() }
        catch {}
    }
    
    static func getAllProfiles() -> [Profile]{
        var allProfiles = [Profile]()

        let profiles = getAllProfileObjects()
        
        for profile in profiles{
            guard let userProfile = objectToProfile(profile: profile) else { return allProfiles }
            allProfiles.append(userProfile)
        }
        
        return allProfiles
    }
    
    static func fetchProfile(_ userProfile : Profile) -> Profile?{
        guard let profile = hasProfile(userProfile, allProfiles: getAllProfiles()) else { return nil }
        return profile
    }
    
    static func save(_ userProfile : Profile){
        guard let profileEntity = NSEntityDescription.entity(forEntityName: "CoreProfile", in: viewContext) else {  return }
        
        let coreDataProfile = NSManagedObject(entity: profileEntity, insertInto: viewContext)
        coreDataProfile.setValue(userProfile.Name, forKey: "name") //save the name
        coreDataProfile.setValue(userProfile.Logins, forKey: "logins")
        coreDataProfile.setValue(userProfile.SubmittedPosts, forKey: "submittedPosts")
        coreDataProfile.setValue(userProfile.FirstLoginDate.description, forKey: "firstLoginDate")
        
        do{
            try viewContext.save()
        }catch let error as NSError{
            print(error)
        }
        
        //self.userProfile = userProfile // set the returned user profile
    }
}
