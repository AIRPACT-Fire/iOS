//
//  airpactImage.swift
//  Airpact Fire
//
//  Created by Jesse on 4/01/18.
//  Copyright © 2018 Jesse Bruce. All rights reserved.
//
import UIKit
import Foundation
import CoreLocation

struct AirpactImage {
    var imageID : Int
    var postID : Int
    var calulatedRange : Double
    var imageLocation : String
    var coordinates : CLLocation
    var image : UIImage
    
    init(i : UIImage, iid : Int, pid : Int, cR : Double, loc : String, coords : CLLocation){
        self.image  = i
        self.imageID = iid
        self.postID = pid
        self.calulatedRange = cR
        self.imageLocation = loc
        self.coordinates = coords
    }
}
