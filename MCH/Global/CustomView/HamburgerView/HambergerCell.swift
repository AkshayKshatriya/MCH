//
//  HambergerCell.swift
//  MCH
//
//  Created by Akshay Gawade on 29/12/19.
//  Copyright © 2019 Akshay Gawade. All rights reserved.
//

import UIKit

class HambergerCell: UITableViewCell {
    
    @IBOutlet weak var highlightView: UIView!
    @IBOutlet weak var menuImageView: UIImageView!
    @IBOutlet weak var menuLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func draw(_ rect: CGRect) {
        highlightView.roundCorners(corners: [.topRight,.bottomRight], radius: 10)
        menuLabel.font = UIFont.systemFont(ofSize: UIView.fontHeight(height: 15.0), weight: .light)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
        if selected
        {
            self.highlightView.backgroundColor = UIColor.Appcolor.withAlphaComponent(0.19)
            self.menuLabel.textColor = UIColor.Appcolor
            menuImageView.tintColor = UIColor.Appcolor
        } else {
            self.highlightView.backgroundColor = .clear
            self.menuLabel.textColor = .black
            menuImageView.tintColor = UIColor.black
        }
    }
    
    
}
