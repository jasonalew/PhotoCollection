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
    @IBOutlet weak var childCollectionView: UICollectionView!
    
    // The D type conforms to UICollectionView Delegate and DataSource protocols
    func setCollectionViewDataSourceDelegate<D: UICollectionViewDataSource & UICollectionViewDelegate>(delegate: D, forItem item: Int) {
        childCollectionView.delegate = delegate
        childCollectionView.dataSource = delegate
        childCollectionView.tag = item
        childCollectionView.reloadData()
    }
    
    override func prepareForReuse() {
        mainImageView.image = nil
        imageUrl = nil
    }
}


