//
//  ViewController.swift
//  CollectionViewExample
//
//  Created by 박수현 on 11/04/2018.
//  Copyright © 2018 박수현. All rights reserved.
//

import UIKit
import SnapKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 20
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        return cv
    }()
    
    let imagesCellId = "imageCellId"
    let albumCellId = "albumsCellId"
    let imageArray = ["image1", "image2", "image3", "image4", "image5"]
    let albumArray = ["album1", "album2", "album3", "album4", "album5", "album6", "album7", "album8", "album9"]
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupViews()
    }
    
    func setup() {
        view.backgroundColor = .white
        //title = "Example SnapKit"
        //navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func setupViews() {
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(ImagesCell.self, forCellWithReuseIdentifier: imagesCellId)
        collectionView.register(AlbumCell.self, forCellWithReuseIdentifier: albumCellId)
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
   
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 1 {
            return albumArray.count
        }
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: albumCellId, for: indexPath) as! AlbumCell
            cell.album = albumArray[indexPath.item]
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: imagesCellId, for: indexPath) as! ImagesCell
        cell.images = imageArray
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 1 {
            return CGSize(width: view.frame.width / 3 - 16, height: 100)
        }
        return CGSize(width: view.frame.width, height: 300)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == 1 {
            return UIEdgeInsets(top: 10, left: 8, bottom: 10, right: 8)
        }
        return UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
    }
    
}

class ImagesCell: UICollectionViewCell, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    var images: [String]? {
        didSet {
            collectionView.reloadData()
        }
    }
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 5
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        return cv
    }()
    
    let cellId = "cellId"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    func setup() {
        backgroundColor = .green
        addSubview(collectionView)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(IconCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.snp.makeConstraints { (make) in
            make.top.left.equalTo(20)
            make.right.bottom.equalTo(-20)
        }
    }
 
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! IconCell
        if let imageName = images?[indexPath.item] {
            cell.imageView.image = UIImage(named: imageName)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 200, height: frame.height - 20)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 14, bottom: 0, right: 14)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private class IconCell: UICollectionViewCell {
        
        let imageView: UIImageView = {
            let iv = UIImageView()
            iv.contentMode = .scaleToFill
            iv.clipsToBounds = true
            iv.layer.cornerRadius = 15
            return iv
        }()
        
        override init(frame: CGRect){
            super.init(frame: frame)
            setup()
        }
        func setup() {
            addSubview(imageView)
            imageView.snp.makeConstraints { (make) in
                make.top.left.equalTo(10)
                make.right.bottom.equalTo(-10)
            }
        }
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
}

class AlbumCell: UICollectionViewCell {

    var album: String? {
        didSet {
            if let imageName = album {
                imageView.image = UIImage(named: imageName)
            }
        }
    }
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleToFill
        iv.clipsToBounds = true
        //iv.layer.cornerRadius = 15
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    func setup() {
        addSubview(imageView)
        
        imageView.snp.makeConstraints { (make) in
            make.top.left.equalTo(5)
            make.right.bottom.equalTo(-5)
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
