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
        if let index = self.tracks.index(of: track) {
            self.tracks.remove(at: index)
        }
        
        self.tracks.insert(track, at: 0)
    }
    
    func removeFromList(track: Track) {
        if let index = self.tracks.index(of: track) {
            self.tracks.remove(at: index)
        }
    }
    
    func shuffle() {
        
    }
}
