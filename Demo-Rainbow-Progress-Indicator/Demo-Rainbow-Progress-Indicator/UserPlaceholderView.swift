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

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let frameView = UIImageView(image: UIImage(named: "frame"))
        frameView.contentMode = .scaleAspectFill
        
        let headView = UIImageView(image: UIImage(named: "head"))
        headView.contentMode = .scaleAspectFill
  
        addSubview(iconView)
        
        iconView.addSubview(headView)
        iconView.addSubview(frameView)
        
        iconView.translatesAutoresizingMaskIntoConstraints = false
        headView.translatesAutoresizingMaskIntoConstraints = false
        frameView.translatesAutoresizingMaskIntoConstraints = false

        frameView.topAnchor.constraint(equalTo: iconView.topAnchor).isActive = true
        frameView.bottomAnchor.constraint(equalTo: iconView.bottomAnchor).isActive = true
        frameView.leadingAnchor.constraint(equalTo: iconView.leadingAnchor).isActive = true
        frameView.trailingAnchor.constraint(equalTo: iconView.trailingAnchor).isActive = true
        
        headView.centerXAnchor.constraint(equalTo: frameView.centerXAnchor).isActive = true
        headView.bottomAnchor.constraint(equalTo: frameView.bottomAnchor).isActive = true

        iconView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        iconView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func scaleUpAndDisappear(duration: TimeInterval) {
        UIView.animate(withDuration: duration, animations: {
            self.iconView.alpha = 0
        })
    }
}
