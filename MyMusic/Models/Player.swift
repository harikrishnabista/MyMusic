//
//  Player.swift
//  MyMusic
//
//  Created by Hari Krishna Bista on 2/4/18.
//  Copyright © 2018 meroapp. All rights reserved.
//

import UIKit

class Player: NSObject {
    var volume:Float = 0.0
    var isRepeat:Bool = false
    var playList:[Track] = []
    var nowPlaying:Track 
    
    init(track:Track) {
        self.nowPlaying = track
        super.init()
    }
    
    convenience override init() {
        self.init()
    }
    
    func getNextTrack() -> Track? {
     
        return nil
    }
    
    func getPreviousTrack() -> Track? {
        
        return nil
    }
    
    func shuffle() {
        
    }
}
