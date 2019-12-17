//
//  LoginViewController.swift
//  MCH
//
//  Created by Akshay Gawade on 23/11/19.
//  Copyright © 2019 Akshay Gawade. All rights reserved.
//

import UIKit

class LoginViewController: ViewController {

    
    @IBOutlet weak var loginCoverview: UIView!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var AppNameLabel: UILabel!
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var termsLabel: UILabel!
    @IBOutlet weak var signuoBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mchNavigationBar.isHidden = true
        loginBtn.titleLabel?.font = UIFont.systemFont(ofSize: UIView.fontHeight(height: btnFont))
        AppNameLabel?.font = UIFont.systemFont(ofSize: UIView.fontHeight(height: titlefont))

        loginLabel?.font = UIFont.systemFont(ofSize: UIView.fontHeight(height: subtitleFont))

        signuoBtn?.titleLabel?.font = UIFont.systemFont(ofSize: UIView.fontHeight(height: subtitleFont))

        termsLabel?.font = UIFont.systemFont(ofSize: UIView.fontHeight(height: FooterFont))

    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    
    override func viewDidLayoutSubviews() {
        loginBtn.roundCorners()
        loginCoverview.roundCorners(radius: 10.0)
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    

}
