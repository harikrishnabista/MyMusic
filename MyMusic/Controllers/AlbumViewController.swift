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
    
    @IBOutlet weak var btnPlay: UIButton!
    @IBOutlet weak var lblSubtitleAlbum: UILabel!
    @IBOutlet weak var lblTitleAlbum: UILabel!
    @IBOutlet weak var TopConstraintTableView: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    
    lazy var imageDownloadTasks:[String:URLSessionTask] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        // subscribe for the AudioPlayer nowplaying updated
        NotificationCenter.default.addObserver(self, selector: #selector(NowPlayingView.nowPlayingUpdated), name: NSNotification.Name(rawValue: Constants.NotificationName.NOW_PLAYING_UPDATED), object: nil)
        
        self.navigationController?.navigationBar.isHidden = true
        
        self.imgAlbum.setImageWithUrl(urlStr: album.artworkUrl100, placeHolderImageName: "iconMusic")
        
        lblTitleAlbum.text = album.name
        lblSubtitleAlbum.text = album.artistName

        downloadAlbumDetail()
    }
    
    @objc func nowPlayingUpdated() {
        guard let nowPlaying = AudioPlayer.shared.getNowPlaying() else {
            return
        }

        if AudioPlayer.shared.isPlaying{
            self.btnPlay.setImage(UIImage(named:"iconPause"), for: .normal)
        }else{
            self.btnPlay.setImage(UIImage(named:"iconPlay"), for: .normal)
        }
        
        guard let tracks = album.tracks else{
            return
        }
        
        for (i,item) in tracks.enumerated() {
            if nowPlaying.trackId == item.trackId {
                
                // select update
                let indexPath = IndexPath(row: i, section: 0)
                if let cell = tableView.cellForRow(at: indexPath){
                    tableView.reloadRows(at: [indexPath], with: .none)
                }
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
    }
    
    @IBAction func btnNavBackTapped(_ sender: Any) {
        self.navigationController?.navigationBar.isHidden = false
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
        
        if let nowPlaying = AudioPlayer.shared.getNowPlaying(), album.name == nowPlaying.collectionName{
            if AudioPlayer.shared.isPlaying {
                AudioPlayer.shared.pause()
            }else{
                AudioPlayer.shared.play()
            }
        }else{
            // if it does not have any items playing then play first item in the album
            // // emulate deselectRow
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                if let prevSelCell = tableView.cellForRow(at: selectedIndexPath) as? TrackTableViewCell {
                    prevSelCell.btnPlay.setImage(UIImage(named:"iconPlayGreen"), for: .normal)
                }
                tableView.deselectRow(at: selectedIndexPath, animated: false)
            }
            
            // emulate didselected
            let playIndex = 0
            let indexPath = IndexPath(row: playIndex, section: 0)
            tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
            
            if let cell = tableView.cellForRow(at: indexPath) as? TrackTableViewCell {
                handleAudioActionForCell(cell: cell, playIndex: playIndex)
            }
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "TrackTableViewCell", for: indexPath) as! TrackTableViewCell
        
        cell.selectionStyle = .none

        cell.viewContainer.layer.borderColor = UIColor.init(red: 212/255, green: 212/255, blue: 212/255, alpha: 1.0).cgColor
        
        if let track = album.tracks?[indexPath.row] {
            cell.lblTitle.text = track.trackName
            cell.lblSubTitle.text = track.collectionName
            cell.lblSubSubTitle.text = track.artistName
            
            if let downloadTask = cell.imgTrack.setImageWithUrl(urlStr: track.artworkUrl100, placeHolderImageName: "iconMusic"){
                self.imageDownloadTasks[track.artworkUrl100] == downloadTask
            }
            
            if let nowPlaying = AudioPlayer.shared.playerMetaData.getCurrentTrack(), track.trackId == nowPlaying.trackId, AudioPlayer.shared.isPlaying == true {
                cell.btnPlay.setImage(UIImage(named:"iconPauseGreen"), for: .normal)
                tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
            }else{
                cell.btnPlay.setImage(UIImage(named:"iconPlayGreen"), for: .normal)
            }
            
            cell.btnPlay.tag = indexPath.row
            cell.btnPlay.addTarget(self, action: #selector(AlbumViewController.btnPlayCellTapped(sender:)), for: .touchUpInside)
        }

        return cell
    }
    
    @objc func btnPlayCellTapped(sender : UIButton){

        // deselect update
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selectedIndexPath, animated: false)
            if let cell = tableView.cellForRow(at: selectedIndexPath) as? TrackTableViewCell{
                updateDeSelectedCell(cell: cell)
            }
        }
        
        let indexPath = IndexPath(row: sender.tag, section: 0)
        
        if let cell = tableView.cellForRow(at: indexPath) as? TrackTableViewCell {
            handleAudioActionForCell(cell: cell, playIndex: indexPath.row)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? TrackTableViewCell {
            handleAudioActionForCell(cell: cell, playIndex: indexPath.row)
        }
    }
    
    func handleAudioActionForCell(cell:TrackTableViewCell,playIndex:Int) {
        guard let tracks = album.tracks, tracks.count > 0 else {
            return
        }
        let track = tracks[playIndex]
        
        if let nowPlaying = AudioPlayer.shared.playerMetaData.getCurrentTrack(), track.trackId == nowPlaying.trackId, AudioPlayer.shared.isPlaying == true {
                AudioPlayer.shared.pause()
        }else{
            AudioPlayer.shared.setPlaylist(newPlayList: tracks, playIndex: playIndex)
        }
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // stop the download task if it is still running because we mo more need this image as cell wont be visible
        let track = self.album.tracks![indexPath.row]
        if let downloadTask = self.imageDownloadTasks[track.artworkUrl100]{
            if downloadTask.state == URLSessionTask.State.running {
                downloadTask.cancel()
            }
            self.imageDownloadTasks.removeValue(forKey: track.artworkUrl100)
        }
    }
    
    func updateDeSelectedCell(cell:TrackTableViewCell){
        cell.btnPlay.setImage(UIImage(named:"iconPlayGreen"), for: .normal)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? TrackTableViewCell{
            updateDeSelectedCell(cell: cell)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("Memory warning triggered !!!")
    }
}
