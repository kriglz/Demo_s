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
    var itemWidth: CGFloat {
        return self.view.bounds.width / 2
    }
    var spacing: CGFloat {
        return 0.5 * self.inset
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let controlLine = UIView()
        controlLine.backgroundColor = .green
        
        self.contenView.scrollView.delegate = self
        self.contenView.scrollView.decelerationRate = .fast
        
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
        
        self.updateContentSize()
    }
    
    override func viewDidLayoutSubviews() {
        self.updateContentSize()
    }
    
    func updateContentSize() {
        let width = self.itemWidth * 3 + self.spacing + self.contenView.bounds.width - self.inset
        let height = self.contenView.scrollView.contentSize.height
        
        print(CGSize(width: width, height: height))
        
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

extension ViewController: UIScrollViewDelegate {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let proposedContentOffset = targetContentOffset.pointee
        
        // Translate those cell layoutAttributes into potential (candidate) scrollView offsets
        let candidateOffsets: [CGFloat]? =  self.contenView.stackView.arrangedSubviews.map { view in
            let contentInset = self.contenView.scrollView.contentInset
            
            if #available(iOS 11.0, *) {
                return view.frame.origin.x - contentInset.left - self.contenView.scrollView.safeAreaInsets.left
            } else {
                return view.frame.origin.x - contentInset.left
            }
        }
        
        let bestCandidateOffset: CGFloat
        
        if velocity.x > 0 {
            // If the scroll velocity was POSITIVE, then only consider cells/offsets to the RIGHT of the proposedContentOffset.x
            let candidateOffsetsToRight = candidateOffsets?.toRight(ofProposedOffset: proposedContentOffset.x)
            let nearestCandidateOffsetToRight = candidateOffsetsToRight?.nearest(toProposedOffset: proposedContentOffset.x)
            bestCandidateOffset = nearestCandidateOffsetToRight ?? candidateOffsets?.last ?? proposedContentOffset.x
        } else if velocity.x < 0 {
            // If the scroll velocity was NEGATIVE, then only consider cells/offsets to the LEFT of the proposedContentOffset.x
            let candidateOffsetsToLeft = candidateOffsets?.toLeft(ofProposedOffset: proposedContentOffset.x)
            let nearestCandidateOffsetToLeft = candidateOffsetsToLeft?.nearest(toProposedOffset: proposedContentOffset.x)
            bestCandidateOffset = nearestCandidateOffsetToLeft ?? candidateOffsets?.first ?? proposedContentOffset.x
        } else {
            // If the scroll velocity was ZERO we consider all `candidate` cells (regarless of whether they are to the left OR right of the proposedContentOffset.x)
            // The cell/offset that is the NEAREST is the `bestCandidate`
            let nearestCandidateOffset = candidateOffsets?.nearest(toProposedOffset: proposedContentOffset.x)
            bestCandidateOffset = nearestCandidateOffset ?? proposedContentOffset.x
        }
        
        targetContentOffset.pointee = CGPoint(x: bestCandidateOffset, y: proposedContentOffset.y)
    }
}

fileprivate extension Sequence where Iterator.Element == CGFloat {
    
    func toLeft(ofProposedOffset proposedOffset: CGFloat) -> [CGFloat] {
        return filter { candidateOffset in
            return candidateOffset < proposedOffset
        }
    }
    
    func toRight(ofProposedOffset proposedOffset: CGFloat) -> [CGFloat] {
        return filter { candidateOffset in
            return candidateOffset > proposedOffset
        }
    }
    
    func nearest(toProposedOffset proposedOffset: CGFloat) -> CGFloat? {
        guard let firstCandidateOffset = first(where: { _ in true }) else {
            return nil
        }
        
        return reduce(firstCandidateOffset) { (bestCandidateOffset: CGFloat, candidateOffset: CGFloat) -> CGFloat in
            let candidateOffsetDistanceFromProposed = abs(candidateOffset - proposedOffset)
            let bestCandidateOffsetDistancFromProposed = abs(bestCandidateOffset - proposedOffset)
            
            if candidateOffsetDistanceFromProposed < bestCandidateOffsetDistancFromProposed {
                return candidateOffset
            }
            
            return bestCandidateOffset
        }
    }
}
