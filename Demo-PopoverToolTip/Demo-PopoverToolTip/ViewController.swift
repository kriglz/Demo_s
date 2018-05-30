//
//  ViewController.swift
//  Demo-PopoverToolTip
//
//  Created by Kristina Gelzinyte on 5/30/18.
//  Copyright © 2018 Kristina Gelzinyte. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPopoverPresentationControllerDelegate {

    let popoverViewController = PopoverLabelViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let popoverPresentationController = popoverViewController.popoverPresentationController {
            popoverPresentationController.sourceView = self.view
            popoverPresentationController.sourceRect = self.view.bounds
//            popoverPresentationController.delegate = self
        }
    }
    
    @IBAction func presentPopover(_ sender: UIButton) {
         self.present(popoverViewController, animated: true, completion: nil)
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
}

class PopoverLabelViewController: UIViewController {
    private let label: UILabel
    
    convenience init() {
        self.init(nibName: nil, bundle: nil)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        self.label = UILabel()
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        self.modalPresentationStyle = .popover
        self.popoverPresentationController?.backgroundColor = .green
        self.popoverPresentationController?.permittedArrowDirections = .any
        
        self.view.backgroundColor = .red
        self.view.layer.cornerRadius = 4
        self.view.clipsToBounds = true
        
        self.label.text = "text label"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(self.label)
        
        self.label.translatesAutoresizingMaskIntoConstraints = false
        
        self.label.setContentHuggingPriority(.defaultHigh, for: .vertical)
        self.label.setContentHuggingPriority(.defaultHigh, for: .horizontal)

        self.label.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.label.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        
        self.view.bottomAnchor.constraint(equalTo: self.label.bottomAnchor).isActive = true
        self.view.trailingAnchor.constraint(equalTo: self.label.trailingAnchor).isActive = true
    }
}
