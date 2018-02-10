//
//  DigitalWatch.swift
//  MyMusic
//
//  Created by Hari Krishna Bista on 2/9/18.
//  Copyright © 2018 meroapp. All rights reserved.
//

import UIKit

struct StopWatch {
    
    var totalSeconds: Int
    
    var years: Int {
        return totalSeconds / 31536000
    }
    
    var days: Int {
        return (totalSeconds % 31536000) / 86400
    }
    
    var hours: Int {
        return (totalSeconds % 86400) / 3600
    }
    
    var minutes: Int {
        return (totalSeconds % 3600) / 60
    }
    
    var seconds: Int {
        return totalSeconds % 60
    }
    
    //simplified to what OP wanted
    var hoursMinutesAndSeconds: (hours: Int, minutes: Int, seconds: Int) {
        return (hours, minutes, seconds)
    }
}

extension StopWatch {
    
    var simpleTimeString: String {
        let hoursText = timeText(from: hours)
        let minutesText = timeText(from: minutes)
        let secondsText = timeText(from: seconds)
        
        if(hoursText == "00"){
            return "\(minutesText):\(secondsText)"
        }else{
            return "\(hoursText):\(minutesText):\(secondsText)"
        }
    }
    
    private func timeText(from number: Int) -> String {
        return number < 10 ? "0\(number)" : "\(number)"
    }
}
