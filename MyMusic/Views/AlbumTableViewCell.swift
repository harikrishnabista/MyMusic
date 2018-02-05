//
//  AlbumTableViewCell.swift
//  MyMusic
//
//  Created by Hari Krishna Bista on 2/5/18.
//  Copyright © 2018 meroapp. All rights reserved.
//

import UIKit

class AlbumTableViewCell: UITableViewCell {

    @IBOutlet weak var imgAlbum: UIImageView!
    @IBOutlet weak var viewToolbar: UIView!
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var btnDownload: UIButton!
    @IBOutlet weak var btnPlay: UIButton!
    @IBOutlet weak var btnShare: UIButton!
    @IBOutlet weak var btnMore: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
