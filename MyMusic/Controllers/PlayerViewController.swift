//
//  PlayerViewController.swift
//  MyMusic
//
//  Created by Hari Krishna Bista on 2/4/18.
//  Copyright © 2018 meroapp. All rights reserved.
//

import UIKit
import AVFoundation

class PlayerViewController: UIViewController {
    
    var playerMetaData:PlayerMetaData!
    var nowPlaying:Track?
//    var avPlayer:AVPlayer?
//    var avPlayerItem:AVPlayerItem?
    
    @IBOutlet weak var lblAlbumSubtitle: UILabel!
    @IBOutlet weak var lblAlbumTitle: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.nowPlaying = self.playerMetaData.getCurrentTrack()
        
        guard let nowPlaying = self.nowPlaying else {
            return
        }
        
        if let isFav = nowPlaying.isMyMusic, isFav == true {
            btnLike.setImage(UIImage(named:"iconLikeFilled"), for: .normal)
        }

        imgTrack.setImageWithUrl(urlStr: nowPlaying.artworkUrl100, placeHolderImageName: "iconMusic")
        
        lblAlbumTitle.text = nowPlaying.collectionName
        lblAlbumSubtitle.text = "\(playerMetaData.playList.count) tracks"
        
        lblTrackTitle.text = nowPlaying.trackName
        lblTrackSubTitle.text = nowPlaying.artistName
        
        lblCollectionPrice.text = nowPlaying.getCollectionPriceLabel()
        lblTrackPrice.text = nowPlaying.getTrackPriceLabel()
        
        viewContainerBuy.layer.borderWidth = 1.0
        viewContainerBuy.layer.cornerRadius = 4.0
        viewContainerBuy.layer.borderColor = UIColor.lightText.cgColor
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
        
        guard let nowPlaying = self.nowPlaying else {
            return
        }
        
        guard let isMyMusic = nowPlaying.isMyMusic else {
            return
        }
        
        if isMyMusic == false {
            nowPlaying.isMyMusic = true
            btnLike.setImage(UIImage(named:"iconLikeFilled"), for: .normal)
            User.shared.myMusic.addToList(track: nowPlaying)
        }else{
            nowPlaying.isMyMusic = false
            btnLike.setImage(UIImage(named:"iconLike"), for: .normal)
            User.shared.myMusic.removeFromList(track: nowPlaying)
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

}
