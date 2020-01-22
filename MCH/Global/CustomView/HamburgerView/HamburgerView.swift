//
//  HamburgerView.swift
//  MCH
//
//  Created by Akshay Gawade on 29/12/19.
//  Copyright © 2019 Akshay Gawade. All rights reserved.
//

import Foundation
import UIKit

class HamburgerView: UIView,UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var didSelectCell : ((IndexPath)->())?
    var onClick : (()->())?
    var cellIdentifier = "HambergerCell"
    var imageNames = [String]()
    var titleNames = [String]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
        initSubviews()
    }
    
    private func initSubviews(){
        Bundle.main.loadNibNamed("HamburgerView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableView.register(UINib.init(nibName: cellIdentifier, bundle: .main), forCellReuseIdentifier: cellIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        let constantsImage = Constants.HamburgerIcons.self
        let constantstitles = Constants.HamburgerMenus.self
        
        imageNames = [constantsImage.home.rawValue, constantsImage.trendingUp.rawValue, constantsImage.messageCircle.rawValue, constantsImage.activity.rawValue, constantsImage.bell.rawValue]
        titleNames = [constantstitles.home.rawValue, constantstitles.analytics.rawValue, constantstitles.chat.rawValue, constantstitles.activity.rawValue, constantstitles.reminders.rawValue]
    }
    
    @IBAction func closeAction(_ sender: Any) {
        self.onClick?()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.didSelectCell?(indexPath)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (self.contentView.frame.width * 0.15)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard  let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? HambergerCell else {
            return UITableViewCell.init()
        }
        cell.menuImageView.image = UIImage.init(named: imageNames[indexPath.row])?.withRenderingMode(.alwaysTemplate)
        cell.menuLabel.text = titleNames[indexPath.row]
        cell.selectionStyle = .none
        return cell
        
    }
    
    @IBAction func exitActionOnCover(_ sender: Any) {
        self.onClick?()
    }
    
    
}
