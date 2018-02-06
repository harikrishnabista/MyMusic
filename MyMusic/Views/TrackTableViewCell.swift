//
//  TrackTableViewCell.swift
//  MyMusic
//
//  Created by Hari Krishna Bista on 2/4/18.
//  Copyright © 2018 meroapp. All rights reserved.
//

import UIKit

class TrackTableViewCell: UITableViewCell {

    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var imgTrack: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubTitle: UILabel!
    @IBOutlet weak var lblSubSubTitle: UILabel!
    @IBOutlet weak var btnPlay: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    override func draw(_ rect: CGRect) {
        self.viewContainer.layer.borderColor = UIColor.white.cgColor
        viewContainer.layer.cornerRadius = 3.0
        viewContainer.layer.borderWidth = 1.0
        
//        self.backgroundColor = UIColor.lightText
//        self.backgroundView?.backgroundColor = UIColor.lightText
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
