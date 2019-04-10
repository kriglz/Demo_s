//
//  ScrollableStackView.swift
//  Demo-UIStackView-Paging
//
//  Created by Kristina Gelzinyte on 4/9/19.
//  Copyright © 2019 Kristina Gelzinyte. All rights reserved.
//

import Foundation
import UIKit

class BaseScrollableStackView: UIView {
    var arrangedSubviews: [UIView] {
        return self.stackView.arrangedSubviews
    }
    
    let stackView: UIStackView
    let scrollView: UIScrollView
    
    let centerStackView: Bool
    
    init(centerStackView: Bool = false) {
        self.centerStackView = centerStackView
        
        self.scrollView = UIScrollView()
        self.stackView = UIStackView()
        
        super.init(frame: .zero)
        
        self.scrollView.backgroundColor = .clear
        self.backgroundColor = .clear
        
        self.addSubview(self.scrollView)
        self.scrollView.addSubview(self.stackView)
        
        self.scrollView.translatesAutoresizingMaskIntoConstraints = false
        self.stackView.translatesAutoresizingMaskIntoConstraints = false
        
        self.makeConstraints()
        self.makeScrollSettings()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addArrangedSubview(_ view: UIView) {
        self.stackView.addArrangedSubview(view)
    }
    
    func removeArrangedSubview(_ view: UIView) {
        self.stackView.removeViewIfNeeded(view)
    }
    
    func removeAllArrangedSubviews() {
        self.stackView.removeAllArrangedSubviews()
    }
    
    func scroll(to view: UIView, animated: Bool = false) {
        if self.stackView.arrangedSubviews.contains(view) == false {
            return
        }
        
        var offsetX = view.frame.minX - (view.frame.width / 2)
        
        if offsetX + self.scrollView.frame.width > self.scrollView.contentSize.width {
            offsetX = self.scrollView.contentSize.width - self.scrollView.frame.width
        }
        
        if offsetX > 0 {
            self.scrollView.setContentOffset(CGPoint(x: offsetX, y: self.scrollView.contentOffset.y), animated: animated)
        }
    }
    
    func makeConstraints() {
        fatalError("Must be overriden")
    }
    
    func makeScrollSettings() {
        fatalError("Must be overriden")
    }
}

class HorizontallyScrollableStackView: BaseScrollableStackView {
    override func makeConstraints() {
        self.scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        self.scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        self.scrollView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        self.stackView.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor).isActive = true
        self.stackView.trailingAnchor.constraint(equalTo: self.scrollView.trailingAnchor).isActive = true
        self.stackView.topAnchor.constraint(equalTo: self.scrollView.topAnchor).isActive = true
        self.stackView.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor).isActive = true
        
        self.stackView.widthAnchor.constraint(greaterThanOrEqualTo: self.scrollView.widthAnchor).isActive = true
        self.stackView.heightAnchor.constraint(equalTo: self.scrollView.heightAnchor).isActive = true
    }
    
    override func makeScrollSettings() {
        self.scrollView.showsHorizontalScrollIndicator = false
        self.scrollView.alwaysBounceHorizontal = true
        self.scrollView.backgroundColor = .clear
        
        self.stackView.axis = .horizontal
    }
}

extension UIStackView {
    func removeAllArrangedSubviews() {
        self.arrangedSubviews.forEach {
            self.removeViewIfNeeded($0)
        }
    }
    
    func removeViewIfNeeded(_ view: UIView) {
        if view.superview != nil {
            self.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
    }
}
