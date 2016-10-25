//
//  PhotoCollectionViewController.swift
//  PhotoCollection
//
//  Created by Jason Lew on 10/24/16.
//  Copyright © 2016 Jason Lew. All rights reserved.
//

import UIKit

private let reuseIdentifier = "PhotoCell"

class PhotoCollectionViewController: UICollectionViewController {

    var photos: [[Photo]]!
    let places = ["Paris", "Berlin", "Venice"]
    
    override func viewDidLoad() {
        super.viewDidLoad()


        // Do any additional setup after loading the view.
        photos = Array(repeating: [Photo](), count: places.count)
        for (index, place) in places.enumerated() {
            WhereOnEarth.topPlace(querying: place) { (woe) in
                
                Photo.photos(querying: woe.woe_id) { (photos) in
                    DispatchQueue.main.async {
                        print(woe.woe_name)
                        self.photos[index] = photos
                        print(photos)
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
        // #warning Incomplete implementation, return the number of items
        return places.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? PhotoCollectionViewCell else {
            fatalError()
        }
    
        // Configure the cell
    
        return cell
    }

}
