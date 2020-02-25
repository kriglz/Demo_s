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
        let contentOffset = collectionView!.contentOffset.x + contentInset.left
        return Int(contentOffset / dragOffset)
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
                let delta = max((featuredWidth - standardWidth) * abs(nextItemPercentageOffset), 0)
                width = featuredWidth - delta
                height = featuredHeight - delta

            // Item not featured, but might be featured @right
            } else if indexPath.item == (featuredItemIndex + 1) {
                let delta = max((featuredWidth - standardWidth) * nextItemPercentageOffset, 0)
                width = standardWidth + delta
                height = standardHeight + delta

                // Only for left to right off bounds scroll
                if nextItemPercentageOffset < 0 {
                    let scaleDelta = (featuredWidth - standardWidth) * nextItemPercentageOffset
                    let absScaleDelta = abs(scaleDelta)
                    let scaleRatio = 1 - (absScaleDelta / featuredWidth)
                    let scale =  -Int(100 * scaleRatio)
                    attributes.zIndex = scale
                }

            } else if indexPath.item == (featuredItemIndex + 2) {
                print(featuredItemIndex, nextItemPercentageOffset)
                
                if nextItemPercentageOffset >= 0 {
                    attributes.zIndex = -Int(nextItemPercentageOffset * (100 - Cell.featuredRatio) + Cell.featuredRatio)
               
                } else {
                    attributes.zIndex = -Int(Cell.featuredRatio - Cell.featuredRatio * abs(nextItemPercentageOffset))
                }
                

                

            } else if indexPath.item == (featuredItemIndex + 3), nextItemPercentageOffset > 0 {
                attributes.zIndex = -Int(nextItemPercentageOffset * Cell.featuredRatio)
                
            } else if indexPath.item >= (featuredItemIndex + 3) {
                attributes.zIndex = -1
                
            // Item not featured, but might be featured @left
            } else if indexPath.item == (featuredItemIndex - 1) {
                attributes.zIndex = Int(100 - nextItemPercentageOffset * (100 - Cell.featuredRatio))
                
            } else if indexPath.item == (featuredItemIndex - 2) {
                attributes.zIndex = Int(Cell.featuredRatio - Cell.featuredRatio * nextItemPercentageOffset)
                
            } else if indexPath.item < (featuredItemIndex - 2) {
                attributes.zIndex = 1
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
