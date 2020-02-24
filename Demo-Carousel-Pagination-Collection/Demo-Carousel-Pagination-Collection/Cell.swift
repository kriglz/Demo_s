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
    
    private let colorView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        colorView.layer.cornerRadius = 20
        colorView.backgroundColor = UIColor.random
        
        addSubview(colorView)
        
        colorView.translatesAutoresizingMaskIntoConstraints = false
        
        colorView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        colorView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        colorView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        colorView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        
        let constant = max(0, min(1, alpha))
        colorView.transform = CGAffineTransform.identity.concatenating(CGAffineTransform(scaleX: constant, y: constant))

        print(constant)
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
