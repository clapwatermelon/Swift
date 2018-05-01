//
//  GroupAlbumViewController.swift
//  MyAlbum
//
//  Created by 박수현 on 16/04/2018.
//  Copyright © 2018 박수현. All rights reserved.
//

import UIKit
import Photos

class TumbnailViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    enum Albums: Int {
        case allPhotos = 0
        case smartAlbums
        case userCollections
        
        static let count = allPhotos.rawValue + smartAlbums.rawValue + userCollections.rawValue
    }
    
    enum CellIdentifier: String {
        case allPhotos, collection
    }
    
    var allPhotos: PHFetchResult<PHAsset>!
    var smartAlbums: PHFetchResult<PHAssetCollection>!
    var userCollections: PHFetchResult<PHCollection>!
    var fetchResult: PHFetchResult<PHAsset>!
    var assetCollection: PHAssetCollection!
    let imageManager: PHCachingImageManager = PHCachingImageManager()
//    var thumbnailSize: CGSize!
  
    var reuseIdentifier: String = "ThumbnailCell"
    var albumLabel: [String] = []
    var photoCount: [Int] = []
    var imageArray = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        photoAuthorization()
        
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       // return self.imageArray.count
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell: ThumbnailCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? ThumbnailCollectionViewCell else { fatalError("unexpected cell in collection view") }
        let asset = fetchResult.object(at: indexPath.item)
     
    
        // Request an image for the asset from the PHCachingImageManager.
        //cell.representedAssetIdentifier = asset.localIdentifier
        imageManager.requestImage(for: asset, targetSize: CGSize(width: 170, height: 170), contentMode: .aspectFill, options: nil, resultHandler: { image, _ in
            // The cell may have been recycled by the time this handler gets called;
            // set the cell's thumbnail image only if it's still showing the same asset.
            //if cell.representedAssetIdentifier == asset.localIdentifier {
                cell.thumbnailImage = image
            //}
        })
   
        return cell
//        cell.groupLabel.text = albumLabel[indexPath.item]
//        cell.photoCount.text = String(photoCount[indexPath.item])
        //cell.imageView.image = imageArray[indexPath.item]

    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let detailVC = DetailAlbumViewController()
//        detailVC.albumTitle = self.albumLabel[indexPath.item]
//        print(detailVC.albumTitle)
//        self.navigationController?.pushViewController(detailVC, animated: true)

        let nextVC =  UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailAlbumViewController") as! GridViewController
        nextVC.albumTitle = self.albumLabel[indexPath.item]
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    func photoAuthorization() {
        let photoAurthorizationStatus = PHPhotoLibrary.authorizationStatus()
        
        switch photoAurthorizationStatus {
        case .authorized:
            print("접근 허가됨")
            self.requestCollection()
        case .denied:
            print("접근 불허")
        case .notDetermined:
            print("아직 응답하지 않음")
            PHPhotoLibrary.requestAuthorization({ (status) in
                switch status {
                case .authorized:
                    print("사용자가 허용함")
                    //self.requestCollection()
                case .denied:
                    print("사용자가 불허함")
                default: break
                }
            })
        case .restricted:
            print("접근 제한")
        }
    }
    
    func requestCollection() {
        // Create a PHFetchResult object for each section in the table view.
        //        let allPhotosOptions = PHFetchOptions()
        //        allPhotosOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        //        allPhotos = PHAsset.fetchAssets(with: allPhotosOptions)
        //        smartAlbums = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .albumRegular, options: nil)
        //        userCollections = PHCollectionList.fetchTopLevelUserCollections(with: nil)
        
        
        let cameraRoll: PHFetchResult<PHAssetCollection> = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumUserLibrary, options: nil)

        guard let cameraRollCollection = cameraRoll.firstObject
        else {
            return
        }

        albumLabel.append(cameraRollCollection.localizedTitle!)

        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]

        self.fetchResult = PHAsset.fetchAssets(in: cameraRollCollection, options: fetchOptions)
        photoCount.append(fetchResult.count)

        imageManager.requestImage(for: fetchResult.object(at: 0),
                                          targetSize: CGSize(width: 170, height: 170),
                                          contentMode: .aspectFit,
                                          options: nil,
                                          resultHandler: { image, _ in
                                            self.imageArray.append(image!)

        })


   }
}
