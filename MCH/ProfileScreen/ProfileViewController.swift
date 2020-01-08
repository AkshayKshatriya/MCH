//
//  ProfileViewController.swift
//  MCH
//
//  Created by Akshay Gawade on 05/01/20.
//  Copyright © 2020 Akshay Gawade. All rights reserved.
//

import UIKit

class ProfileViewController: ViewController {

    @IBOutlet weak var displayPictureBtn: UIButton!
    @IBOutlet weak var scrollViewTop: NSLayoutConstraint!
    @IBOutlet weak var nameTF: MarginTextField!
    @IBOutlet weak var detailButton: MCHButton!
    @IBOutlet weak var scrollviewHeight: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mchNavigationBar.loadUI(type: .Profile, title: "User Profile", subtitle: "Linda")
        self.mchNavigationBar.onClick = {() in
            self.navigationController?.popViewController(animated: true)
        }
        detailButton.type = .Selected
    }
    
    override func viewDidLayoutSubviews() {
        scrollViewTop.constant = (self.mchNavigationBar.frame.maxY - (screenWidth!*0.04))
        debugPrint((self.mchNavigationBar.frame.maxY))
        debugPrint(scrollViewTop.constant)
        displayPictureBtn.roundCorners(corners: .allCorners, radius: 15.0)
        detailButton.titleLabel?.font = UIFont.systemFont(ofSize: UIView.fontHeight(height: 10.0), weight: .medium)
        scrollviewHeight.constant = detailButton.frame.maxY + 50
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
