//
//  Cell.swift
//  Demo-Carousel-Pagination-Collection
//
//  Created by Kristina Gelzinyte on 2/21/20.
//  Copyright © 2020 Kristina Gelzinyte. All rights reserved.
//

import UIKit

class Cell: UICollectionViewCell {
    
    static let identifier = "CellIdentifier"
    static let width: CGFloat = 70
    static let height: CGFloat = 70
    static let featuredWidth: CGFloat = 106
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.cornerRadius = 20
        backgroundColor = UIColor.random
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}

extension UIColor {
    
    static var random: UIColor {
        let hue = CGFloat.random(in: 0...1)
        let saturation = CGFloat.random(in: 0...1)
        let brightness = CGFloat.random(in: 0...1)
        
        return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1)
    }
}
