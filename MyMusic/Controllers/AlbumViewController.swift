//
//  AlbumViewController.swift
//  MyMusic
//
//  Created by Hari Krishna Bista on 2/4/18.
//  Copyright © 2018 meroapp. All rights reserved.
//

import UIKit

class AlbumViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var album:Album!
    
    @IBOutlet weak var TopConstraintTableView: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
//        self.TopConstraintTableView.constant = -94
        
//        if let navBarHeight = self.navigationController?.navigationBar.bounds.size.height {

//        }

//        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
//        self.navigationController?.navigationBar.shadowImage = UIImage()
//        self.navigationController?.navigationBar.isTranslucent = true
//        self.navigationController?.view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        
        downloadAlbumDetail()
    }
    
    func downloadAlbumDetail() {
        
        guard let url = URL(string:Constants.ALBUM_DETAIL_BASE_URL + album.id + "&entity=song") else {
            return
        }
        
        ApiCaller().getDataFromUrl(url: url) { (data, resp, err) in
            DispatchQueue.main.async {
                self.album.tracks = AlbumDataParser().parseAlbum(data: data, resp: resp, err: err)
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return album.tracks?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
//        if indexPath.section == 0 {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "SpaceTableViewCell", for: indexPath)
//            return cell
//        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TrackTableViewCell", for: indexPath) as! TrackTableViewCell
        
        if let track = album.tracks?[indexPath.row] {
            cell.lblTitle.text = track.trackName
            cell.lblSubTitle.text = track.collectionName
            cell.lblSubSubTitle.text = track.artistName
        }
//        if let track = album.tracks![indexPath.row]{
//            cell.lblTitle.text = track.
//        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if indexPath.section == 0 {
//            return self.tableView.bounds.size.width
//        }
        
        return 97.0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("Memory warning triggered !!!")
    }
}
