//
//  DetailAlbumViewController.swift
//  MyAlbum
//
//  Created by 박수현 on 18/04/2018.
//  Copyright © 2018 박수현. All rights reserved.
//

import UIKit
import Photos

class GridViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    // MARK: Properties
    var allPhotos: PHFetchResult<PHAsset>!
    var smartAlbums: PHFetchResult<PHAssetCollection>!
    var userCollections: PHFetchResult<PHCollection>!
    var fetchResult: PHFetchResult<PHAsset>!
    var assetCollection: PHAssetCollection!
    let imageManager: PHCachingImageManager = PHCachingImageManager()

    var imageArray = [UIImage]()
    var albumTitle: String = ""
    var reuseIdentifier: String = "GridViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = albumTitle
//        requestCollection()
        
        // Create a PHFetchResult object for each section in the table view.
//        let allPhotosOptions = PHFetchOptions()
//        allPhotosOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
//        allPhotos = PHAsset.fetchAssets(with: allPhotosOptions)
//        smartAlbums = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .albumRegular, options: nil)
//        userCollections = PHCollectionList.fetchTopLevelUserCollections(with: nil)
//        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //let asset = fetchResult.object(at: indexPath.item)
        guard let cell: GridViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? GridViewCell else { fatalError("unexpected cell in collection view") }
        

        return cell
    }


}
