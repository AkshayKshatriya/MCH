//
//  TaskListHeader.swift
//  MCH
//
//  Created by Akshay Gawade on 30/11/19.
//  Copyright © 2019 Akshay Gawade. All rights reserved.
//

import UIKit

class TaskListHeader: UICollectionReusableView {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentViewWidth: NSLayoutConstraint!
    let marker = UIView.init()
    var markerIndex = 0
    var setMarker = false
    
    var titleArray = [String](){
        didSet{
            self.setNeedsDisplay()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    override func draw(_ rect: CGRect) {
        var xMargin : CGFloat = 0.0
        for title in titleArray {
            let titleLbl = UILabel.init()
            titleLbl.font = UIFont.systemFont(ofSize: UIView.fontHeight(height: 15.0), weight: .regular)
            titleLbl.text = title
            titleLbl.textAlignment = .left
            titleLbl.textAlignment = .center
            titleLbl.textColor = UIColor.white
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
            titleLbl.addGestureRecognizer(tap)
            let lblWidth = titleLbl.intrinsicContentSize.width
            titleLbl.frame = CGRect.init(x: xMargin, y: 0, width: lblWidth, height: UIView.fontHeight(height: UIView.fontHeight(height: 35)))
            titleLbl.isUserInteractionEnabled = true
            contentView.addSubview(titleLbl)
            if !setMarker
            {
                marker.frame = CGRect.init(x: titleLbl.frame.minX, y: (titleLbl.frame.maxY ), width: (titleLbl.frame.size.width / 3), height: UIView.fontHeight(height: 2.0))
                marker.backgroundColor = UIColor.white
                marker.roundCorners()
                contentView.addSubview(marker)
                setMarker = true
            }
            xMargin += (lblWidth + 25)
        }
        contentViewWidth.constant = xMargin
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        let xMargin = sender?.view?.frame.minX
        UIView.animate(withDuration: 0.2) {
            self.marker.frame = CGRect.init(x: xMargin!, y: self.marker.frame.origin.y, width: self.marker.frame.width, height: self.marker.frame.height)
        }
    }
}
