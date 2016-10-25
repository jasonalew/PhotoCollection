//
//  MarginFlowLayout.swift
//  PhotoCollection
//
//  Created by Jason Lew on 10/25/16.
//  Copyright © 2016 Jason Lew. All rights reserved.
//

import UIKit

class MarginFlowLayout: UICollectionViewFlowLayout {
    override func awakeFromNib() {
        itemSize = UIScreen.main.bounds.size
        minimumInteritemSpacing = 10
        minimumLineSpacing = 10
        scrollDirection = .horizontal
        sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        var offsetAdjustment = CGFloat(MAXFLOAT)
        let horizontalOffset = proposedContentOffset.x
        let targetRect = CGRect(x: proposedContentOffset.x, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        let attributes = self.layoutAttributesForElements(in: targetRect)
        for attribute in attributes! {
            let itemOffset = attribute.frame.origin.x
            if abs(itemOffset - horizontalOffset) < abs(offsetAdjustment) {
                offsetAdjustment = itemOffset - horizontalOffset
            }
        }

        return CGPoint(x: proposedContentOffset.x + offsetAdjustment, y: proposedContentOffset.y)
    }
}
