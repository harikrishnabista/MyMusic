//
//  HomeViewViewController.swift
//  MyMusic
//
//  Created by Hari Krishna Bista on 2/4/18.
//  Copyright © 2018 meroapp. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UIPageViewControllerDataSource, SlidePanelCallBack {
    
    var pageViewController: UIPageViewController?
    @IBOutlet weak var segControl: UISegmentedControl!
    
    var albumCollection:AlbumCollection?
    
    //required delegate method for SlidePanelCallBack
    func SlidePanelJustHidden() {
        print("just hidden")
    }
    
    var menuView:MenuView!
//    var menuView: MenuView = {
//        return MenuView(delegate: self)
//    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.menuView = MenuView(delegate: self)
        
        // prepare pageViewcontrolelr
        self.pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        
        if let pageViewController = self.pageViewController,  let firstViewCon = self.storyboard?.instantiateViewController(withIdentifier: "MyMusicViewController") as? MyMusicViewController {
            
            pageViewController.setViewControllers([firstViewCon], direction: .forward, animated: false, completion: nil)
            
            pageViewController.dataSource = self
            
            addChildViewController(pageViewController)
            view.addSubview(pageViewController.view)
            pageViewController.didMove(toParentViewController: self)
            
            // adjusting the constraints for added view
            pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
            
            pageViewController.view.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
            pageViewController.view.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
            pageViewController.view.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
            
            
            let bottom = pageViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            
            bottom.isActive = true
            bottom.constant = bottom.constant - 60
            
        } 
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("Memory warning triggered !!!")
    }
    
    @IBAction func btnMenuTapped(_ sender: Any) {
        menuView.ShowSlidePanel(direction: .left, offsetPercentage: 30, animated: true)
    }
    
    @IBAction func segControlValueChanged(_ sender: Any) {
        if self.segControl.selectedSegmentIndex == 0 {
            // open mymusic view controller
            if let myMusicViewControlelr = self.storyboard?.instantiateViewController(withIdentifier: "MyMusicViewController") as? MyMusicViewController {

                pageViewController?.setViewControllers([myMusicViewControlelr], direction: .reverse, animated: true, completion: nil)
            }
        }
        
        if self.segControl.selectedSegmentIndex == 1 {
            // open browse view controller
            if let browseViewController = self.storyboard?.instantiateViewController(withIdentifier: "BrowseViewController") as? BrowseViewController {
                
                browseViewController.albumCollection = albumCollection
                
                pageViewController?.setViewControllers([browseViewController], direction: .forward, animated: true, completion: nil)
                
            }
        }
    }
    
    // MARK: - Page View Controller Data Source
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        return nil
    }
    
//    // segue delegate
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "segueToAlbumViewController", let album = sender as? Album {
//            if let albumViewController = segue.destination as? AlbumViewController {
//                albumViewController.album = album
//            }
//        }
//    }
}
