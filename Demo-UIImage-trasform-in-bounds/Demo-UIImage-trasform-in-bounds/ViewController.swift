//
//  ViewController.swift
//  Demo-UIImage-trasform-in-bounds
//
//  Created by Kristina Gelzinyte on 8/20/19.
//  Copyright © 2019 Kristina Gelzinyte. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    private let cat = UIImage(named: "cat.jpeg")!
    private let flowers = UIImage(named: "flowers.jpeg")!
    
    private var activeImage: UIImage {
        switch Int.random(in: 0...1) {
        case 0:
            return cat
        default:
            return flowers
        }
    }
    
    private let imageView = TransformableImageView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .black
        
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 150
        
        self.view.addSubview(imageView)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        imageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true

        imageView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 300).isActive = true
        
        imageView.image = activeImage
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(switchImage(_:)))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func switchImage(_ sender: Any) {
        imageView.image = activeImage
    }
}

class TransformableImageView: UIView, UIScrollViewDelegate {
    
    var image: UIImage? {
        didSet {
            imageView.image = self.image
            updateImageLayout()
        }
    }
    
    private let scrollView = UIScrollView()
    private let imageView = UIImageView()
    
    private var activeConstraints: [NSLayoutConstraint] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .white
        
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.alwaysBounceHorizontal = true
        scrollView.alwaysBounceVertical = true
        scrollView.minimumZoomScale = 1
        scrollView.maximumZoomScale = 20.0
        scrollView.delegate = self

        imageView.contentMode = .scaleAspectFill
        
        self.addSubview(scrollView)
        scrollView.addSubview(imageView)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false

        scrollView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func updateImageLayout() {
        NSLayoutConstraint.deactivate(activeConstraints)
        activeConstraints.removeAll()
        
        let offsetMultiplier: CGFloat
        
        let aspectRation = imageView.image!.size.width / imageView.image!.size.height
        if aspectRation > 1 {
            activeConstraints.append(imageView.heightAnchor.constraint(equalTo: scrollView.heightAnchor))
            activeConstraints.append(imageView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: aspectRation))
            offsetMultiplier = 0.5 * (1 - aspectRation)
            
        } else {
            activeConstraints.append(imageView.heightAnchor.constraint(equalTo: scrollView.heightAnchor, multiplier: 1 / aspectRation))
            activeConstraints.append(imageView.widthAnchor.constraint(equalTo: scrollView.widthAnchor))
            offsetMultiplier = 0.5 * (1 - 1 / aspectRation)
        }
        
        NSLayoutConstraint.activate(activeConstraints)
        
        layoutIfNeeded()
        
        scrollView.contentSize = imageView.bounds.size
        scrollView.zoomScale = 1

        let offsetX = (aspectRation > 1 ? -scrollView.bounds.width : 0) * offsetMultiplier
        let offsetY =  (aspectRation < 1 ? -scrollView.bounds.height : 0) * offsetMultiplier
        scrollView.contentOffset = CGPoint(x: offsetX, y: offsetY)
    }
    
    // MARK: - UIScrollViewDelegate
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
