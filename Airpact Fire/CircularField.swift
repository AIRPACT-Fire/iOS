//
//  CircularField.swift
//  Airpact Fire
//
//  Created by Edoardo Franco Vianelli on 10/15/17.
//  Copyright © 2017 Edoardo Franco Vianelli. All rights reserved.
//

import UIKit

protocol CircularFieldDelegate{
    func textEntered(text : String?, sender : CircularField)
}

class CircularField: UITextField {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    var CircularFieldDelegate : CircularFieldDelegate?
    
    private var _id : Int = 0
    
    var ID : Int{
        return self._id
    }
    
    private func initAspect(){
        self.alpha = 0.75
        self.clipsToBounds = true
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 2.0
        self.layer.cornerRadius = self.frame.size.width / 2
        self.backgroundColor = UIColor.white
    }
    
    private func initPanGesture(){
        let panMotion = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(gesture:)))
        self.addGestureRecognizer(panMotion)
    }
    
    internal func handlePanGesture(gesture : UIPanGestureRecognizer){
        let tapLocation = gesture.location(in: self.superview)
        if (tapLocation.x + self.frame.size.width > self.superview!.frame.size.width
            || tapLocation.y + self.frame.size.height > self.superview!.frame.size.height
            || tapLocation.x < 0
            || tapLocation.y < 0){
            return
        }
        print(tapLocation)
        self.frame.origin = tapLocation
    }
    
    internal func keyboardHide(){
        self.resignFirstResponder()
        self.CircularFieldDelegate?.textEntered(text: self.text, sender: self)
    }
    
    private func setKeyboardHide(){
        self.addTarget(self, action: #selector(keyboardHide), for: UIControlEvents.editingDidEndOnExit)
    }
    
    init(frame: CGRect, text : String, id : Int) {
        super.init(frame: frame)
        self._id = id
        self.isUserInteractionEnabled = true
        self.initAspect()
        self.initPanGesture()
        self.setKeyboardHide()
        self.textAlignment = .center
        self.text = text
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
