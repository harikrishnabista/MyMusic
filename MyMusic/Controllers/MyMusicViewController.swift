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

class MyMusicViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
//    var recentlyPlayer:RecentlyPlayed = RecentlyPlayed()
//    var myMusic:MyMusic = MyMusic()
    
    lazy var imageDownloadTasks:[String:URLSessionTask] = [:]
    
    @IBOutlet weak var lblMessage: UILabel!
    
    var sectionHeaderTitles = ["RECENTLY PLAYED", "MY MUSIC"]

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        // subscribe for the AudioPlayer nowplaying updated
        NotificationCenter.default.addObserver(self, selector: #selector(NowPlayingView.nowPlayingUpdated), name: NSNotification.Name(rawValue: Constants.NotificationName.NOW_PLAYING_UPDATED), object: nil)
    }
    
    @objc func nowPlayingUpdated() {
        guard let nowPlaying = AudioPlayer.shared.getNowPlaying() else {
            return
        }
        
        // for my music
        for (i,item) in User.shared.myMusic.tracks.enumerated() {
            if nowPlaying.trackId == item.trackId {
                // update uitableviewcell for now playing
                let indexPath = IndexPath(row: i, section: 1)
                if let cell = tableView.cellForRow(at: indexPath){
                    tableView.reloadRows(at: [indexPath], with: .none)
                }
                break
            }
        }
        
        // for recently played music
        
        if let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? RecentTableViewCell{
            //                    cell.collectionView.reloadItems(at: [IndexPath(row: i, section: 0)])
            cell.collectionView.reloadData()
        }
        
//        for (i,item) in User.shared.recentlyPlayed.tracks.enumerated() {
//            if nowPlaying.trackId == item.trackId {
//                // update uicollectionviewcell for now playing
//
//                break
//            }
//        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData()
        if User.shared.myMusic.tracks.count > 0 {
            lblMessage.isHidden = true
        }else{
            lblMessage.isHidden = false
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /******************************* TableView section **********************************/
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2;
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: Double(tableView.bounds.width), height:Double(tableView.sectionHeaderHeight)))
        
        headerView.backgroundColor = UIColor.white
        
        let label = UILabel(frame: headerView.frame)
        
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 13.0)
        
        label.text = sectionHeaderTitles[section]

        headerView.addSubview(label)

        label.translatesAutoresizingMaskIntoConstraints = false;

        let left = label.leftAnchor.constraint(equalTo:headerView.leftAnchor)
        left.constant = 15
        left.isActive = true
        
        label.centerYAnchor.constraint(equalTo: headerView.centerYAnchor).isActive = true
        
        // add shuffle button in right of headerview
//        let btnShuffle = UIButton()
//        headerView.addSubview(btnShuffle)
//        btnShuffle.translatesAutoresizingMaskIntoConstraints = false
//        btnShuffle.tintColor = UIColor.gre
        
