//
//  NowPlayingView.swift
//  MyMusic
//
//  Created by Hari Krishna Bista on 2/7/18.
//  Copyright © 2018 meroapp. All rights reserved.
//

import UIKit

class NowPlayingView: UIView,UIGestureRecognizerDelegate {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    @IBOutlet weak var lblSubtitle: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgTrack: UIImageView!
    
    @IBOutlet weak var progressBar: UIProgressView!
    var navController:UINavigationController?
    
    @IBOutlet weak var btnPlay: UIButton!
    init(delegate:UINavigationController) {
        
        self.navController = delegate
        
        let frame = CGRect(x: 0.0, y: 0.0, width: (UIApplication.shared.keyWindow?.frame.width) ?? 320, height: 60.0)
        super.init(frame: frame)
        setup();
        
        // subscribe for the AudioPlayer nowplaying updated
        NotificationCenter.default.addObserver(self, selector: #selector(NowPlayingView.nowPlayingUpdated), name: NSNotification.Name(rawValue: Constants.NotificationName.NOW_PLAYING_UPDATED), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(NowPlayingView.nowPlayingSeekTimeUpdated), name: NSNotification.Name(rawValue: Constants.NotificationName.NOW_PLAYING_SEEK_TIME_UPDATED), object: nil)
        
        if AudioPlayer.shared.getNowPlaying() == nil {
            self.isHidden = true
        }
    }

    @objc func nowPlayingSeekTimeUpdated() {

        if let nowPlaying = AudioPlayer.shared.getNowPlaying() {
            
            progressBar.setProgress(AudioPlayer.shared.getSeekTimeInSeconds()/AudioPlayer.shared.getDurationOfNowPlayingInSeconds(), animated: true)
        }
    }
    
    @objc func nowPlayingUpdated() {
        
        if self.isHidden == true {
            self.isHidden = false
        }
        
        if let nowPlaying = AudioPlayer.shared.getNowPlaying() {
            self.lblTitle.text = nowPlaying.trackName
            self.lblSubtitle.text = nowPlaying.artistName
            
            if let isPlaying = nowPlaying.isPlaying, isPlaying == true {
                btnPlay.setImage(UIImage(named:"iconPause"), for: .normal)
            }else{
                btnPlay.setImage(UIImage(named:"iconPlay"), for: .normal)
            }
            
            self.imgTrack.setImageWithUrl(urlStr: nowPlaying.artworkUrl100, placeHolderImageName: "iconMusic")
            
        }
    }
    
    @IBAction func btnPlayTapped(_ sender: Any) {
        
        guard let nowPlaying = AudioPlayer.shared.getNowPlaying() else {
            return
        }
        
        if let isPlaying = nowPlaying.isPlaying, isPlaying == true {
            AudioPlayer.shared.pause()
        }else{
            AudioPlayer.shared.play()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        setup();
    }
    
    func setup()
    {
        let view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        self.addSubview(view)
        
//        cell.btnPlay.addTarget(self, action: #selector(AlbumViewController.btnPlayCellTapped(sender:)), for: .touchUpInside)
        
        // handle tap on out of slide panel
        let tap = UITapGestureRecognizer(target: self, action:#selector(pageTapped(sender:)))
        self.addGestureRecognizer(tap)
        tap.delegate = self
    }
    
    @objc func pageTapped(sender: UITapGestureRecognizer?) {
        
        guard let nowPlaying = AudioPlayer.shared.playerMetaData.getCurrentTrack() else {
            return
        }
        
        if let playerViewCon = self.navController?.storyboard?.instantiateViewController(withIdentifier: "PlayerViewController") as? PlayerViewController {
            
            playerViewCon.playerMetaData = AudioPlayer.shared.playerMetaData
            playerViewCon
            
            self.navController?.present(playerViewCon, animated: true, completion: nil)
        }
    }
    
    func loadViewFromNib() -> UIView
    {
        let bundle = Bundle(for:type(of: self))
        let nib = UINib(nibName: "NowPlaying", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        
        return view;
    }

}
