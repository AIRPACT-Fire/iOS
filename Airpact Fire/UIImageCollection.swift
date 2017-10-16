//
//  UIImageCollection.swift
//  Airpact Fire
//
//  Created by Edoardo Franco Vianelli on 10/15/17.
//  Copyright © 2017 Edoardo Franco Vianelli. All rights reserved.
//

import UIKit

class UIImageCollection: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    private let imageDisplayer = UIImageView()
    
    private var currentIndex = 0
    private var imageCollection = [UIImage]()
    
    func loadCurrentIndex(){
        self.imageDisplayer.image = imageCollection[currentIndex]
    }
    
    func incrementCurrentIndex(){
        if (currentIndex + 1 < self.imageCollection.count){
            currentIndex += 1
        }
    }
    
    func decrementCurrentIndex(){
        if (currentIndex - 1 >= 0){
            currentIndex -= 1
        }
    }
    
    func initImageView(){
        self.imageDisplayer.frame.size = self.frame.size
        self.imageDisplayer.frame.origin = CGPoint.zero
        self.addSubview(self.imageDisplayer)
    }
    
    func initSwipeGestures(){
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(sender:)))
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(sender:)))
        leftSwipe.direction = .left
        rightSwipe.direction = .right
        self.addGestureRecognizer(leftSwipe)
        self.addGestureRecognizer(rightSwipe)
    }

    func handleSwipe(sender : UISwipeGestureRecognizer){
        if sender.direction == .left{
            incrementCurrentIndex()
        }else if sender.direction == .right{
            decrementCurrentIndex()
        }
        loadCurrentIndex()
    }
    
    func loadImages(_ images : [UIImage]){
        if images.count > 0{
            self.imageCollection = images
            self.imageDisplayer.image = images[0]
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initImageView()
        initSwipeGestures()
        print(self.frame)
        print(self.bounds)
    }

}
