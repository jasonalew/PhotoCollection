//
//  PhotoCollectionViewController.swift
//  PhotoCollection
//
//  Created by Jason Lew on 10/24/16.
//  Copyright © 2016 Jason Lew. All rights reserved.
//

import UIKit
import SDWebImage

struct ReuseIdentifier {
    static let main = "PhotoCell"
    static let child = "ChildCell"
}

class PhotoCollectionViewController: UICollectionViewController {

    var photos: [[Photo]]!
    let places = ["Paris", "Venice", "Kyoto", "Los Angeles"]
    var cellSize: CGSize {
        return UIScreen.main.bounds.size
    }
    lazy var activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    
    @IBOutlet var mainCollectionView: UICollectionView!
    @IBOutlet weak var mainFlowLayout: MarginFlowLayout!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Setup a 2D array
        photos = Array(repeating: [Photo](), count: places.count)
        
        // Setup collection view
        mainCollectionView.isPagingEnabled = false
        mainCollectionView.decelerationRate = UIScrollViewDecelerationRateFast
        
        // Setup activity indicator
        activityIndicator.center = view.center
        view.addSubview(activityIndicator)
        activityIndicator.hidesWhenStopped = true
        
        loadPhotos()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    func loadPhotos() {
        activityIndicator.startAnimating()
        // Get the Where on Earth ID from the places array
        for (index, place) in places.enumerated() {
            DispatchQueue.main.async {
                WhereOnEarth.topPlace(querying: place) { (woe) in
                    // Get the photos for the places
                    Photo.photos(querying: woe) { (photos) in
                        DispatchQueue.main.async {
                            self.photos[index] = photos
                            if self.photos.count == self.places.count {
                                // Reload the collection view when the last results is received
                                self.mainCollectionView.reloadData()
                                self.activityIndicator.stopAnimating()
                            }
                        }
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
        
        // If it's the main collection view, just return the subclass cell
        if collectionView == mainCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReuseIdentifier.main, for: indexPath) as? PhotoCollectionViewCell else {
                print("No main cell")
                fatalError()
            }
            return cell
        } else {
            // Set the cells for the child collection views
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReuseIdentifier.child, for: indexPath) as? ChildCollectionViewCell else {
                print("No child cell")
                fatalError()
            }
            let photo = photos[collectionView.tag][indexPath.item]
            cell.imageUrl = photo.imageUrl
            if indexPath.item == 0 {
                cell.titleLabel.text = photo.placeTitle ?? ""
            } else {
                cell.titleLabel.text = ""
            }
            
            cell.childImageView.sd_setImage(with: cell.imageUrl!, completed: { (image, error, cacheType, url) in
                // Fade in the image if it isn't in the cache
                if cacheType == SDImageCacheType.none {
                    cell.childImageView.alpha = 0
                    UIView.animate(withDuration: 0.3, animations: { 
                        cell.childImageView.alpha = 1
                    })
                } else {
                    cell.childImageView.alpha = 1
                }
            })
            return cell
        }
    }
}

extension PhotoCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return cellSize
    }
}
