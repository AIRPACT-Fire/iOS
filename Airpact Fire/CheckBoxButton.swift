//
//  CheckBoxButton.swift
//  Airpact Fire
//
//  Created by Edoardo Franco Vianelli on 10/1/17.
//  Copyright © 2017 Edoardo Franco Vianelli. All rights reserved.
//

import UIKit

protocol CheckBoxButtonDelegate{
    func tapped(checked : Bool)
}

class CheckBoxButton: UIButton {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    var checked : Bool{
        get{
            return self.tapped
        }set{
            if newValue == checked{
                return
            }
            set_tapped()
        }
    }
    
    var delegate : CheckBoxButtonDelegate?
    
    internal var tapped = false
    
    let unchecked_name = "ic_check_box_outline_blank_3x.png"
    let checked_name = "ic_check_box_3x.png"
    
    var unchecked_image : UIImage?
    var checked_image : UIImage?
    
    internal func addTap(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(set_tapped))
        self.addGestureRecognizer(tapGesture)
    }
    
    func initImages(){
        unchecked_image = UIImage(named: unchecked_name)
        checked_image = UIImage(named: checked_name)
        assert(unchecked_image != nil)
        assert(checked_image != nil)
    }
    
    @objc internal func set_tapped(){
        tapped = !tapped
        setImageForTapped()
        delegate?.tapped(checked: tapped)
    }
    
    internal func setImageForTapped(){
        if tapped{
            self.setImage(checked_image, for: .normal)
        }else{
            self.setImage(unchecked_image, for: .normal)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addTap()
        initImages()
    }
    
}
