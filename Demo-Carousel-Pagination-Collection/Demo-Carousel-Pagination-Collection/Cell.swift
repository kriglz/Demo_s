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
    static let featuredRatio: CGFloat = 70 * 100 / 106

    private let emojiView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        let images = animationImages(named: "1_Grinning Face", range: 0...18, format:  "%02d")
        emojiView.image = images.first
        emojiView.animationImages = images
        emojiView.animationDuration = Double(images.count) * 0.07
        emojiView.contentMode = .scaleAspectFit
        
        addSubview(emojiView)
        
        emojiView.translatesAutoresizingMaskIntoConstraints = false
        
        let constant: CGFloat = 10
        emojiView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: -constant).isActive = true
        emojiView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: constant).isActive = true
        emojiView.topAnchor.constraint(equalTo: topAnchor, constant: -constant).isActive = true
        emojiView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: constant).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        
        let distanceToNeighborRatio = CGFloat(layoutAttributes.zIndex) / 100
        
        let scale = max(0, min(1, abs(distanceToNeighborRatio)))
        let scaleTransform = CGAffineTransform.identity.concatenating(CGAffineTransform(scaleX: scale, y: scale))
        
//        print(distanceToNeighborRatio, scale)

//        let translation = abs(layoutAttributes.zIndex) < 100 ? CGFloat(layoutAttributes.zIndex.signum()) * (100 - CGFloat(abs(layoutAttributes.zIndex))) * layoutAttributes.size.width * 1 / 100 : 0
//        let translationTransform = CGAffineTransform.identity.concatenating(CGAffineTransform(translationX: translation, y: 0))
        
//        print(layoutAttributes.zIndex, translation)
        
        emojiView.transform = scaleTransform // translationTransform.concatenating(scaleTransform)
        
        if abs(layoutAttributes.zIndex) == 100, layoutAttributes.size.width == Cell.featuredWidth {
            emojiView.startAnimating()
        } else {
            emojiView.stopAnimating()
        }
    }
    
    private func animationImages(named: String, range: ClosedRange<Int>, format: String) -> [UIImage] {
        var images = [UIImage]()
        range.forEach {
            if let image = UIImage(named: named + String(format: format, $0)) {
                images.append(image)
            }
        }
        
        return images
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
