//
//  RecentCollectionViewCell.swift
//  MyMusic
//
//  Created by Hari Krishna Bista on 2/6/18.
//  Copyright © 2018 meroapp. All rights reserved.
//

import UIKit

class RecentCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgTrack: UIImageView!
    @IBOutlet weak var lblSubtitle: UILabel!
    @IBOutlet weak var btnPlay: UIButton!
    @IBOutlet weak var viewContainer: UIView!
    
    override func draw(_ rect: CGRect) {
        viewContainer.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.4).cgColor
        viewContainer.layer.cornerRadius = 8.0
        viewContainer.layer.borderWidth = 1.0
    }
}
