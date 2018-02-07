//
//  User.swift
//  MyMusic
//
//  Created by Hari Krishna Bista on 2/5/18.
//  Copyright © 2018 meroapp. All rights reserved.
//

import UIKit

class User: NSObject {
    public static var shared = User()
    
    var username: String = "Unknown"
    var name: String = "Unknown"
    var userId: Int64 = -1
    
    var recentlyPlayed = RecentlyPlayed()
    var myMusic = MyMusic()
    
    private override init(){
        // as soon as it starts playing add to recently playlist
    }
}
