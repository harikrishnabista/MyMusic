//
//  AlbumCollection.swift
//  MyMusic
//
//  Created by Hari Krishna Bista on 2/4/18.
//  Copyright © 2018 meroapp. All rights reserved.
//

import UIKit

class AlbumCollection: NSObject,Codable {
    var albums:[Album] = []
    var title:String = "Unknown"
    
    enum CodingKeys: String, CodingKey {
        case albums = "results"
    }
}
