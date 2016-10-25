//
//  PhotoCollectionViewCell.swift
//  PhotoCollection
//
//  Created by Jason Lew on 10/24/16.
//  Copyright © 2016 Jason Lew. All rights reserved.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    var imageUrl: URL?
    
    @IBOutlet weak var mainImageView: UIImageView!
    
    override func prepareForReuse() {
        mainImageView.image = nil
        imageUrl = nil
    }
}
