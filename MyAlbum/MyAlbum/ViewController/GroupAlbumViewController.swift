//
//  GroupAlbumViewController.swift
//  MyAlbum
//
//  Created by 박수현 on 16/04/2018.
//  Copyright © 2018 박수현. All rights reserved.
//

import UIKit
import Photos

class GroupAlbumViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    

    var fetchResult: PHFetchResult<PHAsset>!
    var fetchResult2: PHFetchResult<PHAsset>!
    var fetchResult3: PHFetchResult<PHAsset>!
    var fetchResult4: PHFetchResult<PHAsset>!
    
    var imageManager: PHCachingImageManager = PHCachingImageManager()
    var reuseIdentifier: String = "GroupCell"
    var albumLabel: [String] = []
    var photoCount: [Int] = []
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

        cell.groupLabel.text = albumLabel[indexPath.item]
        cell.photoCount.text = String(photoCount[indexPath.item])
        cell.imageView.image = imageArray[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let detailVC = DetailAlbumViewController()
//        detailVC.albumTitle = self.albumLabel[indexPath.item]
//        print(detailVC.albumTitle)
//        self.navigationController?.pushViewController(detailVC, animated: true)

        let nextVC =  UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailAlbumViewController") as! DetailAlbumViewController
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
        
        let selfies: PHFetchResult<PHAssetCollection> = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumSelfPortraits, options: nil)
        
        let userAlbum: PHFetchResult<PHAssetCollection> = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: nil)
        
        guard let cameraRollCollection = cameraRoll.firstObject,
            let favoritesCollection = favorites.firstObject,
            let selfiesCollection = selfies.firstObject,
            let userAlbumCollection = userAlbum.lastObject else {
            return
        }
        
        albumLabel.append(cameraRollCollection.localizedTitle!)
        albumLabel.append(favoritesCollection.localizedTitle!)
        albumLabel.append(selfiesCollection.localizedTitle!)
        albumLabel.append(userAlbumCollection.localizedTitle!)
        
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
        
        self.fetchResult2 = PHAsset.fetchAssets(in: favoritesCollection, options: fetchOptions)
        photoCount.append(fetchResult2.count)
        imageManager.requestImage(for: fetchResult2.object(at: 0),
                                  targetSize: CGSize(width: 170, height: 170),
                                  contentMode: .aspectFit,
                                  options: nil,
                                  resultHandler: { image, _ in
                                    self.imageArray.append(image!)

        })
        
        self.fetchResult3 = PHAsset.fetchAssets(in: selfiesCollection, options: fetchOptions)
        photoCount.append(fetchResult3.count)
        imageManager.requestImage(for: fetchResult3.object(at: 0),
                                  targetSize: CGSize(width: 170, height: 170),
                                  contentMode: .aspectFit,
                                  options: nil,
                                  resultHandler: { image, _ in
                                    self.imageArray.append(image!)
                                    
        })
        
        self.fetchResult4 = PHAsset.fetchAssets(in: userAlbumCollection, options: fetchOptions)
        photoCount.append(fetchResult4.count)
        imageManager.requestImage(for: fetchResult4.object(at: 0),
                                  targetSize: CGSize(width: 170, height: 170),
                                  contentMode: .aspectFit,
                                  options: nil,
                                  resultHandler: { image, _ in
                                    self.imageArray.append(image!)
                                    
        })
 
   
    }
}
