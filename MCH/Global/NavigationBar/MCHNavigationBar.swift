//
//  MCHNavigationBar.swift
//  MCH
//
//  Created by Akshay Gawade on 18/11/19.
//  Copyright © 2019 Akshay Gawade. All rights reserved.
//

import UIKit
import FontAwesome_swift

enum ScreenType {
    case Home
    case Profile
}


class MCHNavigationBar: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var Image: UIImageView!
    @IBOutlet weak var menuBtn: UIButton!
    @IBOutlet var navigationIconBar: [UIView]!
    @IBOutlet var titleTapped: UITapGestureRecognizer!
    
    let navigationBarConstants = Constants.NavigationBar.self
    var titleTouchupInside : (()->())?
    var type : ScreenType?
    
    var menuBtnBarHidden = false {
        didSet  {
            for bar in navigationIconBar {
                bar.isHidden = menuBtnBarHidden
            }
        }
    }
    var imageIsHidden = false {
        didSet{
            Image.isHidden = imageIsHidden
        }
    }
    var onClick : (()->())?
    var navigationController : UINavigationController?
    
    var titleString:AttrString?{
        didSet{
            titleLabel.attributedText = self.titleString?.attributedString
            titleLabel.adjustsFontForContentSizeCategory = true
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
        initSubviews()
    }
    
    private func initSubviews(){
        Bundle.main.loadNibNamed("MCHNavigationBar", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
    }
    
    func loadUI(type : ScreenType, title : String, subtitle : String) {
        /*let str: AttrString = """
                      \(title, .color(UIColor.init(named: "primaryColor")!), .font(.systemFont(ofSize: 25, weight: .light)))\n\(subtitle, .color(UIColor.init(named: "primaryColor")!), .font(UIFont.systemFont(ofSize: AppDelegate.fontHeight(height: 25), weight: .semibold))) \(String.fontAwesomeIcon(name: .angleDown), .font(UIFont.fontAwesome(ofSize: AppDelegate.fontHeight(height: 24), style: .solid)))
                      """*/
        self.type = type
        switch type {
        case .Home:
            self.contentView.backgroundColor = UIColor.Appcolor
            for subview in navigationIconBar {
                subview.backgroundColor = UIColor.white
            }
            self.menuBtn.backgroundColor = .Appcolor
            let str: AttrString = """
                \(title, .color(UIColor.white), .font(.systemFont(ofSize: UIView.fontHeight(height: 25), weight: .light)))\n\(subtitle, .color(UIColor.white), .font(UIFont.systemFont(ofSize: UIView.fontHeight(height: 25), weight: .semibold)))
                """
            self.titleString = str
            self.menuBtnBarHidden = false
            self.imageIsHidden = false
            self.layoutIfNeeded()
        case .Profile:
            self.menuBtnBarHidden = true
            self.menuBtn.setImage(UIImage.init(named: navigationBarConstants.backIcon.rawValue), for: .normal)
            self.menuBtn.backgroundColor = .Appcolor
            self.titleLabel.textColor = .Appcolor
            let str: AttrString = """
                \(title, .color(UIColor.Appcolor), .font(.systemFont(ofSize: UIView.fontHeight(height: 25), weight: .light)))\n\(subtitle, .color(UIColor.Appcolor), .font(UIFont.systemFont(ofSize: UIView.fontHeight(height: 25), weight: .semibold)))
                """
            self.titleString = str
            self.imageIsHidden = true
            self.setNeedsDisplay()
        }
        
    }
    
    override func draw(_ rect: CGRect) {
        Image.roundCorners(corners: .allCorners, radius: 10.0)
        switch type {
        case .Profile:
            self.menuBtn.roundCorners()
        default:
            break
        }
    }
        
    @IBAction func menuBtnAction(_ sender: Any) {
        self.onClick?()
    }
    
    @IBAction func titleTappedAction(_ sender: Any) {
        self.titleTouchupInside?()
    }
    
    
    
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
}
