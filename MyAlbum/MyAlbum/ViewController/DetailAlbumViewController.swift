//
//  DetailAlbumViewController.swift
//  MyAlbum
//
//  Created by 박수현 on 18/04/2018.
//  Copyright © 2018 박수현. All rights reserved.
//

import UIKit
import Photos

class DetailAlbumViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    var fetchResult: PHFetchResult<PHAsset>!
    var imageManager: PHCachingImageManager = PHCachingImageManager()
    var imageArray = [UIImage]()
    var albumLabel: String = ""
    var reuseIdentifier: String = "DetailCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = albumLabel
        //requestCollection()
        
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell: DetailPhotoCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? DetailPhotoCollectionViewCell else { fatalError("Wrong cell") }
        
        //cell.imageView.image = imageArray[indexPath.item]
        cell.backgroundColor = UIColor.blue
        return cell
    }
    
//    func requestCollection() {
//        let fetchOptions = PHFetchOptions()
//        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
//
//        switch albumLabel {
//        case "Camera Roll":
//            let cameraRoll: PHFetchResult<PHAssetCollection> = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumUserLibrary, options: nil)
//            guard let cameraRollCollection = cameraRoll.firstObject else {
//                return
//            }
//            self.fetchResult = PHAsset.fetchAssets(in: cameraRollCollection, options: fetchOptions)
//            for i in 0..<self.fetchResult.count {
//                imageManager.requestImage(for: fetchResult.object(at: i),
//                                      targetSize: CGSize(width: 118, height: 118),
//                                      contentMode: .aspectFit,
//                                      options: nil,
//                                      resultHandler: { image, _ in
//                                        self.imageArray.append(image!)
//                })
//            }
//
//        default:
//            ()
//        }
//    }

}
