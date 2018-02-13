//
//  Player.swift
//  MyMusic
//
//  Created by Hari Krishna Bista on 2/4/18.
//  Copyright © 2018 meroapp. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer

protocol AudioPlayerProtocol {
    func updateSeekTime(seekTime:Float)
    func prepareToPlay(track:Track)
    func play()
    func pause()
    func playNext()
    func playPrev()
    func stop()
    func shuffle()
}

extension AVPlayer {
    var isPlaying: Bool {
        return rate != 0 && error == nil
    }
}

class AudioPlayer: AudioPlayerProtocol {

    var volume:Float = 0.0
    var isRepeat:Bool = false
    
    var isPlaying:Bool {
        get {
            return self.avPlayer.isPlaying
        }
    }
    
    public static var shared = AudioPlayer()
    var playListManager:PlayListManager = PlayListManager()
    var avPlayer:AVPlayer = AVPlayer()
    
    var seekTime: Float64 = 0.0

    private init(){
        avPlayer.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(1, 1), queue: DispatchQueue.main) { (CMTime) -> Void in
            if self.avPlayer.currentItem?.status == .readyToPlay {
                self.seekTime = CMTimeGetSeconds(self.avPlayer.currentTime());
                self.postNowPlayingSeekTimeUpdated()
            }
        }
        
