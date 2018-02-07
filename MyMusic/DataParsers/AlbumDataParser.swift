//
//  AlbumDataParser.swift
//  MyMusic
//
//  Created by Hari Krishna Bista on 2/4/18.
//  Copyright © 2018 meroapp. All rights reserved.
//

import UIKit

class AlbumDataParser {
    func parseAlbum(data:Data?,resp:URLResponse?,err:Error?) -> [Track]? {
        
        if let err = err {
            print(err.localizedDescription)
            return nil
        }
        
        guard let data = data else {
            return nil
        }
        
        do{
            let jsonData = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary

            if let tracksArrOfDict = jsonData?.value(forKey: "results") as? [NSDictionary]{
                
                var tracksArr = tracksArrOfDict
                tracksArr.remove(at: 0)
                
                let tracksData = try JSONSerialization.data(withJSONObject: tracksArr, options: JSONSerialization.WritingOptions.prettyPrinted)
                
                let tracks = try JSONDecoder().decode([Track].self, from: tracksData)
                
                for item in tracks{
                    item.rating = 0.0
                    item.playCount = 0
                    item.isPlaying = false
                    item.isMyMusic = false 
                }
                
                return tracks
            }
            
            return nil
            
        } catch let jsonError {
            print("jsonError: \(jsonError)")
            return nil
        }
    }
}
