//
//  DailyStatusCell.swift
//  MCH
//
//  Created by Akshay Gawade on 24/11/19.
//  Copyright © 2019 Akshay Gawade. All rights reserved.
//

import UIKit

class DailyStatusCell: UICollectionViewCell {

    @IBOutlet weak var eodDateLabel: UILabel!
    @IBOutlet weak var eodLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var weekLabel: UILabel!
    @IBOutlet weak var statusView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        eodLabel.font = UIFont.systemFont(ofSize: UIView.fontHeight(height: 13), weight: .thin)
        weekLabel.font = UIFont.systemFont(ofSize: UIView.fontHeight(height: 13), weight: .thin)
        eodDateLabel.font = UIFont.systemFont(ofSize: UIView.fontHeight(height: 17), weight: .medium)
        dayLabel.font = UIFont.systemFont(ofSize: UIView.fontHeight(height: 17), weight: .medium)
    }
    
    override func draw(_ rect: CGRect) {
        statusView.roundCorners()
    }

}
