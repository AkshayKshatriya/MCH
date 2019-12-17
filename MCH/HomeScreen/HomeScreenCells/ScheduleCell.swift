//
//  ScheduleCell.swift
//  MCH
//
//  Created by Akshay Gawade on 30/11/19.
//  Copyright © 2019 Akshay Gawade. All rights reserved.
//

import UIKit

class ScheduleCell: UICollectionViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var scheduleView: UIView!
    @IBOutlet weak var contentview: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentViewWidth: NSLayoutConstraint!
    
    var titleString:AttrString?{
        didSet{
            titleLabel.attributedText = self.titleString?.attributedString
            titleLabel.adjustsFontForContentSizeCategory = true

        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let str: AttrString = """
            \("Your Schedule", .color(UIColor.black), .font(.systemFont(ofSize: UIView.fontHeight(height: 15), weight: .light))) \("Today", .color(UIColor.black), .font(UIFont.systemFont(ofSize: UIView.fontHeight(height: 15), weight: .semibold)))
            """
        
            self.titleString = str
    }
    
    override func draw(_ rect: CGRect) {
        roundCorners(corners: [.topLeft, .bottomLeft],radius: 10.0)
        var xMargin : CGFloat = 0.0
        for i in 1..<8 {
            let activityView = ScheduleActivityView.init(frame: CGRect.init(x: xMargin, y: 0, width: self.scrollView.frame.width * 0.5, height: self.scrollView.frame.height))
            xMargin += ((self.scrollView.frame.width * 0.5) + 20.0)
            if i > 1 {
                activityView.contentView.backgroundColor = UIColor.WhiteSelected2
                activityView.eventNameLbl.textColor = UIColor.black
                activityView.timeLbl.textColor = UIColor.black
            }
            contentview.addSubview(activityView)
        }
        contentViewWidth.constant = xMargin
    }

}
