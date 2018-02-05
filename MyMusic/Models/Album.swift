//
//  Album.swift
//  MyMusic
//
//  Created by Hari Krishna Bista on 2/4/18.
//  Copyright © 2018 meroapp. All rights reserved.
//

import UIKit

class Album: NSObject, Codable {
    var id:String
    var name:String
    
    var releaseDate:String = "Unknown"
    
    var copyright:String = "Unknown"
    
    var artworkUrl100:String = "Unknown"
    var url:String = "Unknown"
    
    var artistId:String = "Unknown"
    var artistName:String = "Unknown"
    var artistUrl:String = "Unknown"
    
    var tracks:[Track]?
 
    init(id:String, name:String) {
        self.id = id
        self.name = name
        super.init()
    }
    
    convenience override init() {
        self.init()
    }

//    enum CodingKeys: String, CodingKey {
//        case tracks = "results"
//    }
}

//{
//    "artistName": "Migos",
//    "id": "1340307563",
//    "releaseDate": "2018-01-26",
//    "name": "Culture II",
//    "kind": "album",
//    "copyright": "Quality Control Music / Motown Records / Capitol Records;℗2018 Quality Control Music, LLC and UMG Recordings, Inc.",
//    "artistId": "569925101",
//    "artistUrl": "https://itunes.apple.com/us/artist/migos/569925101?app=music",
//    "artworkUrl100": "http://is1.mzstatic.com/image/thumb/Music118/v4/d7/dc/16/d7dc1630-7d16-b66d-4943-a720bb5f6ec3/UMG_cvrart_00602567359814_01_RGB72_3000x3000_17UM1IM64707.jpg/200x200bb.png",
//    "genres": [
//    {
//    "genreId": "18",
//    "name": "Hip-Hop/Rap",
//    "url": "https://itunes.apple.com/us/genre/id18"
//    },
//    {
//    "genreId": "34",
//    "name": "Music",
//    "url": "https://itunes.apple.com/us/genre/id34"
//    }
//    ],
//    "url": "https://itunes.apple.com/us/album/culture-ii/1340307563?app=music"
//},

