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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.contenView.stackView.spacing = self.inset * 0.5
        self.contenView.stackView.axis = .horizontal
        self.contenView.stackView.alignment = .leading
        self.contenView.stackView.distribution = .fillEqually
        
        self.contenView.scrollView.contentInset = UIEdgeInsets(top: 0, left: self.inset, bottom: 0, right: self.inset)
        
        self.view.addSubview(self.contenView)
        
        self.contenView.translatesAutoresizingMaskIntoConstraints = false
        
        self.contenView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.contenView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true

        self.contenView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.contenView.scrollView.contentSize = CGSize(width: self.contenView.scrollView.contentSize.width / 2, height: self.contenView.scrollView.contentSize.height)
    }

    func reloadData() {
        self.contenView.stackView.removeAllArrangedSubviews()
        
        for index in 0...7 {
            let item = ItemView(id: index)
            
            self.contenView.addArrangedSubview(item)

            item.translatesAutoresizingMaskIntoConstraints = false
            item.heightAnchor.constraint(equalToConstant: 400).isActive = true
            item.widthAnchor.constraint(equalTo: item.heightAnchor, multiplier: 0.62).isActive = true
            
            if index == 3 {
                self.contenView.stackView.setCustomSpacing(self.inset, after: item)
            }
        }
    }
}

