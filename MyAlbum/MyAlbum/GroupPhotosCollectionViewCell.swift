//
//  GroupPhotosCollectionViewCell.swift
//  MyAlbum
//
//  Created by 박수현 on 16/04/2018.
//  Copyright © 2018 박수현. All rights reserved.
//

import UIKit

class GroupPhotosCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var photoCount: UILabel!
    @IBOutlet weak var groupLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
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
