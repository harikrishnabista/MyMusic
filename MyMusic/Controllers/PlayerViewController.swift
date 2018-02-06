//
//  PlayerViewController.swift
//  MyMusic
//
//  Created by Hari Krishna Bista on 2/4/18.
//  Copyright © 2018 meroapp. All rights reserved.
//

import UIKit

class PlayerViewController: UIViewController {
    
    var player:Player!
    
    @IBOutlet weak var lblAlbumSubtitle: UILabel!
    @IBOutlet weak var lblAlbumTitle: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.imgTrack.setImageWithUrl(urlStr: self.player.nowPlaying.artworkUrl100, placeHolderImageName: "iconMusic")
        
        lblAlbumTitle.text = self.player.nowPlaying.collectionName
        lblAlbumSubtitle.text = "\(player.playList.count) tracks"
        
        lblTrackTitle.text = player.nowPlaying.trackName
        lblTrackSubTitle.text = player.nowPlaying.artistName
        
        lblCollectionPrice.text = player.nowPlaying.getCollectionPriceLabel()
        lblTrackPrice.text = player.nowPlaying.getTrackPriceLabel()
        
        viewContainerBuy.layer.borderWidth = 1.0
        viewContainerBuy.layer.cornerRadius = 4.0
        viewContainerBuy.layer.borderColor = UIColor.lightText.cgColor
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var viewContainerBuy: UIView!
    @IBAction func btnBuyTapped(_ sender: Any) {
    }
    @IBOutlet weak var lblTrackPrice: UILabel!
    @IBOutlet weak var lblCollectionPrice: UILabel!
    @IBAction func btnShareTrackTapped(_ sender: Any) {
    }
    @IBAction func btnTrackListTapped(_ sender: Any) {
    }
    @IBAction func btnCloseViewTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func btnLikeTapped(_ sender: Any) {
//        User.shared.
        
        guard let trackMetaData = player.nowPlaying.metaData else {
            return
        }
        
        if trackMetaData.isFavorite == false {
            btnLike.setImage(UIImage(named:"iconLikeFilled"), for: .normal)
            User.shared.myMusic.addToList(track: player.nowPlaying)
        }else{
            btnLike.setImage(UIImage(named:"iconLike"), for: .normal)
            User.shared.myMusic.removeFromList(track: player.nowPlaying)
        }
    }
    @IBOutlet weak var lblTrackTitle: UILabel!
    @IBOutlet weak var lblTrackSubTitle: UILabel!
    
    @IBOutlet weak var imgTrack: UIImageView!
    @IBOutlet weak var btnLike: UIButton!
    
    // player controls
    
    @IBAction func btnNextTapped(_ sender: Any) {
    }
    
    @IBAction func btnRepeatTapped(_ sender: Any) {
    }
    @IBOutlet weak var btnPlay: UIButton!
    @IBAction func btnPlayTapped(_ sender: Any) {
    }
    
    @IBAction func btnPrevTapped(_ sender: Any) {
    }
    
    @IBOutlet weak var lblSeekTime: UILabel!
    @IBAction func btnShuffleTapped(_ sender: Any) {
    }
    @IBOutlet weak var lblTotalTime: UILabel!
    @IBOutlet weak var slider: UISlider!
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
