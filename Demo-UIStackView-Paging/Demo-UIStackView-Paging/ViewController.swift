//
//  ViewController.swift
//  Demo-UIStackView-Paging
//
//  Created by Kristina Gelzinyte on 4/9/19.
//  Copyright © 2019 Kristina Gelzinyte. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let contenView = HorizontallyScrollableStackView()
    let inset: CGFloat = 20
    let itemWidth: CGFloat = 248
    var spacing: CGFloat {
        return 0.5 * self.inset
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let controlLine = UIView()
        controlLine.backgroundColor = .green
        
        self.contenView.stackView.spacing = self.spacing
        self.contenView.stackView.axis = .horizontal
        self.contenView.stackView.alignment = .leading
        self.contenView.stackView.distribution = .fillEqually
        
        self.contenView.scrollView.contentInset = UIEdgeInsets(top: 0, left: self.inset, bottom: 0, right: self.inset)
        
        self.view.addSubview(controlLine)
        self.view.addSubview(self.contenView)
        
        controlLine.translatesAutoresizingMaskIntoConstraints = false
        self.contenView.translatesAutoresizingMaskIntoConstraints = false
        
        self.contenView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.contenView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true

        self.contenView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        
        controlLine.widthAnchor.constraint(equalToConstant: 1).isActive = true
        
        controlLine.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        controlLine.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        controlLine.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: self.inset).isActive = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let width = self.itemWidth * 3 + self.spacing + self.contenView.bounds.width - self.inset
        let height = self.contenView.scrollView.contentSize.height
        self.contenView.scrollView.contentSize = CGSize(width: width, height: height)
    }

    func reloadData() {
        self.contenView.stackView.removeAllArrangedSubviews()
        
        for index in 0...7 {
            let item = ItemView(id: index)
            
            self.contenView.addArrangedSubview(item)

            item.translatesAutoresizingMaskIntoConstraints = false
            item.widthAnchor.constraint(equalToConstant: self.itemWidth).isActive = true
            item.heightAnchor.constraint(equalTo: item.widthAnchor, multiplier: 1.62).isActive = true
            
            if index == 3 {
                self.contenView.stackView.setCustomSpacing(self.inset, after: item)
            }
        }
    }
}

