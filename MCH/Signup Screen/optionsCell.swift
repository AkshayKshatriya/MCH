//
//  optionsCell.swift
//  MCH
//
//  Created by Akshay Gawade on 15/12/19.
//  Copyright © 2019 Akshay Gawade. All rights reserved.
//

import UIKit

class optionsCell: UITableViewCell {

    @IBOutlet weak var checkBox: UIView!
    @IBOutlet weak var optionLabel: UILabel!
    
    var checkBoxValue : Bool = false {
        didSet{
            if checkBoxValue{
                checkBox.backgroundColor = .Appcolor
            }
            else{
                checkBox.backgroundColor = .WhiteSelected2
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func draw(_ rect: CGRect) {
        checkBox.roundCorners()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
