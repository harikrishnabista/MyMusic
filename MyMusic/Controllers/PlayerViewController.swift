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
    
    var playListManager:PlayListManager!
    var nowPlaying:Track?
//    var avPlayer:AVPlayer?
//    var avPlayerItem:AVPlayerItem?
    
    @IBOutlet weak var lblAlbumSubtitle: UILabel!
    @IBOutlet weak var lblAlbumTitle: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        updateUI()
        
        // subscribe for the AudioPlayer nowplaying updated
        NotificationCenter.default.addObserver(self, selector: #selector(NowPlayingView.nowPlayingUpdated), name: NSNotification.Name(rawValue: Constants.NotificationName.NOW_PLAYING_UPDATED), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(NowPlayingView.nowPlayingSeekTimeUpdated), name: NSNotification.Name(rawValue: Constants.NotificationName.NOW_PLAYING_SEEK_TIME_UPDATED), object: nil)
        
        viewContainerBuy.layer.borderWidth = 1.0
        viewContainerBuy.layer.cornerRadius = 4.0
        viewContainerBuy.layer.borderColor = UIColor.lightText.cgColor
        
        slider.addTarget(self, action: #selector(onSliderValChanged(slider:event:)), for: .valueChanged)
    }
    
    func updateUI() {
        
        self.nowPlaying = self.playListManager.getCurrentTrack()
        
        guard let nowPlaying = self.nowPlaying else {
            return
        }
        
        if let isFav = nowPlaying.isMyMusic, isFav == true {
            btnLike.setImage(UIImage(named:"iconLikeFilled"), for: .normal)
        }
        
        if AudioPlayer.shared.isPlaying {
            btnPlay.setImage(UIImage(named:"iconPause"), for: .normal)
        }else{
            btnPlay.setImage(UIImage(named:"iconPlay"), for: .normal)
        }
        
        imgTrack.setImageWithUrl(urlStr: nowPlaying.artworkUrl100, placeHolderImageName: "iconMusic")
        
        lblAlbumTitle.text = nowPlaying.collectionName
        lblAlbumSubtitle.text = "\(playListManager.playList.count) tracks"
        
        lblTrackTitle.text = nowPlaying.trackName
        lblTrackSubTitle.text = nowPlaying.artistName
        
        lblCollectionPrice.text = nowPlaying.getCollectionPriceLabel()
        lblTrackPrice.text = nowPlaying.getTrackPriceLabel()
        
        let secondsInt = Int(AudioPlayer.shared.getSeekTimeInSeconds())
        lblSeekTime.text = StopWatch(totalSeconds: secondsInt).simpleTimeString
        
        let secondsSeekTime = Int(AudioPlayer.shared.getDurationOfNowPlayingInSeconds())
        lblTotalTime.text = StopWatch(totalSeconds: secondsSeekTime).simpleTimeString
        
        if let isMyMusic = nowPlaying.isMyMusic, isMyMusic == true {
            btnLike.setImage(UIImage(named:"iconLikeFilled"), for: .normal)
        }else{
            btnLike.setImage(UIImage(named:"iconLike"), for: .normal)
        }
    }
    
    @objc func onSliderValChanged(slider: UISlider, event: UIEvent) {
        if let touchEvent = event.allTouches?.first {
            switch touchEvent.phase {
                
            case .moved:
                let seconds = Int(slider.value * AudioPlayer.shared.getDurationOfNowPlayingInSeconds())
                lblSeekTime.text = StopWatch(totalSeconds: seconds).simpleTimeString
            case .ended:
                let seekTime = self.slider.value * AudioPlayer.shared.getDurationOfNowPlayingInSeconds()
                
                AudioPlayer.shared.runInBackground(workItem: DispatchWorkItem{
                    AudioPlayer.shared.updateSeekTime(seekTime: seekTime)
                })
                
            default:
                break
            }
        }
    }
    
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            AudioPlayer.shared.runInBackground(workItem: DispatchWorkItem{
                AudioPlayer.shared.shuffle()
            })
        }
    }
    
    @objc func nowPlayingSeekTimeUpdated() {
        DispatchQueue.main.async {
            if self.slider.isTracking  {
                print("do not update the slider now")
            }else{
                self.slider.value = AudioPlayer.shared.getSeekTimeInSeconds()/AudioPlayer.shared.getDurationOfNowPlayingInSeconds()
            }
            
            let secondsInt = Int(AudioPlayer.shared.getSeekTimeInSeconds())
            self.lblSeekTime.text = StopWatch(totalSeconds: secondsInt).simpleTimeString
        }
    }
    
    @objc func nowPlayingUpdated() {
        DispatchQueue.main.async {
            self.updateUI()
        }
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
    
//    func runInBackground(workItem:DispatchWorkItem) {
//        let queue = DispatchQueue(label: "com.meroapp.mymusic.audioplayer", qos: .background, attributes: .concurrent, autoreleaseFrequency: .inherit, target: nil)
//
//        queue.async(execute: workItem)
//    }
    
    @IBOutlet weak var lblTrackTitle: UILabel!
    @IBOutlet weak var lblTrackSubTitle: UILabel!
    
    @IBOutlet weak var imgTrack: UIImageView!
    @IBOutlet weak var btnLike: UIButton!
    
    // player controls
    @IBAction func btnNextTapped(_ sender: Any) {
        AudioPlayer.shared.runInBackground(workItem: DispatchWorkItem {
            AudioPlayer.shared.playNext()
        })
    }
    
    @IBAction func btnRepeatTapped(_ sender: Any) {
    }
    @IBOutlet weak var btnPlay: UIButton!
    @IBAction func btnPlayTapped(_ sender: Any) {
        AudioPlayer.shared.runInBackground(workItem: DispatchWorkItem {
            if AudioPlayer.shared.isPlaying {
                AudioPlayer.shared.pause()
            }else{
                AudioPlayer.shared.play()
            }
        })
    }
    
    @IBAction func btnPrevTapped(_ sender: Any) {
        AudioPlayer.shared.runInBackground(workItem: DispatchWorkItem {
            AudioPlayer.shared.playPrev()
        })
    }
    
    @IBOutlet weak var lblSeekTime: UILabel!
    @IBAction func btnShuffleTapped(_ sender: Any) {
        AudioPlayer.shared.runInBackground(workItem: DispatchWorkItem {
            AudioPlayer.shared.shuffle()
        })
    }
    @IBOutlet weak var lblTotalTime: UILabel!
    @IBOutlet weak var slider: UISlider!

}
