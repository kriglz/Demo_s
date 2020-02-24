//
//  CarouselFlowLayout.swift
//  Demo-Carousel-Pagination-Collection
//
//  Created by Kristina Gelzinyte on 2/21/20.
//  Copyright © 2020 Kristina Gelzinyte. All rights reserved.
//

import UIKit

class CarouselFlowLayout: UICollectionViewLayout {
    
    // MARK: - Public properties

    var contentInset: UIEdgeInsets = .zero
    
    // MARK: - Private properties
    
    let dragOffset: CGFloat = Cell.width
    
    var cache: [UICollectionViewLayoutAttributes] = []
    
    var featuredItemIndex: Int {
        // Use max to make sure the featureItemIndex is never < 0
        return max(0, Int((collectionView!.contentOffset.x + contentInset.left) / dragOffset))
    }
    
    var nextItemPercentageOffset: CGFloat {
        return ((collectionView!.contentOffset.x + contentInset.left) / dragOffset) - CGFloat(featuredItemIndex)
    }
    
    var width: CGFloat {
        return collectionView!.bounds.width
    }
    
    var height: CGFloat {
        return collectionView!.bounds.height
    }
    
    var numberOfItems: Int {
        return collectionView!.numberOfItems(inSection: 0)
    }
    
    override var collectionViewContentSize: CGSize {
        let contentWidth = CGFloat(numberOfItems - 1) * Cell.width + Cell.featuredWidth
        return CGSize(width: contentWidth, height: height)
    }
    
    override func prepare() {
        cache.removeAll(keepingCapacity: false)
        
        let standardWidth = Cell.width
        let featuredWidth = Cell.featuredWidth
        
        let standardHeight = Cell.height
        let featuredHeight = self.height
        
        var frame = CGRect.zero
        var x: CGFloat = 0
        
        for item in 0..<numberOfItems {
            let indexPath = IndexPath(item: item, section: 0)
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            
            // Initially set the height of the cell to the standard height
            var width = standardWidth
            var height = standardHeight

            attributes.zIndex = 100
            
            // Current featured, about to be not featured
            if indexPath.item == featuredItemIndex {
                width = featuredWidth - max((featuredWidth - standardWidth) * nextItemPercentageOffset, 0)
                height = featuredHeight - max((featuredHeight - standardHeight) * nextItemPercentageOffset, 0)
                
            // Item not featured, but about to be featured
            } else if indexPath.item == (featuredItemIndex + 1) {
                width = standardWidth + max((featuredWidth - standardWidth) * nextItemPercentageOffset, 0)
                height = standardHeight + max((featuredHeight - standardHeight) * nextItemPercentageOffset, 0)
            
            } else if indexPath.item == (featuredItemIndex + 2) {
                attributes.zIndex = Int(nextItemPercentageOffset * 30 + 70)
              
            } else if indexPath.item == (featuredItemIndex + 3) {
                attributes.zIndex = Int(nextItemPercentageOffset * 70)
                
            } else if indexPath.item > (featuredItemIndex + 3) {
                attributes.zIndex = 0
                
            } else if indexPath.item == (featuredItemIndex - 1) {
                attributes.zIndex = Int(100 - nextItemPercentageOffset * 30)
                
            } else if indexPath.item == (featuredItemIndex - 2) {
                attributes.zIndex = Int(70 - 100 * nextItemPercentageOffset)
                
            } else if indexPath.item < (featuredItemIndex - 2) {
                attributes.zIndex = 0
                
            }
            
            let y: CGFloat = (self.height - height) * 0.5

            frame = CGRect(x: x, y: y, width: width, height: height)
            attributes.frame = frame
            cache.append(attributes)
    
            x = frame.maxX
        }
    }
    
    // Return all attributes in the cache whose frame intersects with the rect passed to the method
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var layoutAttributes: [UICollectionViewLayoutAttributes] = []
        for attributes in cache {
            if attributes.frame.intersects(rect) {
                layoutAttributes.append(attributes)
            }
        }
        return layoutAttributes
    }
    
    // Return the content offset of the nearest cell which achieves the nice snapping effect, similar to a paged UIScrollView
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        let itemIndex = round((proposedContentOffset.x + contentInset.left) / dragOffset)
        let xOffset = itemIndex * Cell.width - contentInset.left
        return CGPoint(x: xOffset, y: 0)
    }
    
    // Return true so that the layout is continuously invalidated as the user scrolls
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
}
