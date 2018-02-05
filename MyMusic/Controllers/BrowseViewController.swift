//
//  BrowseViewController.swift
//  MyMusic
//
//  Created by Hari Krishna Bista on 2/4/18.
//  Copyright © 2018 meroapp. All rights reserved.
//

import UIKit

class BrowseViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
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
        cell.lblSubTitle.text = album.artistName
        
        if let cacheImage = GlobalCache.shared.imageCache[album.artworkUrl100] {
            DispatchQueue.main.async {
                cell.imgItem.image = cacheImage
            }
        }else{
            cell.imgItem.image = UIImage(named: "iconMusic")
            
            if let imgUrl = URL(string:album.artworkUrl100) {
                ApiCaller().getImageFrom(url: imgUrl, completion: { (downloadedImage) in
                    if let downloadedImage = downloadedImage {
                        DispatchQueue.main.async {
                            GlobalCache.shared.imageCache[album.artworkUrl100] = downloadedImage
                            cell.imgItem.image = downloadedImage
                        }
                    }
                })
            }
        }
 
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let homeViewController = self.parent?.parent as? HomeViewController {
            if let album = albumCollection?.albums[indexPath.row] {
                homeViewController.performSegue(withIdentifier: "segueToAlbumViewController", sender: album)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.size.width - 10
        
        return CGSize(width: width/2, height: width/2)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("memory warning triggered")
    }

}
