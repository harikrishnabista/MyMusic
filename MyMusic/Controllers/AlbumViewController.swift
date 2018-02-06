//
//  AlbumViewController.swift
//  MyMusic
//
//  Created by Hari Krishna Bista on 2/4/18.
//  Copyright © 2018 meroapp. All rights reserved.
//

import UIKit

class FakeView: UIView {
    
}

class PassThroughTableView: UITableView {
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        // logic is to check if this point is inside fakeview or not
        // if yes pass the event through the event so that underneath UI element can receive the event
        for subview in subviews {
            if type(of: subview) == FakeView.self {
                if subview.frame.contains(point) {
                    return false
                }
            }
        }
        return true
    }
}

class AlbumViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var imgAlbum: UIImageView!
    var album:Album!
    
    @IBOutlet weak var lblSubtitleAlbum: UILabel!
    @IBOutlet weak var lblTitleAlbum: UILabel!
    @IBOutlet weak var TopConstraintTableView: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        self.navigationController?.navigationBar.isHidden = true
        
        if let downloadTask = self.imgAlbum.setImageWithUrl(urlStr: album.artworkUrl100, placeHolderImageName: "iconMusic") {
//            self.image
        }
        
        lblTitleAlbum.text = album.name
        lblSubtitleAlbum.text = album.artistName

        downloadAlbumDetail()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    @IBAction func btnNavBackTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
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
    
    @IBAction func btnAddMusicTapped(_ sender: Any) {
        print("add music tapped.")
    }
    
    @IBAction func btnMoreTapped(_ sender: Any) {
    }
    @IBAction func btnDownloadAlbumTapped(_ sender: Any) {
    }
    
    @IBAction func btnShareAlbumTapped(_ sender: Any) {
    }
    
    @IBAction func btnPlayAlbumTapped(_ sender: Any) {
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "TrackTableViewCell", for: indexPath) as! TrackTableViewCell
        
        if let track = album.tracks?[indexPath.row] {
            cell.lblTitle.text = track.trackName
            cell.lblSubTitle.text = track.collectionName
            cell.lblSubSubTitle.text = track.artistName
            
            cell.imgTrack.setImageWithUrl(urlStr: track.artworkUrl100, placeHolderImageName: "iconMusic")
        }
//        if let track = album.tracks![indexPath.row]{
//            cell.lblTitle.text = track.
//        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("Memory warning triggered !!!")
    }
}