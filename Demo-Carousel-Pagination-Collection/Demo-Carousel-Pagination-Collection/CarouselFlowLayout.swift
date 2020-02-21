//
//  CarouselFlowLayout.swift
//  Demo-Carousel-Pagination-Collection
//
//  Created by Kristina Gelzinyte on 2/21/20.
//  Copyright © 2020 Kristina Gelzinyte. All rights reserved.
//

import UIKit

class CarouselFlowLayout: UICollectionViewLayout {
    
    let dragOffset: CGFloat = 100.0
    
    var cache: [UICollectionViewLayoutAttributes] = []
    
    var featuredItemIndex: Int {
        // Use max to make sure the featureItemIndex is never < 0
        return max(0, Int(collectionView!.contentOffset.x / dragOffset))
    }
    
    var nextItemPercentageOffset: CGFloat {
        return (collectionView!.contentOffset.x / dragOffset) - CGFloat(featuredItemIndex)
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
        let contentWidth = (CGFloat(numberOfItems) * dragOffset) + (width - dragOffset)
        return CGSize(width: contentWidth, height: height)
    }
    
    override func prepare() {
        cache.removeAll(keepingCapacity: false)
        
        let standardWidth = Cell.width
        let featuredWidth = Cell.featuredWidth
        
        var frame = CGRect.zero
        var x: CGFloat = 0
        
        for item in 0..<numberOfItems {
            let indexPath = IndexPath(item: item, section: 0)
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            
            // Important because each cell has to slide over the top of the previous one
            attributes.zIndex = item
            
            // Initially set the height of the cell to the standard height
            var width = standardWidth
            if indexPath.item == featuredItemIndex {
                // The featured cell
                let xOffset = standardWidth * nextItemPercentageOffset
                x = collectionView!.contentOffset.x - xOffset
                width = featuredWidth
            } else if indexPath.item == (featuredItemIndex + 1) && indexPath.item != numberOfItems {
                // The cell directly below the featured cell, which grows as the user scrolls
                let maxX = x + standardWidth
                width = standardWidth + max((featuredWidth - standardWidth) * nextItemPercentageOffset, 0)
                x = maxX - width
            }
            
            frame = CGRect(x: x, y: 0, width: width, height: height)
            
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
        let itemIndex = round(proposedContentOffset.x / dragOffset)
        let xOffset = itemIndex * dragOffset
        return CGPoint(x: xOffset, y: 0)
    }
    
    // Return true so that the layout is continuously invalidated as the user scrolls
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
}
