//
//  MenuView.swift
//  LoadingViewTest
//
//  Created by Hari K Bista on 4/10/17.
//

import UIKit

enum SlidePanelDirection {
    case right
    case left
}

protocol SlidePanelCallBack {
    func SlidePanelJustHidden();
}

class MenuView: UIView,UIGestureRecognizerDelegate {
    
    var NibName:String = "MenuView"
    
    @IBOutlet weak var imgProfile: UIImageView!
    var delegate: SlidePanelCallBack?
    var direction: SlidePanelDirection?
    
    @IBOutlet weak var switchDarkTheme: UISwitch!
    @IBOutlet var view: UIView!
    
    @IBOutlet weak var lblDashBoardStyle: UILabel!
    @IBOutlet weak var btnRemove: UIButton!
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var btnDataSource: UIButton!
    @IBOutlet weak var btnPref: UIButton!
    @IBOutlet weak var lblDarkTheme: UILabel!
    @IBOutlet weak var btnSelfDriving: UIButton!
    @IBOutlet weak var btnLandscape: UIButton!
    @IBOutlet weak var btnPortraint: UIButton!
    @IBOutlet weak var lblUsername: UILabel!
    @IBOutlet weak var slidePanel: UIView!
    @IBOutlet weak var leftOffset: NSLayoutConstraint!
    @IBOutlet weak var rightOffset: NSLayoutConstraint!
    var offsetPercentage:CGFloat = 100;
    
    init(delegate:SlidePanelCallBack) {
        self.delegate = delegate
        super.init(frame: (UIApplication.shared.keyWindow?.frame)!)
        setup();
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        setup();
    }
    
    func setup()
    {
        view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)
        
        // handle tap on out of slide panel
        let tap = UITapGestureRecognizer(target: self, action:#selector(handleTap))
        self.view.addGestureRecognizer(tap)
        tap.delegate = self;
        
        // handle swipe on slide panel
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeRight.direction = .right
        self.view.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeLeft.direction = .left;
        self.view.addGestureRecognizer(swipeLeft)
        
        // register device orientation notification
        NotificationCenter.default.addObserver(
            self, selector:#selector(self.DeviceOrientationDidChange),name: NSNotification.Name.UIDeviceOrientationDidChange,
            object: nil);
        
        //
        self.imgProfile.layer.cornerRadius = self.imgProfile.frame.size.height/2

    }
    
    func loadViewFromNib() -> UIView
    {
        let bundle = Bundle(for:type(of: self))
        let nib = UINib(nibName: self.NibName, bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        
        return view;
    }
    
    @IBAction func switchValueChanged(_ sender: UISwitch) {
 
    }
    
    @IBAction func btnSelfDrivingTapped(_ sender: Any) {

    }
    

    func applyDarkTheme() {
        
    }
    
    func ShowSlidePanel(direction: SlidePanelDirection, offsetPercentage:CGFloat, animated:Bool) {
        self.offsetPercentage = offsetPercentage;
        self.direction = direction;

        let parentViewFrame = (self.delegate as! UIViewController).view.layer.frame;
        
        self.frame = parentViewFrame
        
        let offset = parentViewFrame.width*self.offsetPercentage/100;
        
        if let parentView = (self.delegate as? UIViewController)?.navigationController?.view {
            parentView.addSubview(self);
            self.applyConstraint(parentView: parentView);
        }
        
        if(animated){
            // set the position of menu and its slidePanel to initial position prepare to animate in
            
            if(direction == .left){
                self.leftOffset.constant = -parentViewFrame.size.width
                self.rightOffset.constant = parentViewFrame.size.width + offset
            }
            
            if(direction == .right){
                self.leftOffset.constant = parentViewFrame.size.width + offset
                self.rightOffset.constant = -parentViewFrame.size.width
            }
            
            self.layoutIfNeeded()

            UIView.animate(withDuration: 0.40, delay: 0.0, options: [], animations: {
                
                if(direction == .left){
                    self.leftOffset.constant = 0
                    self.rightOffset.constant = offset;
                }
                
                if(direction == .right){
                    self.leftOffset.constant = offset
                    self.rightOffset.constant = 0
                }
                
                self.layoutIfNeeded()
                
            }, completion: nil);
        }else{
            
            if(direction == .left){
                self.rightOffset.constant = offset;
            }
            
            if(direction == .right){
                self.leftOffset.constant = offset;
            }
            
            self.view.layoutIfNeeded()

        }
    }
    
    func applyConstraint(parentView:UIView) {
        // adjusting the constraint for recently added uiimageview for backGround
        self.translatesAutoresizingMaskIntoConstraints = false
        
        let top = NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: parentView, attribute: .top, multiplier: 1, constant: 0)
        let trailing = NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: parentView, attribute: .trailing, multiplier: 1, constant: 0)
        
        let bottom = NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: parentView, attribute: .bottom, multiplier: 1, constant: 0)
        let leading = NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: parentView, attribute: .leading, multiplier: 1, constant: 0)
        
        NSLayoutConstraint.activate([top, trailing,bottom,leading])
    }
    
    func HideSlidePanel(animated:Bool) {
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIDeviceOrientationDidChange,object: nil);
        
        if(animated){
            UIView.animate(withDuration: 0.40, delay: 0.0, options: [], animations: {
//                self.alpha = 0.0;
                if(self.direction == .left){
                    self.slidePanel.frame = CGRect(x: 0, y: 0, width: -self.frame.size.width, height: self.frame.size.height);
                }
                
                if(self.direction == .right){
                    self.slidePanel.frame = CGRect(x: self.frame.size.width + self.frame.width*self.offsetPercentage/100, y: 0, width: self.frame.size.width, height: self.frame.size.height);
                }
                
            }, completion: { (finished: Bool) in
                self.removeFromSuperview();
                
                if let delegate = self.delegate {
                    delegate.SlidePanelJustHidden();
                }
            });
        }else{
            self.removeFromSuperview();
            if let delegate = self.delegate {
                delegate.SlidePanelJustHidden();
            }
        }
    }

    @objc func DeviceOrientationDidChange() {
        let offset = self.view.frame.width*offsetPercentage/100;
        
        if(direction == .left){
            self.rightOffset.constant = offset;
        }
        
        if(direction == .right){
            self.leftOffset.constant = offset;
        }
        
        self.layoutIfNeeded();
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if(touch.view?.isDescendant(of: self.slidePanel))!{
            return false;
        }
        
        return true;
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer? = nil) {
        self.HideSlidePanel(animated: true);
        
        //        if(sender?.view == se)
    }
    
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.right:
                if(self.direction == .right){
                    HideSlidePanel(animated: true);
                }
            case UISwipeGestureRecognizerDirection.left:
                if(self.direction == .left){
                    HideSlidePanel(animated: true);
                }
            case UISwipeGestureRecognizerDirection.down:
                print("Swiped down")
            case UISwipeGestureRecognizerDirection.up:
                print("Swiped up")
            default:
                break
            }
        }
    }
    
    
    
    @IBAction func btnLogOutTapped(_ sender: Any) {

    }
    
    @IBAction func btnPortraitTapped(_ sender: UIButton) {
        
    }
    
    @IBAction func btnLandscapeTapped(_ sender: UIButton) {
        
    }
    
    @IBOutlet weak var btnLandscapeTapped: UIButton!
}
