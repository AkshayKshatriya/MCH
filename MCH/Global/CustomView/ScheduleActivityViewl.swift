//
//  ScheduleActivityCell.swift
//  MCH
//
//  Created by Akshay Gawade on 30/11/19.
//  Copyright © 2019 Akshay Gawade. All rights reserved.
//

import UIKit

class ScheduleActivityView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var eventNameLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
        initSubviews()
    }
    
    override func draw(_ rect: CGRect) {
        contentView.roundCorners(radius: 10.0)
    }
    
    override func layoutIfNeeded() {
        contentView.roundCorners(radius: 10.0)
    }
    
    private func initSubviews(){
        Bundle.main.loadNibNamed("ScheduleActivityView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        eventNameLbl.font = UIFont.systemFont(ofSize: UIView.fontHeight(height: 18), weight: .thin)
        timeLbl.font = UIFont.systemFont(ofSize: UIView.fontHeight(height: 20), weight: .medium)
    }

}
