//
//  ChildCollectionViewCell.swift
//  PhotoCollection
//
//  Created by Jason Lew on 10/25/16.
//  Copyright © 2016 Jason Lew. All rights reserved.
//

import UIKit

class ChildCollectionViewCell: UICollectionViewCell {
    var imageUrl: URL?
    
    @IBOutlet weak var childImageView: UIImageView!
    
    override func prepareForReuse() {
        imageUrl = nil
        childImageView.image = nil
    }
}
