//
//  UIColor+AppTheme.swift
//  MCH
//
//  Created by Akshay Gawade on 24/11/19.
//  Copyright © 2019 Akshay Gawade. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    internal class var Appcolor : UIColor {
        return UIColor(named: "primaryColor")! 
    }
    internal class var WhiteSelected : UIColor {
        return UIColor(named: "whiteSelected")!
    }
    internal class var WhiteSelected2 : UIColor {
        return UIColor(named: "whiteSelected2")!
    }
    internal class var Blur : UIColor {
        return UIColor(named: "blur")!
    }
    internal class var TextColor : UIColor {
        return UIColor(named: "textColor")!
    }
}

class MarginTextField: UITextField {
    let padding = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)

    override func draw(_ rect: CGRect) {
        self.isUserInteractionEnabled = false
        self.roundCorners(corners: .allCorners, radius: 10.0)
        self.font = UIFont.init(name: "Gilroy-Light", size: UIView.fontHeight(height: 16.0))
    }
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
}
