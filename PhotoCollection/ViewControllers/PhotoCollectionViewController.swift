//
//  PhotoCollectionViewController.swift
//  PhotoCollection
//
//  Created by Jason Lew on 10/24/16.
//  Copyright © 2016 Jason Lew. All rights reserved.
//

import UIKit

struct ReuseIdentifier {
    static let main = "PhotoCell"
    static let child = "ChildCell"
}

class PhotoCollectionViewController: UICollectionViewController {

    var photos: [[Photo]]!
    let places = ["Paris", "Berlin", "Venice"]
    
    @IBOutlet var mainCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Setup a 2D array
        photos = Array(repeating: [Photo](), count: places.count)
        // Get the Where on Earth ID from the places array
        for (index, place) in places.enumerated() {
            WhereOnEarth.topPlace(querying: place) { (woe) in
                // Get the photos for the places
                Photo.photos(querying: woe.woe_id) { (photos) in
                    DispatchQueue.main.async {
                        self.photos[index] = photos
                    }
                }
            }
        }
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == mainCollectionView {
            return photos.count
        } else {
            return photos[collectionView.tag].count
        }
    }
    
    // Set the DataSource, Delegate and Tag of the collection view inside the cell.
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let photoCell = cell as? PhotoCollectionViewCell else {
            return
        }
        photoCell.setCollectionViewDataSourceDelegate(delegate: self, forItem: indexPath.item)
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReuseIdentifier.main, for: indexPath) as? PhotoCollectionViewCell {
            
            return cell
        } else if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReuseIdentifier.child, for: indexPath) as? ChildCollectionViewCell {
            cell.imageUrl = photos[collectionView.tag][indexPath.item].imageUrl
            
            return cell
        } else {
            fatalError()
        }
    }
}
