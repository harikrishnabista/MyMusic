//
//  Player.swift
//  MyMusic
//
//  Created by Hari Krishna Bista on 2/4/18.
//  Copyright © 2018 meroapp. All rights reserved.
//

import UIKit
import AVFoundation

//protocol AudioPlayerMetaUpdatable {
//    func volumeUpdated(volume:Float)
//    func updateAudioPlayerStatus()
//    func audioPlayingInterupted()
//    func playingCompleted()
//    func
//}

extension AVPlayer {
    var isPlaying: Bool {
        return rate != 0 && error == nil
    }
}

class AudioPlayer {
    
    func runInBackground(workItem:DispatchWorkItem) {
        let queue = DispatchQueue(label: "com.meroapp.mymusic.audioplayer", qos: .background, attributes: .concurrent, autoreleaseFrequency: .inherit, target: nil)
        
        queue.async(execute: workItem)
    }
    
//    var delegate:AudioPlayerMetaUpdatable?

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
    }
    
    var isPlaying:Bool {
        get {
            return self.avPlayer.isPlaying
        }
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
    
    func postNowPlayingSeekTimeUpdated() {
        NotificationCenter.default.post(name: Notification.Name(rawValue: Constants.NotificationName.NOW_PLAYING_SEEK_TIME_UPDATED), object: nil)
        
    }
    
    func prepareToPlay(track:Track){
        
        if playListManager.playIndex == playListManager.playList.count - 1 {
            // update UI with no next available
        }
        
        if playListManager.playIndex == 0 {
            // update UI for no previous available
        }
        
        if playListManager.playList.count == 1 {
            // update UI for no previous available
            // update UI with no next available
        }
        

        if let url = URL(string: track.previewUrl) {
            avPlayer.replaceCurrentItem(with: AVPlayerItem(url: url))
        }
    }
    
    func play() {
    
        NotificationCenter.default.addObserver(self, selector: #selector(AudioPlayer.playerDidFinishPlaying(sender:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: avPlayer.currentItem)
        
        
        avPlayer.play()
        
        // as soon as it starts playing add to recently playlist
        if let currentTrack = playListManager.getCurrentTrack(){
            currentTrack.playCount =  currentTrack.playCount ?? 0 + 1
//            currentTrack.isPlaying = true
            currentTrack.recentlyPlayedDate = Date()
            User.shared.recentlyPlayed.addToList(track: currentTrack)
            
//            currentTrack.isMyMusic = true
//            User.shared.myMusic.addToList(track: currentTrack)
        }
        
        postNowPlayingUpdatedNotification()
    }
    
    // observers
    @objc func playerDidFinishPlaying(sender: NSNotification) {
        // update UI
        print("playing finished.")
        
//        if let currentTrack = playListManager.getCurrentTrack(){
//            currentTrack.isPlaying = false
//        }
        
        playNext()
    }
    
    func pause() {
        avPlayer.pause()
        
        // change playing status 
//        playListManager.getCurrentTrack()?.isPlaying = false
//        playListManager.getCurrentTrack()?.isPlaying = false
        
        postNowPlayingUpdatedNotification()
    }
    
    func playNext(){
        
//        let queue = DispatchQueue(label: "", qos: .background, attributes: .concurrent, autoreleaseFrequency: .inherit, target: nil)
        
//        let workItem = DispatchWorkItem {
            if let nextTrack = self.playListManager.getNextTrack(){
                self.prepareToPlay(track: nextTrack)
                self.play()
            }
//        }
        
//        queue.async(execute: workItem)
    }
    
    func playPrev(){
        
//        let queue = DispatchQueue(label: "", qos: .background, attributes: .concurrent, autoreleaseFrequency: .inherit, target: nil)
        
//        let workItem = DispatchWorkItem {
            if let prevTrack = self.playListManager.getPreviousTrack(){
                self.prepareToPlay(track: prevTrack)
                self.play()
            }
//        }
        
//        queue.async(execute: workItem)
    }
    
    func stop(){
        avPlayer.pause()
    }
    
    func setPlaylist(newPlayList:[Track], playIndex:Int) {
        
        guard newPlayList.count > 0 else {
            return
        }
        
        guard playIndex < newPlayList.count else {
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
    
    func postNowPlayingUpdatedNotification() {
        NotificationCenter.default.post(name: Notification.Name(rawValue: Constants.NotificationName.NOW_PLAYING_UPDATED), object: nil)
    }
    
    func getNowPlaying() -> Track? {
        return self.playListManager.getCurrentTrack()
    }
}

class PlayListManager {
    var volume:Float = 0.0
    var isRepeat:Bool = false
    
    var playList:[Track] = []
    var playIndex = 0
    
    init() {
    }
    
    init(tracks:[Track]) {
        playList = tracks
        playIndex = 0
    }
    
    init(tracks:[Track], playIndex:Int) {
        playList = tracks
        self.playIndex = playIndex
    }
    
    func setPlayList(newPlayList:[Track]){
        playList = newPlayList
        playIndex = 0
    }
    
    func setPlayList(newPlayList:[Track], playIndex:Int){
        playList = newPlayList
        self.playIndex = playIndex
    }

    func getNextTrack() -> Track? {
        
        guard playList.count > 0 else {
            return nil
        }
        
        if playIndex + 1 < playList.count {
            playIndex = playIndex + 1
            return playList[playIndex]
        }else{
            playIndex = 0
            return playList[playIndex]
        }
    }
    
    func getPreviousTrack() -> Track? {
        
        guard playList.count > 0 else {
            return nil
        }
        
        if playIndex > 1 {
            playIndex = playIndex - 1
            return playList[playIndex]
        }else{
            playIndex = playList.count - 1
            return playList[playIndex]
        }
    }
    
    func getCurrentTrack() -> Track? {
        if playList.count > 0{
            return playList[playIndex]
        }
        
        return nil
    }
    
    func getRandomIndex(lower:Int, upper:Int) -> Int {
        return  lower + Int(arc4random_uniform(UInt32(upper - lower)))
    }
    
    func shuffle() {
        var shuffled:[Track] = []
        
        while(self.playList.count > 2){
            let randomIndex = getRandomIndex(lower: 1, upper: playList.count - 1)
            
            // swap between random index and last index
            let firstTrack = playList[0]
            playList[0] = playList[randomIndex]
            playList[randomIndex] = firstTrack
            
            shuffled.append(playList.remove(at: 0))
        }
        
        shuffled.append(playList.removeLast())
        shuffled.append(playList.removeLast())
        
        // for lastTwo items
        // swap between random index and last index
        
//        let randomIndex = 1
//        let firstTrack = playList[0]
//        playList[0] = playList[randomIndex]
//        playList[randomIndex] = firstTrack
        
        playList = shuffled
        

        playIndex = 0
    }
}
