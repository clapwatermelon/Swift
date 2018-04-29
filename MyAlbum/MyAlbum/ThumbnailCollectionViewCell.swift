//
//  GroupPhotosCollectionViewCell.swift
//  MyAlbum
//
//  Created by 박수현 on 16/04/2018.
//  Copyright © 2018 박수현. All rights reserved.
//

import UIKit

class ThumbnailCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var photoCount: UILabel!
    @IBOutlet weak var tumbnailLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    var representedAssetIdentifier: String!
    
    var thumbnailImage: UIImage! {
        didSet {
            imageView.image = thumbnailImage
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.imageView.layer.masksToBounds = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.setImageView()
    }
    
    func setImageView() {
        self.imageView.layer.cornerRadius = 5
    }
}
