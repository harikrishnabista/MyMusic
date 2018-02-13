//
//  PlayListManager.swift
//  MyMusic
//
//  Created by Hari Krishna Bista on 2/12/18.
//  Copyright © 2018 meroapp. All rights reserved.
//

import UIKit

class PlayListManager {
    
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
            // if this is last track go to beginning
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
            // if this is last track go to last track
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
        
        guard playList.count > 1 else {
            return
        }
        
        // shuffle algorithm explanation
        // append to shuffled array one by one selecting random track
        // this way it prevents achieving same result as original sequence
        
        var shuffled:[Track] = []
        
        while(self.playList.count > 2){
            let randomIndex = getRandomIndex(lower: 1, upper: playList.count - 1)
            
            // swap between random index and last index
            let firstTrack = playList[0]
            playList[0] = playList[randomIndex]
            playList[randomIndex] = firstTrack
            
            shuffled.append(playList.remove(at: 0))
        }
        
        // for last two elements swap only
        shuffled.append(playList.removeLast())
        shuffled.append(playList.removeLast())
        
        playList = shuffled
        
        // after shuffling choose first element as playIndex
        playIndex = 0
    }
}

