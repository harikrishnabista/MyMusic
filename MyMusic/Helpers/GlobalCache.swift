//
//  GlobalCache.swift
//  MobileGrocery
//
//  Created by Hari Krishna Bista on 2/3/18.
//  Copyright © 2018 meroapp. All rights reserved.
//

import UIKit

class GlobalCache {
    static let shared = GlobalCache()
    var imageCache:[String:UIImage] = [:]
    private init() {
        
    }
}
