//
//  GroupAlbumViewController.swift
//  MyAlbum
//
//  Created by 박수현 on 16/04/2018.
//  Copyright © 2018 박수현. All rights reserved.
//

import UIKit
import Photos

class GroupAlbumViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    //var fetchResult: [PHFetchResult<PHAsset>]!
    var fetchResult: PHFetchResult<PHAsset>!
    var imageManager: PHCachingImageManager = PHCachingImageManager()
    var reuseIdentifier: String = "GroupCell"
    var albumLabel:String = ""
    var imageArray = [UIImage]()
    override func viewDidLoad() {
        super.viewDidLoad()
        photoAuthorization()
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.imageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell: GroupPhotosCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? GroupPhotosCollectionViewCell else { fatalError("Wrong cell") }
        let asset: PHAsset = fetchResult.object(at: indexPath.item)
        //let asset: PHAsset = fetchResult[indexPath.item].object(at: fetchResult.count)
        imageManager.requestImage(for: asset,
                                  targetSize: CGSize(width: 170, height: 170),
                                  contentMode: .aspectFit,
                                  options: nil,
                                  resultHandler: { image, _ in
                                    cell.imageView.image = self.imageArray[0]
                                    
        })
        
        //cell.imageView.image = imageArray.first
//        let cameraRoll: PHFetchResult<PHAssetCollection> = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumFavorites, options: nil)
//        let cameraRollCollection = cameraRoll.firstObject
//        cell.groupLabel.text = cameraRollCollection?.localizedTitle
        cell.groupLabel.text = albumLabel
        return cell
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
                    self.requestCollection()
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
    
        let cameraRoll: PHFetchResult<PHAssetCollection> = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumUserLibrary, options: nil)
        
        let favorites: PHFetchResult<PHAssetCollection> = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumFavorites, options: nil)
        
        let people: PHFetchResult<PHAssetCollection> = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumSelfPortraits, options: nil)
        
        let userAlbum: PHFetchResult<PHAssetCollection> = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: nil)
        guard let cameraRollCollection = cameraRoll.firstObject,
            let favoritesCollection = favorites.firstObject,
            let peopleCollection = people.firstObject else {
            return
        }
        
         albumLabel = cameraRollCollection.localizedTitle!
        
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        self.fetchResult = PHAsset.fetchAssets(in: cameraRollCollection, options: fetchOptions)
        
      
        imageManager.requestImage(for: fetchResult.object(at: 0),
                                          targetSize: CGSize(width: 170, height: 170),
                                          contentMode: .aspectFit,
                                          options: nil,
                                          resultHandler: { image, _ in
                                            self.imageArray.append(image!)
                                            
        })
   
    }
}