//        let rightBtnShuffle = btnShuffle.rightAnchor.constraint(equalTo:headerView.rightAnchor)
//        rightBtnShuffle.isActive = true
//        rightBtnShuffle.constant = -15
//
//        btnShuffle.centerYAnchor.constraint(equalTo:headerView.centerYAnchor).isActive = true
//        btnShuffle.setImage(UIImage(named:"iconShuffleGreen"), for: .normal)
//
//        btnShuffle.tag = section
//        btnShuffle.addTarget(self, action: #selector(MyMusicViewController.btnShuffleTapped(sender:)), for: .touchUpInside)

        headerView.layoutIfNeeded();
        
        return headerView
    }
    
    @objc func btnShuffleTapped(sender : UIButton){
        AudioPlayer.shared.setPlaylist(newPlayList: User.shared.myMusic.tracks, playIndex: sender.tag)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        
        return User.shared.myMusic.tracks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if(indexPath.section == 0){
            let cell = tableView.dequeueReusableCell(withIdentifier: "RecentTableViewCell", for: indexPath) as! RecentTableViewCell
            
            cell.collectionView.delegate = self
            cell.collectionView.dataSource = self
            
            cell.selectionStyle = .none
            
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "TrackTableViewCell", for: indexPath) as! TrackTableViewCell
            
            let track = User.shared.myMusic.tracks[indexPath.row]
            
            cell.selectionStyle = .none
            
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
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        handleAudioActionForTracks(tracks: User.shared.recentlyPlayed.tracks, playIndex: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? TrackTableViewCell {
            cell.btnPlay.setImage(UIImage(named:"iconPlayGreen"), for: .normal)
        }
    }
    
    func handleAudioActionForTracks(tracks:[Track],playIndex:Int) {
        guard tracks.count > 0 else {
            return
        }
        
        let track = tracks[playIndex]
        
        if let nowPlaying = AudioPlayer.shared.playerMetaData.getCurrentTrack(), track.trackId == nowPlaying.trackId, AudioPlayer.shared.isPlaying == true {
            AudioPlayer.shared.pause()
        }else{
            AudioPlayer.shared.setPlaylist(newPlayList: tracks, playIndex: playIndex)
        }
    }
    
    @objc func btnPlayCellTapped(sender : UIButton){
        
        // deselect update
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selectedIndexPath, animated: false)
            if let cell = tableView.cellForRow(at: selectedIndexPath) as? TrackTableViewCell{
                updateDeSelectedCell(cell: cell)
            }
        }
        
        let indexPath = IndexPath(row: sender.tag, section: 1)
        handleAudioActionForTracks(tracks: User.shared.myMusic.tracks, playIndex: indexPath.row)
    }
    
    func updateDeSelectedCell(cell:TrackTableViewCell){
        cell.btnPlay.setImage(UIImage(named:"iconPlayGreen"), for: .normal)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return self.tableView.frame.size.width/2
        }
        return 100.0
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // stop the download task if it is still running because we mo more need this image as cell wont be visible
        if User.shared.myMusic.tracks.count > 0 {
            let track = User.shared.myMusic.tracks[indexPath.row]
            if let downloadTask = self.imageDownloadTasks[track.artworkUrl100]{
                if downloadTask.state == URLSessionTask.State.running {
                    downloadTask.cancel()
                }
                self.imageDownloadTasks.removeValue(forKey: track.artworkUrl100)
            }
        }
    }
        
    /******************************* Collectionview section **********************************/
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return User.shared.recentlyPlayed.tracks.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecentCollectionViewCell",
                                                      for: indexPath) as! RecentCollectionViewCell
        
        let track = User.shared.recentlyPlayed.tracks[indexPath.row]
    
        cell.btnPlay.setImage(UIImage(named:"iconPlayGreen"), for: .normal)
        
        cell.lblTitle.text = track.trackName
        cell.lblSubtitle.text = track.artistName
        cell.imgTrack.setImageWithUrl(urlStr: track.artworkUrl100, placeHolderImageName: "iconMusic")
        
        if let nowPlaying = AudioPlayer.shared.playerMetaData.getCurrentTrack(), track.trackId == nowPlaying.trackId, AudioPlayer.shared.isPlaying == true {
            cell.btnPlay.setImage(UIImage(named:"iconPauseGreen"), for: .normal)
        }else{
            cell.btnPlay.setImage(UIImage(named:"iconPlayGreen"), for: .normal)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? RecentCollectionViewCell else{
            return
        }
        
        handleAudioActionForTracks(tracks: User.shared.recentlyPlayed.tracks, playIndex: indexPath.row)
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
        print("didDeselectItemAt")
        
        if let cell = collectionView.cellForItem(at: indexPath) as? RecentCollectionViewCell {
            cell.btnPlay.setImage(UIImage(named:"iconPlayGreen"), for: .normal)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = collectionView.bounds.size.width
        
        return CGSize(width: width/2, height: width/2)
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
    }
    
    // segue delegate
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToAlbumDetail", let album = sender as? Album {
            if let albumViewController = segue.destination as? AlbumViewController {
                albumViewController.album = album
            }
        }
    }
}
