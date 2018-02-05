//
//  MyMusicViewController.swift
//  MyMusic
//
//  Created by Hari Krishna Bista on 2/4/18.
//  Copyright © 2018 meroapp. All rights reserved.
//

import UIKit

//enum MyMusicTableViewCellType {
//    case RECENTLY_PLAYED
//    case TRACK
//}

class MyMusicViewController: UIViewController, UITableViewDataSource {
    
    var recentlyPlayer:RecentlyPlayed = RecentlyPlayed()
    var myMusic:MyMusic = MyMusic()
    
    var sectionHeaderTitles = ["RECENTLY PLAYED", "ADDED TO MY MYSIC"]

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
    }
    
    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionHeaderTitles.count
    }
    
    private func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: Double(tableView.bounds.width), height: Double(tableView.sectionHeaderHeight)))
        
//        headerView.backgroundColor = Constants.Color.headerGrayBg
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18.0)
//        label.textColor = Constants.Color.themeGrayColor
        
        label.text = sectionHeaderTitles[section]
        
        headerView.addSubview(label)
        
        label.translatesAutoresizingMaskIntoConstraints = false;
        
        label.centerXAnchor.constraint(equalTo: headerView.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: headerView.centerYAnchor).isActive = true
        
        headerView.layoutIfNeeded();
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myMusic.tracks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if(indexPath.section == 0){
            let cell = tableView.dequeueReusableCell(withIdentifier: "RecentlyPlayedTableViewCell", for: indexPath) as! RecentlyPlayedTableViewCell
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyMusicTableViewCell", for: indexPath) as! MyMusicTableViewCell
            
            return cell
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
