//
//  SearchPopupScreen.swift
//  MCH
//
//  Created by Akshay Gawade on 12/01/20.
//  Copyright © 2020 Akshay Gawade. All rights reserved.
//

import UIKit

class SearchPopupScreen: UIViewController {
    
    var searchPopUp: SearchPopUp?
    var completionHandler : (([String])->())?
    var type : searchType?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.searchPopUp = SearchPopUp.init(frame: self.view.frame)
        searchPopUp!.type = self.type
        searchPopUp!.cancelClicked = { (allSelctedOption) in
            debugPrint(allSelctedOption)
            DispatchQueue.main.async {
                self.dismiss(animated: true) {
                    self.completionHandler?(allSelctedOption)
                }
            }
        }
        self.view.addSubview(searchPopUp!)
    }
    
    
    override func viewDidLayoutSubviews() {
        self.searchPopUp?.frame = self.view.frame
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
