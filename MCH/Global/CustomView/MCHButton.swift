//
//  MCHButton.swift
//  MCH
//
//  Created by Akshay Gawade on 15/12/19.
//  Copyright © 2019 Akshay Gawade. All rights reserved.
//

import UIKit

enum Type  {
    case Plain
    case Selected
}

@IBDesignable
class MCHButton: UIButton {
    
    var type : Type = .Plain{
        didSet{
            switch type {
            case .Selected:
                self.backgroundColor = UIColor.Appcolor
                self.setTitleColor(UIColor.white, for: .normal)
                self.layer.borderColor = UIColor.clear.cgColor
                self.layer.borderWidth = 0
            case .Plain:
                self.backgroundColor = UIColor.white
                self.setTitleColor(UIColor.Appcolor, for: .normal)
                self.layer.borderColor = UIColor.Appcolor.cgColor
                self.layer.borderWidth = 2
            }
        }
    }
    
    
    override func draw(_ rect: CGRect) {
        // Drawing code
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
    }
    
}
