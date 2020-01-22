//
//  ViewController.swift
//  MCH
//
//  Created by Akshay Gawade on 18/11/19.
//  Copyright © 2019 Akshay Gawade. All rights reserved.
//

import UIKit

extension UIView {
    func roundCorners(corners: UIRectCorner = [.topLeft, .topRight, .bottomLeft, .bottomRight ], radius: CGFloat = 5.0) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
        self.layoutIfNeeded()
    }
    
    static func fontHeight(height:CGFloat) -> CGFloat {
        let ratio = height / 414
        return (ratio * (UIScreen.main.bounds.width))
    }
}

class ViewController: UIViewController {
    let mchNavigationBar = MCHNavigationBar.init()
    let titlefont : CGFloat = 45.0
    let subtitleFont : CGFloat = 18.0
    let btnFont : CGFloat = 15.0
    let FooterFont : CGFloat = 12.0
    let storyboardIds = Constants.StoryboardId.self
    var screenWidth : CGFloat?
    var screenHeight : CGFloat?
    var sideMenu: HamburgerView?
    var showMenu : Bool = false {
        didSet{
            if self.sideMenu != nil {
                UIView.animate(withDuration: 0.2) {
                    if self.showMenu {
                        self.sideMenu?.frame = CGRect.init(x: 0, y: 0, width: self.screenWidth!, height: self.screenHeight!)
                        self.sideMenu?.superview?.bringSubviewToFront(self.sideMenu!)
                    }
                    else
                    {
                        self.sideMenu?.frame = CGRect.init(x: -self.screenWidth!, y: 0, width: self.screenWidth!, height: self.screenHeight!)
                    }
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.addSubview(mchNavigationBar)
        
        screenWidth = self.view.frame.size.width
        screenHeight = self.view.frame.size.height
        mchNavigationBar.navigationController = self.navigationController
        mchNavigationBar.translatesAutoresizingMaskIntoConstraints = false
        let horizontalConstraint = NSLayoutConstraint(item: mchNavigationBar, attribute: NSLayoutConstraint.Attribute.leading, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.leading, multiplier: 1, constant: 0)
        let verticalConstraint = NSLayoutConstraint(item: mchNavigationBar, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1, constant: 0)
        let widthConstraint = NSLayoutConstraint(item: mchNavigationBar, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.width, multiplier: 1, constant: 0)
        let heightConstraint = NSLayoutConstraint(item: mchNavigationBar, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.view, attribute: NSLayoutConstraint.Attribute.height, multiplier: 0.21, constant: 0)
        NSLayoutConstraint.activate([horizontalConstraint, verticalConstraint, widthConstraint, heightConstraint])
        self.setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
        self.sideMenu?.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.sideMenu?.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.sideMenu?.isHidden = true
    }
    
    private func setupView() {
        mchNavigationBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mchNavigationBar)
        
        self.sideMenu = HamburgerView.init(frame: CGRect.init(x: -(screenWidth!), y: 0, width: screenWidth!, height: screenHeight!))
        self.view.addSubview(sideMenu!)
        
        
        self.sideMenu?.onClick = {() in
            self.showMenu.toggle()
        }
        
        self.sideMenu?.didSelectCell = {(indexPath) in
            switch indexPath.row {
            case 0:
                self.showMenu.toggle()
            case 3:
                let storyboard = UIStoryboard(name:Constants.storyboardName , bundle: nil)
                let activityCenter = storyboard.instantiateViewController(withIdentifier: self.storyboardIds.activityCenter.rawValue)
                self.navigationController?.pushViewController(activityCenter, animated: true)
                
            default:
                self.showMenu.toggle()
                
            }
        }
    }

}

