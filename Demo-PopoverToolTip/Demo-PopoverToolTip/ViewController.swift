//
//  ViewController.swift
//  Demo-PopoverToolTip
//
//  Created by Kristina Gelzinyte on 5/30/18.
//  Copyright © 2018 Kristina Gelzinyte. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let wrapperViewController = WrapperController()
    
    @IBOutlet weak var presentButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addChildViewController(self.wrapperViewController)
        self.view.addSubview(self.wrapperViewController.view)
        self.wrapperViewController.willMove(toParentViewController: self)
        
        self.wrapperViewController.view.translatesAutoresizingMaskIntoConstraints = false
        
        self.wrapperViewController.view.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 50).isActive = true
        self.wrapperViewController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -50).isActive = true
        self.wrapperViewController.view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.wrapperViewController.view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
    }
    
//    override var shouldAutorotate: Bool {
//        return false
//    }
//
//    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
//        return .portrait
//    }
    
    @IBAction func presentPopover(_ sender: UIButton) {
        self.wrapperViewController.setupPopover(for: self.presentButton)
        
        self.present(self.wrapperViewController.popoverViewController, animated: true, completion: nil)
    }
}

class WrapperController: UIViewController {
    
    let popoverViewController = PopoverLabelViewController()

    convenience init() {
        self.init(nibName: nil, bundle: nil)
        
        self.view.backgroundColor = .blue
    }
    
    func setupPopover(for anchorView: UIView) {
        self.popoverViewController.modalPresentationStyle = .popover
        
        self.popoverViewController.popoverPresentationController?.backgroundColor = .green
        self.popoverViewController.popoverPresentationController?.permittedArrowDirections = .any
        
        self.popoverViewController.popoverPresentationController?.delegate = self
        
        self.popoverViewController.popoverPresentationController?.sourceView = anchorView
        self.popoverViewController.popoverPresentationController?.sourceRect = anchorView.bounds
        
    }
}

extension WrapperController: UIPopoverPresentationControllerDelegate {
    
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
