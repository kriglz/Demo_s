//
//  ViewController.swift
//  Demo-KVO
//
//  Created by Kristina Gelzinyte on 5/2/18.
//  Copyright © 2018 Kristina Gelzinyte. All rights reserved.
//

import UIKit

@objc class ViewController: UIViewController {

    @IBOutlet weak var observedButton: UIButton!

    var myObserver = MyObserver()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.myObserver.objectToObserve = self
    }

    @IBAction func observedButtonAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        
        print("observedButton is selected \(sender.isSelected) \n\n")
    }    
}

