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
    
//    var delegate:AudioPlayerMetaUpdatable?

    public static var shared = AudioPlayer()
    var playerMetaData:PlayerMetaData = PlayerMetaData()
    var avPlayer:AVPlayer = AVPlayer()

    private init(){
        
    }
    
    func updateSeekTime(time:Float) {
        
    }
    
    func getSeekTime() {
        
    }
    
    func prepareToPlay(track:Track){
        
        if playerMetaData.playIndex == playerMetaData.playList.count - 1 {
            // update UI with no next available
        }
        
        if playerMetaData.playIndex == 0 {
            // update UI for no previous available
        }
        
        if playerMetaData.playList.count == 1 {
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
        if let currentTrack = playerMetaData.getCurrentTrack(){
            currentTrack.playCount =  currentTrack.playCount ?? 0 + 1
            currentTrack.isPlaying = true
            currentTrack.recentlyPlayedDate = Date()
            User.shared.recentlyPlayed.addToList(track: currentTrack)
            
            currentTrack.isMyMusic = true
            User.shared.myMusic.addToList(track: currentTrack)
        }
    }
    
    // observers
    @objc func playerDidFinishPlaying(sender: NSNotification) {
        // update UI
        print("playing finished.")
    }
    
    func pause() {
        avPlayer.pause()
        
        // change playing status 
        playerMetaData.getCurrentTrack()?.isPlaying = false
    }
    
    func playNext(){
        prepareToPlay(track: playerMetaData.getNextTrack())
        play()
    }
    
    func playPrev(){
        prepareToPlay(track: playerMetaData.getPreviousTrack())
        play()
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
        
        playerMetaData.setPlayList(newPlayList: newPlayList, playIndex: playIndex)
        if let currentTrack = playerMetaData.getCurrentTrack() {
            prepareToPlay(track: currentTrack)
            play()
        }
    }
    
    func setPlaylist(newPlayList:[Track]) {
        guard newPlayList.count > 0 else {
            return
        }
        
        playerMetaData.setPlayList(newPlayList: newPlayList)
        
        if let currentTrack = playerMetaData.getCurrentTrack() {
            prepareToPlay(track: currentTrack)
            play()
        }
    }
    
    func shuffle(){
        playerMetaData.shuffle()
        if let currentTrack = playerMetaData.getCurrentTrack() {
            prepareToPlay(track: currentTrack)
            play()
        }
    }
}

class PlayerMetaData {
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

    func getNextTrack() -> Track {
        playIndex = playIndex + 1
        return playList[playIndex]
    }
    
    func getPreviousTrack() -> Track {
        playIndex = playIndex - 1
        return playList[playIndex]
    }
    
    func getCurrentTrack() -> Track? {
        if playList.count > 0{
            return playList[playIndex]
        }
        
        return nil
    }
    
    func shuffle() {
        playIndex = 0
    }
}
