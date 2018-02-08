//
//  MainViewController.swift
//  MyMusic
//
//  Created by Hari Krishna Bista on 2/7/18.
//  Copyright © 2018 meroapp. All rights reserved.
//

import UIKit

class MainViewController: UINavigationController {
    
    weak var nowPlaying:NowPlayingView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setup for navi
        let nowPlayingView = NowPlayingView(delegate: self)
        self.view.addSubview(nowPlayingView)
        
        nowPlayingView.translatesAutoresizingMaskIntoConstraints = false;
        
        let left = nowPlayingView.leftAnchor.constraint(equalTo:(nowPlayingView.superview?.leftAnchor)!)
        let right = nowPlayingView.rightAnchor.constraint(equalTo:(nowPlayingView.superview?.rightAnchor)!)
        let bottom = nowPlayingView.bottomAnchor.constraint(equalTo:(nowPlayingView.superview?.bottomAnchor)!)
        
        let height = nowPlayingView.heightAnchor.constraint(equalToConstant:60)
        
        left.isActive = true
        right.isActive = true
        bottom.isActive = true
        height.isActive = true

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
