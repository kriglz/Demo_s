//
//  ViewController.swift
//  Demo-Rainbow-Progress-Indicator
//
//  Created by Kristina Gelzinyte on 12/9/19.
//  Copyright © 2019 Kristina Gelzinyte. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let photoView = UIImageView(image: UIImage(named: "photo.jpeg"))
        photoView.contentMode = .scaleAspectFill
        
        let progressIndicator = ProgressIndicatorView()
        
        view.addSubview(photoView)
        view.addSubview(progressIndicator)
        
        photoView.translatesAutoresizingMaskIntoConstraints = false
        progressIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        photoView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        photoView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        photoView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        photoView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        progressIndicator.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        progressIndicator.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        progressIndicator.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        progressIndicator.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        var progress: Float = 0
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            progressIndicator.progress = progress
            progress = progress > 1 ? 0 : progress + 30/360
        }
    }
}

class CondettiView: UIView {
    
    class LineLayer: CAShapeLayer {
        
    }
    
    
}
