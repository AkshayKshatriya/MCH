//
//  YesNoView.swift
//  MCH
//
//  Created by Akshay Gawade on 22/01/20.
//  Copyright © 2020 Akshay Gawade. All rights reserved.
//

import UIKit

class YesNoView: UIView {

    @IBOutlet var contentView: UIView!
    var yesButtonAction : (()->())?
    var noButtonAction : (()->())?
    @IBOutlet weak var yesBtn: MCHButton!
    @IBOutlet weak var noBtn: MCHButton!
    
    
    override init(frame: CGRect) {
         super.init(frame: frame)
         initSubviews()
     }
     
     required init?(coder aDecoder: NSCoder) {
         super.init(coder:aDecoder)
         initSubviews()
     }
     
    private func initSubviews(){
        Bundle.main.loadNibNamed("YesNoView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
              contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        yesBtn.type = .Selected
        noBtn.type = .Plain
    }
    
    
    @IBAction func yesBtnclick(_ sender: Any) {
        self.yesButtonAction?()
    }
    
    @IBAction func noBtnClick(_ sender: Any) {
        self.noButtonAction?()
    }
}
