//
//  MyObserver.swift
//  Demo-KVO
//
//  Created by Kristina Gelzinyte on 5/2/18.
//  Copyright © 2018 Kristina Gelzinyte. All rights reserved.
//

import UIKit

class MyObserver: NSObject {

    var observation: NSKeyValueObservation? = nil
    
    @objc var objectToObserve: ViewController? {
        didSet {
            guard let objectToObserve = self.objectToObserve else { return }
            
            observation = objectToObserve.observe(\.observedButton.isSelected) { object, change in
                
                print("Button KVO was sent", self.objectToObserve?.observedButton.isSelected ?? "miau")
            }
        }
    }
    
    override init() {
        super.init()
    }
}
 
