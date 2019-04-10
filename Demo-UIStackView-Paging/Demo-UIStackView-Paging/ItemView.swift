//
//  ItemView.swift
//  Demo-UIStackView-Paging
//
//  Created by Kristina Gelzinyte on 4/9/19.
//  Copyright © 2019 Kristina Gelzinyte. All rights reserved.
//

import UIKit

class ItemView: UIView {
    
    private var id = 0
    
    convenience init(id: Int) {
        self.init(frame: .zero)
        
        self.id = id
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.random
        self.layer.cornerRadius = 20
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension UIColor {
    
    static var random: UIColor {
        let hue = CGFloat.random(in: 0...1)
        let saturation = CGFloat.random(in: 0.5...1)
        let brightness = CGFloat.random(in: 0.5...1)
        
        return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1)
    }
}
