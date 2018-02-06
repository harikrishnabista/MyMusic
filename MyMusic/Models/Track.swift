//
//  Track.swift
//  MyMusic
//
//  Created by Hari Krishna Bista on 2/4/18.
//  Copyright © 2018 meroapp. All rights reserved.
//

import UIKit

class TrackMetaData: Codable {
    // computed properties
    var rating:Double = 0.0
    var playCount:Int = 0
    var isPlaying:Bool = false
    var isFavorite:Bool = false
}

class Track: NSObject, Codable {
    
    var trackId:Int64
    var trackName: String
    
    var artistId:Int64 = 0
    var artistName:String = "Unknown"
    var collectionId:Int64 = 0
    var collectionName:String = "Unknown"

    var artistViewUrl:String = "Unknown"
    var trackViewUrl:String = "Unknown"
    var previewUrl:String = "Unknown"
    var artworkUrl100:String = "Unknown"
    
    var collectionPrice:Double = 0.0
    var trackPrice:Double = 0.0
    
    func getTrackPriceLabel() -> String {
        return "Track: $\(trackPrice)"
    }
    
    func getCollectionPriceLabel() -> String {
        return "Collection: $\(collectionPrice)"
    }
    
    var releaseDate:String = "Unknown"
    var trackTimeMillis:Int64 = 0
    
    var country:String = "Unknown"
    var primaryGenreName:String = "Unknown"
    var isStreamable:Bool = false
    
    var metaData:TrackMetaData?

    init(id:Int64, name:String) {
        self.trackId = id
        self.trackName = name
        super.init()
    }
    
//    convenience override init() {
//        self.init()
//    }
}

//{
//    "wrapperType": "track",
//    "kind": "song",
//    "artistId": 398128,
//    "collectionId": 1330759954,
//    "trackId": 1330759960,
//    "artistName": "Justin Timberlake",
//    "collectionName": "Man of the Woods",
//    "trackName": "Filthy",
//    "collectionCensoredName": "Man of the Woods",
//    "trackCensoredName": "Filthy",
//    "artistViewUrl": "https://itunes.apple.com/us/artist/justin-timberlake/398128?uo=4",
//    "collectionViewUrl": "https://itunes.apple.com/us/album/filthy/1330759954?i=1330759960&uo=4",
//    "trackViewUrl": "https://itunes.apple.com/us/album/filthy/1330759954?i=1330759960&uo=4",
//    "previewUrl": "https://audio-ssl.itunes.apple.com/apple-assets-us-std-000001/AudioPreview62/v4/c3/79/df/c379df0b-6445-67a1-1ea5-66905a0bca22/mzaf_3048787309838481466.plus.aac.p.m4a",
//    "artworkUrl30": "http://is2.mzstatic.com/image/thumb/Music118/v4/0a/88/b3/0a88b3d8-d969-dc15-83d5-9be41756e1ab/source/30x30bb.jpg",
//    "artworkUrl60": "http://is2.mzstatic.com/image/thumb/Music118/v4/0a/88/b3/0a88b3d8-d969-dc15-83d5-9be41756e1ab/source/60x60bb.jpg",
//    "artworkUrl100": "http://is2.mzstatic.com/image/thumb/Music118/v4/0a/88/b3/0a88b3d8-d969-dc15-83d5-9be41756e1ab/source/100x100bb.jpg",
//    "collectionPrice": 12.99,
//    "trackPrice": 0.69,
//    "releaseDate": "2018-01-05T08:00:00Z",
//    "collectionExplicitness": "notExplicit",
//    "trackExplicitness": "notExplicit",
//    "discCount": 1,
//    "discNumber": 1,
//    "trackCount": 16,
//    "trackNumber": 1,
//    "trackTimeMillis": 293959,
//    "country": "USA",
//    "currency": "USD",
//    "primaryGenreName": "Pop",
//    "isStreamable": true
//},

