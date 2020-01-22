//
//  ActivityCenterController.swift
//  MCH
//
//  Created by Akshay Gawade on 08/01/20.
//  Copyright © 2020 Akshay Gawade. All rights reserved.
//

import UIKit

class ActivityCenterController: ViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var supercontroller : ViewController?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.sideMenu!.onClick = {() in
            self.showMenu.toggle()
        }
    }
    
    
    
    
    

    
    
}
