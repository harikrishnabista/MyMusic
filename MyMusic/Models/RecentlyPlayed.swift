//
//  RecentlyPlayer.swift
//  MyMusic
//
//  Created by Hari Krishna Bista on 2/4/18.
//  Copyright © 2018 meroapp. All rights reserved.
//

import UIKit

class RecentlyPlayed: NSObject, MusicCollection {
    var tracks:[Track] = []
    
    func addToList(track: Track) {
        
        for (i,item) in self.tracks.enumerated() {
            if item.trackId == track.trackId {
//                self.tracks.remove(at: i)
                return
            }
        }
        
        self.tracks.insert(track, at: 0)
    }
    
    func removeFromList(track: Track) {
        for (i,item) in self.tracks.enumerated() {
            if item.trackId == track.trackId {
                self.tracks.remove(at: i)
            }
        }
    }
    
    func shuffle() {
        
    }
}
