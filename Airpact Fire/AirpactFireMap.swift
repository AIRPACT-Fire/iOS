//
//  AirpactFireMap.swift
//  Airpact Fire
//
//  Created by Edoardo Franco Vianelli on 9/30/17.
//  Copyright © 2017 Edoardo Franco Vianelli. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

protocol AirpactFireMapDelegate{
        func mapTapFired()
        func mapScrolled()
}

class AirpactFireMap: MKMapView, UIGestureRecognizerDelegate {

    var mapDelegate : AirpactFireMapDelegate?
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    
    internal func tapHandler(sender : UITapGestureRecognizer){
        mapDelegate?.mapTapFired()
    }
    
    internal func panHandler(sender : UIPanGestureRecognizer){
        mapDelegate?.mapScrolled()
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    private func initTapGesture(){
        let tapToHide = UITapGestureRecognizer(target: self, action: #selector(tapHandler(sender:)))
        self.addGestureRecognizer(tapToHide)
    }
    
    private func initPanGesture(){
        let panToHide = UIPanGestureRecognizer(target: self, action: #selector(panHandler(sender:)))
        self.addGestureRecognizer(panToHide)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}










