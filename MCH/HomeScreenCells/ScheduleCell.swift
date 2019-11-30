//
//  ScheduleCell.swift
//  MCH
//
//  Created by Akshay Gawade on 30/11/19.
//  Copyright © 2019 Akshay Gawade. All rights reserved.
//

import UIKit

class ScheduleCell: UICollectionViewCell {

    @IBOutlet weak var scheduleView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func draw(_ rect: CGRect) {
        roundCorners(corners: [.topLeft, .topRight], radius: 5.0)
    }

}
