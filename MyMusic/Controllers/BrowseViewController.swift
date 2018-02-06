//
//  BrowseViewController.swift
//  MyMusic
//
//  Created by Hari Krishna Bista on 2/4/18.
//  Copyright © 2018 meroapp. All rights reserved.
//

import UIKit

class BrowseViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    lazy var imageDownloadTasks:[String:URLSessionTask] = [:]
    
    var albumCollection:AlbumCollection?
    private static let COLL_REUSE_IDENTIFIER = "BrowseItemCollectionViewCell"

    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        
        if self.albumCollection == nil {
            downloadTopAlbums()
        }
    }
    
    func downloadTopAlbums() {
        guard let url = URL(string: Constants.TOP_ALBUMS_API) else {
            return
        }
        
        self.navigationController?.view.showLoading(message: "Loading top albums...")
        ApiCaller().getDataFromUrl(url: url) { (data, resp, err) in
            
            DispatchQueue.main.async {
                
                self.navigationController?.view.hideLoading()
                self.albumCollection = AlbumCollectionDataParser().parseAlbumCollection(data: data, resp: resp, err: err)
                self.collectionView.reloadData()
                
                if let homeViewController = self.parent?.parent as? HomeViewController {
                    homeViewController.albumCollection = self.albumCollection
                }
            }
        }
    }
    
    //UICollectionViewDataSource delegate methods
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        return albumCollection?.albums.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BrowseViewController.COLL_REUSE_IDENTIFIER,
                                                      for: indexPath) as! BrowseItemCollectionViewCell
        
        guard let album = albumCollection?.albums[indexPath.row] else {
            return cell
        }
        
        cell.lblTitle.text = album.name
        cell.lblSubTitle.text = "\(album.getTotalSongs()) tracks"
        
        if let downloadTask = cell.imgItem.setImageWithUrl(urlStr: album.artworkUrl100, placeHolderImageName: "iconMusic") {
            imageDownloadTasks[album.artworkUrl100] = downloadTask
        }
        
        return cell
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // stop and remove all the image downloading tasks
        for task in self.imageDownloadTasks {
            task.value.cancel()
        }
        self.imageDownloadTasks.removeAll()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let album = albumCollection?.albums[indexPath.row] {
            self.performSegue(withIdentifier: "segueToAlbumDetail", sender: album)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.size.width - 10
        
        return CGSize(width: width/2, height: width/2)
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // stop the download task if it is still running because we mo more need this image as cell wont be visible
        if let album = albumCollection?.albums[indexPath.row] {
            self.imageDownloadTasks[album.artworkUrl100]?.cancel()
            self.imageDownloadTasks.removeValue(forKey: album.artworkUrl100)
        }
    }
    
    // segue delegate
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToAlbumDetail", let album = sender as? Album {
            if let albumViewController = segue.destination as? AlbumViewController {
                albumViewController.album = album
            }
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("memory warning triggered")
    }

}
