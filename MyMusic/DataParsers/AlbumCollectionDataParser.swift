//
//  AlbumCollectionDataParser.swift
//  MyMusic
//
//  Created by Hari Krishna Bista on 2/5/18.
//  Copyright © 2018 meroapp. All rights reserved.
//

import UIKit

class AlbumCollectionDataParser {
    func parseAlbumCollection(data:Data?,resp:URLResponse?,err:Error?) -> AlbumCollection? {
        
        if let err = err {
            print(err.localizedDescription)
            return nil
        }
        
        guard let data = data else {
            return nil
        }
        
        do{
            let jsonData = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
            
            if let feed = jsonData?.value(forKey: "feed") as? NSDictionary{
                
                let data = try JSONSerialization.data(withJSONObject: feed, options: JSONSerialization.WritingOptions.prettyPrinted)
                
                return try JSONDecoder().decode(AlbumCollection.self, from: data)
            }
            
            return nil
            
        } catch let jsonError {
            print("jsonError: \(jsonError)")
            return nil
        }
    }
}
