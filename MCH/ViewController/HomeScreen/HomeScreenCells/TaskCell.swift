//
//  TaskCell.swift
//  MCH
//
//  Created by Akshay Gawade on 21/12/19.
//  Copyright © 2019 Akshay Gawade. All rights reserved.
//

import UIKit
import SwipeCellKit

class TaskCell: SwipeTableViewCell{

    @IBOutlet weak var taskTitleLable: UILabel!
    @IBOutlet weak var taskTimeLabel: UILabel!
    @IBOutlet weak var doneButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func draw(_ rect: CGRect) {
        doneButton.roundCorners()
        doneButton.titleLabel?.font = UIFont.systemFont(ofSize: 10.0, weight: .medium)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
