//
//  UserPlaceholderView.swift
//  Demo-Rainbow-Progress-Indicator
//
//  Created by Kristina Gelzinyte on 12/10/19.
//  Copyright © 2019 Kristina Gelzinyte. All rights reserved.
//

import UIKit

class UserPlaceholderView: UIView {
    
    private let iconView = UIView()
    private let backgroundView = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let frameView = UIImageView(image: UIImage(named: "frame"))
        frameView.contentMode = .scaleAspectFill
        
        let headView = UIImageView(image: UIImage(named: "head"))
        headView.contentMode = .scaleAspectFill

        backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        backgroundView.layer.masksToBounds = true
        backgroundView.clipsToBounds = true
        
        addSubview(iconView)
        
        iconView.addSubview(backgroundView)
        iconView.addSubview(headView)
        iconView.addSubview(frameView)
        
        iconView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        headView.translatesAutoresizingMaskIntoConstraints = false
        frameView.translatesAutoresizingMaskIntoConstraints = false

        frameView.topAnchor.constraint(equalTo: iconView.topAnchor).isActive = true
        frameView.bottomAnchor.constraint(equalTo: iconView.bottomAnchor).isActive = true
        frameView.leadingAnchor.constraint(equalTo: iconView.leadingAnchor).isActive = true
        frameView.trailingAnchor.constraint(equalTo: iconView.trailingAnchor).isActive = true
        
        backgroundView.topAnchor.constraint(equalTo: iconView.topAnchor).isActive = true
        backgroundView.bottomAnchor.constraint(equalTo: iconView.bottomAnchor).isActive = true
        backgroundView.leadingAnchor.constraint(equalTo: iconView.leadingAnchor).isActive = true
        backgroundView.trailingAnchor.constraint(equalTo: iconView.trailingAnchor).isActive = true
        
        headView.centerXAnchor.constraint(equalTo: frameView.centerXAnchor).isActive = true
        headView.bottomAnchor.constraint(equalTo: frameView.bottomAnchor).isActive = true

        iconView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        iconView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        backgroundView.layer.cornerRadius = iconView.bounds.width * 0.5
    }
    
    func scaleUpAndDisappear() {
        UIView.animateKeyframes(withDuration: 0.15, delay: 0, options: .beginFromCurrentState, animations: {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.1, animations: {
                self.backgroundView.backgroundColor = .clear
            })
            
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1, animations: {
                self.iconView.transform = CGAffineTransform(scaleX: 3, y: 3)
            })
            
            UIView.addKeyframe(withRelativeStartTime: 0.9, relativeDuration: 0.1, animations: {
                self.iconView.alpha = 0
            })
        }, completion: nil)
    }
}
