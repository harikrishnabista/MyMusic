//
//  MyMusic.swift
//  MyMusic
//
//  Created by Hari Krishna Bista on 2/4/18.
//  Copyright © 2018 meroapp. All rights reserved.
//

import UIKit

protocol MusicCollection {
    
    var tracks:[Track] { get set }
    func addToList(track:Track)
    func removeFromList(track:Track)
    func shuffle()
    
}

class MyMusic: NSObject, MusicCollection {
    
    var tracks:[Track] = []
    
    func addToList(track: Track) {
        self.tracks.append(track)
    }
    
    func removeFromList(track: Track) {
        if let index = self.tracks.index(of: track) {
            self.tracks.remove(at: index)
        }
    }
    
    func shuffle() {
        
    }

}
