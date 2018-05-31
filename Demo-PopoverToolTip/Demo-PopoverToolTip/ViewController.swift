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
    
    @IBOutlet weak var presentButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override var shouldAutorotate: Bool {
        return false
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    @IBAction func presentPopover(_ sender: UIButton) {
        self.popoverViewController.modalPresentationStyle = .popover
        
        self.popoverViewController.popoverPresentationController?.backgroundColor = .green
        self.popoverViewController.popoverPresentationController?.permittedArrowDirections = .any
        
        self.popoverViewController.popoverPresentationController?.delegate = self
        
        self.popoverViewController.popoverPresentationController?.sourceView = self.presentButton
        self.popoverViewController.popoverPresentationController?.sourceRect = self.presentButton.bounds
        
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
        self.label.lineBreakMode = .byWordWrapping
        self.label.numberOfLines = 0
        self.label.textAlignment = .center
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
   
        self.label.text = "test_label_jgkjyghejywgjhrvjdbvahfkajsf-asdfjkaudhf kuds fgaf"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(self.label)

        self.label.translatesAutoresizingMaskIntoConstraints = false

        self.label.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.label.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.view.bottomAnchor.constraint(equalTo: self.label.bottomAnchor).isActive = true
        self.view.trailingAnchor.constraint(equalTo: self.label.trailingAnchor).isActive = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.view.layoutIfNeeded()
        
        self.label.sizeToFit()
        self.view.sizeToFit()
        
        self.preferredContentSize = self.label.intrinsicContentSize

//        self.preferredContentSize = self.view.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
    }
}