        setupRemoteCommandCenter()
    }
    
    //broadcast
    func postNowPlayingUpdatedNotification() {
        NotificationCenter.default.post(name: Notification.Name(rawValue: Constants.NotificationName.NOW_PLAYING_UPDATED), object: nil)
        
        updateLockScreenSeekTime()
    }
    
    //broadcast
    func postNowPlayingSeekTimeUpdated() {
        NotificationCenter.default.post(name: Notification.Name(rawValue: Constants.NotificationName.NOW_PLAYING_SEEK_TIME_UPDATED), object: nil)
        
        updateLockScreen()
    }
    
    // background work
    func runInBackground(workItem:DispatchWorkItem) {
        let queue = DispatchQueue(label: "com.meroapp.mymusic.audioplayer", qos: .background, attributes: .concurrent, autoreleaseFrequency: .inherit, target: nil)
        
        queue.async(execute: workItem)
    }
    
    
    func updateSeekTime(seekTime:Float) {
        avPlayer.seek(to: CMTimeMake(Int64(seekTime), 1))
        if avPlayer.rate == 0{
            avPlayer.play()
        }
    }
    
    func getSeekTimeInSeconds() -> Float{
        return Float(seekTime)
    }
    
    func getDurationOfNowPlayingInSeconds() -> Float{
        if let currentTrack = playListManager.getCurrentTrack(){
            return Float(currentTrack.trackTimeMillis/1000)
        }
        
        return 0.0
    }

    func prepareToPlay(track:Track){
        
//        if playListManager.playIndex == playListManager.playList.count - 1 {
//            // update UI with no next available
//        }
//
//        if playListManager.playIndex == 0 {
//            // update UI for no previous available
//        }
//
//        if playListManager.playList.count == 1 {
//            // update UI for no previous available
//            // update UI with no next available
//        }
//

        if let url = URL(string: track.previewUrl) {
            avPlayer.replaceCurrentItem(with: AVPlayerItem(url: url))
        }
    }
    
    func play() {
        
        // subscribe for AVPlayerItemDidPlayToEndTime
        NotificationCenter.default.addObserver(self, selector: #selector(AudioPlayer.playerDidFinishPlaying(sender:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: avPlayer.currentItem)
        
        avPlayer.play()
        
        // as soon as it starts playing add to recently playlist
        if let currentTrack = playListManager.getCurrentTrack(){
            currentTrack.playCount =  currentTrack.playCount ?? 0 + 1
            currentTrack.recentlyPlayedDate = Date()
            User.shared.recentlyPlayed.addToList(track: currentTrack)
        }
        
        postNowPlayingUpdatedNotification()
    }
    
    @objc func playerDidFinishPlaying(sender: NSNotification) {
        if isRepeat{
            self.updateSeekTime(seekTime: 0.0)
        }else{
            playNext()
        }
    }
    
    func pause() {
        avPlayer.pause()
        postNowPlayingUpdatedNotification()
    }
    
    func playNext(){
        if let nextTrack = self.playListManager.getNextTrack(){
            self.prepareToPlay(track: nextTrack)
            self.play()
        }
    }
    
    func playPrev(){
        if let prevTrack = self.playListManager.getPreviousTrack(){
            self.prepareToPlay(track: prevTrack)
            self.play()
        }
    }
    
    func stop(){
        avPlayer.pause()
    }
    
    func setPlaylist(newPlayList:[Track], playIndex:Int) {
        guard newPlayList.count > 0, playIndex < newPlayList.count else {
            return
        }
        
        playListManager.setPlayList(newPlayList: newPlayList, playIndex: playIndex)
        if let currentTrack = playListManager.getCurrentTrack() {
            prepareToPlay(track: currentTrack)
            play()
        }
    }
    
    func setPlaylist(newPlayList:[Track]) {
        guard newPlayList.count > 0 else {
            return
        }
        
        playListManager.setPlayList(newPlayList: newPlayList)
        
        if let currentTrack = playListManager.getCurrentTrack() {
            prepareToPlay(track: currentTrack)
            play()
        }
    }
    
    func shuffle(){
        playListManager.shuffle()
        if let currentTrack = playListManager.getCurrentTrack() {
            prepareToPlay(track: currentTrack)
            play()
        }
    }

    func getNowPlaying() -> Track? {
        return self.playListManager.getCurrentTrack()
    }
    
    // MARK: - Remote Command Center Controls
    func setupRemoteCommandCenter() {
        // Get the shared MPRemoteCommandCenter
        let commandCenter = MPRemoteCommandCenter.shared()
        
        // Add handler for Play Command
        commandCenter.playCommand.addTarget { event in
            return .success
        }
        
        // Add handler for Pause Command
        commandCenter.pauseCommand.addTarget { event in
            return .success
        }
        
        // Add handler for Next Command
        commandCenter.nextTrackCommand.addTarget { event in
            return .success
        }
        
        // Add handler for Previous Command
        commandCenter.previousTrackCommand.addTarget { event in
            return .success
        }
    }
    
    // MARK: - MPNowPlayingInfoCenter (Lock screen)
    func updateLockScreenSeekTime() {

        var nowPlayingInfo = [String : Any]()
        
        if let currentItem = avPlayer.currentItem {
            nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = CMTimeGetSeconds(currentItem.currentTime())
            nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = Float(CMTimeGetSeconds(currentItem.duration))
        }
        
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }
    
    func updateLockScreen() {
        
        // Define Now Playing Info
        var nowPlayingInfo = [String : Any]()
        
        guard let nowPlaying = AudioPlayer.shared.getNowPlaying() else{
            return
        }
        
        if let imgCache = GlobalCache.shared.imageCache[nowPlaying.artworkUrl100] {
            nowPlayingInfo[MPMediaItemPropertyArtwork] = MPMediaItemArtwork(image: imgCache)
        }else{
            if let imgUrl = URL(string:nowPlaying.artworkUrl100) {
                ApiCaller().getImageFrom(url: imgUrl, completion: { (img) in
                    nowPlayingInfo[MPMediaItemPropertyArtwork] = MPMediaItemArtwork(image: img ?? UIImage(named:"iconMusic")!)
                    MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
                })
            }
        }

        nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = avPlayer.rate
        nowPlayingInfo[MPNowPlayingInfoPropertyDefaultPlaybackRate] = avPlayer.rate

        nowPlayingInfo[MPMediaItemPropertyArtist] = nowPlaying.artistName
        nowPlayingInfo[MPMediaItemPropertyAlbumTitle] = nowPlaying.collectionName
        nowPlayingInfo[MPMediaItemPropertyTitle] = nowPlaying.trackName
        
        if let currentItem = avPlayer.currentItem {
            nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = CMTimeGetSeconds(currentItem.currentTime())
            nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = Float(CMTimeGetSeconds(currentItem.duration))
        }
        
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }
}
