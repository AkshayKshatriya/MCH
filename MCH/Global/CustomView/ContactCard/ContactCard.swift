//
//  ContactCard.swift
//  MCH
//
//  Created by Akshay Gawade on 05/01/20.
//  Copyright © 2020 Akshay Gawade. All rights reserved.
//

import UIKit

class ContactCard: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var contactType: UILabel!
    @IBOutlet weak var contactName: UILabel!
    @IBOutlet weak var contactImage: UIImageView!
    
    override init(frame: CGRect) {
         super.init(frame: frame)
         initSubviews()
     }
     
     required init?(coder aDecoder: NSCoder) {
         super.init(coder:aDecoder)
         initSubviews()
     }
     
    private func initSubviews(){
        Bundle.main.loadNibNamed("ContactCard", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
              contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.contactType.font = UIFont.init(name: "Gilroy-Light", size: UIView.fontHeight(height: 8.0))
        self.contactName.font = UIFont.init(name: "Gilroy-ExtraBold ", size: UIView.fontHeight(height: 16.0))

        
    }
    
    override func draw(_ rect: CGRect) {
        contactImage.roundCorners(corners: .allCorners, radius: (contactImage.frame.height/2))
        self.roundCorners(corners: .allCorners, radius: 10.0)
    }
}
