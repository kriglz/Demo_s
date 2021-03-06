//
//  ViewController.swift
//  Demo-Carousel-Pagination-Collection
//
//  Created by Kristina Gelzinyte on 2/21/20.
//  Copyright © 2020 Kristina Gelzinyte. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    private let itemsCount = 12

    private lazy var collectionView: UICollectionView = {
        let collectionViewLayout = CarouselFlowLayout()

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .white
        collectionView.register(Cell.self, forCellWithReuseIdentifier: Cell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.contentInsetAdjustmentBehavior = .never
        
        let inset = (view.bounds.width - Cell.featuredWidth) / 2
        collectionView.contentInset = UIEdgeInsets(top: 0, left: inset, bottom: 0, right: inset)
        collectionViewLayout.contentInset = UIEdgeInsets(top: 0, left: inset, bottom: 0, right: inset)
        
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        view.backgroundColor = .random
        
//        let guideLineView = UIView()
//        guideLineView.backgroundColor = .red
        
//        view.addSubview(guideLineView)
        view.addSubview(collectionView)
        
//        guideLineView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
//        guideLineView.widthAnchor.constraint(equalToConstant: 1).isActive = true
//        guideLineView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//        guideLineView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
//        guideLineView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collectionView.heightAnchor.constraint(equalToConstant: Cell.featuredWidth).isActive = true
        collectionView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let offset = CGPoint(x: Cell.featuredWidth / 2, y: 0)
        collectionView.setContentOffset(offset, animated: true)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemsCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: Cell.identifier, for: indexPath)
    }
}
