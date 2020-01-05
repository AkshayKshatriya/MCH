//
//  HomeScreenViewController.swift
//  MCH
//
//  Created by Akshay Gawade on 19/11/19.
//  Copyright © 2019 Akshay Gawade. All rights reserved.
//

import UIKit
import DeviceKit

class HomeScreenViewController: ViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var hambergerView: HamburgerView!
    @IBOutlet weak var homeCollectionView: UICollectionView!
    @IBOutlet weak var homeCollectionViewTop: NSLayoutConstraint!
    @IBOutlet weak var hamburgerviewWidth: NSLayoutConstraint!
    @IBOutlet weak var hamburgerViewTrailing: NSLayoutConstraint!
    var showMenu : Bool = false {
        didSet{
            if self.showMenu {
                self.hamburgerViewTrailing.constant = -((UIApplication.shared.keyWindow?.bounds.width)! )
                        self.hambergerView.superview?.bringSubviewToFront(self.hambergerView)
                    }
                    else
                    {
                        self.hamburgerViewTrailing.constant = 0
                    }
            UIView.animate(withDuration: 0.2) {
                self.view.layoutIfNeeded()
            }
        }
    }
    let HomeConstants = Constants.HomeScreen.self

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        homeCollectionView.register(UINib.init(nibName: "EmptyCell", bundle: .main), forCellWithReuseIdentifier: "EmptyCell")
        homeCollectionView.register(UINib.init(nibName: "DailyStatusCell", bundle: .main), forCellWithReuseIdentifier: "DailyStatusCell")
        homeCollectionView.register(UINib.init(nibName: "ScheduleCell", bundle: .main), forCellWithReuseIdentifier: "ScheduleCell")
        homeCollectionView.register(UINib.init(nibName: "TaskListHeader", bundle: .main), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "TaskListHeader")
        homeCollectionView.register(UINib.init(nibName: "TaskListCell", bundle: .main), forCellWithReuseIdentifier: "TaskListCell")
        
        homeCollectionView.dragInteractionEnabled = true
        homeCollectionView.dataSource = self
        homeCollectionView.delegate = self
        homeCollectionView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        
        self.hambergerView.onClick = {() in
            self.showMenu.toggle()
        }
        
        self.mchNavigationBar.titleTouchupInside = {() in
            let storyboard = UIStoryboard(name:Constants.storyboardName , bundle: nil)
            let profileController = storyboard.instantiateViewController(withIdentifier: self.HomeConstants.storyboardId.rawValue)
            self.navigationController?.pushViewController(profileController, animated: true)
        }        
    }
    
    override func viewWillLayoutSubviews() {
        mchNavigationBar.loadUI(type: .Home, title: "Good Morning", subtitle: "Linda")
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentSize" && ((object as? UICollectionView) != nil) {
            if let collectionView = (object as? UICollectionView){
                print(collectionView.contentSize)
            }
            print("updated")
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        mchNavigationBar.onClick = { () in
            //            self.navigationController?.popViewController(animated: true)
            self.showMenu.toggle()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        homeCollectionView.reloadData()
    }
    
    override func viewDidLayoutSubviews() {
        print(self.mchNavigationBar.frame.size.height)
        homeCollectionViewTop.constant = (self.mchNavigationBar.frame.size.height) + UIView.fontHeight(height: 10.0)
    }
    
    //horizontal space between cell
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    //vertical space between cell
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        debugPrint("index sizeForItemAt = \(indexPath)")
        switch indexPath.section {
        case 0:
            let cellSize = CGSize.init(width: (self.view.frame.width), height: (self.view.frame.width * 0.23))
            return cellSize
            
        case 2:
            let cellSize = CGSize.init(width: (self.view.frame.width), height: (self.view.frame.width * 0.44))
            return cellSize
            
        case 3:
            let cellSize = CGSize.init(width: (self.view.frame.width), height: (self.view.frame.width * 0.44))
            return cellSize
            
        default:
            return CGSize.init(width: 0, height: 0)
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        debugPrint("index = \(indexPath)")
        switch indexPath.section {
        case 0:
            guard let dailyStatusCell = collectionView.dequeueReusableCell(withReuseIdentifier: "DailyStatusCell", for: indexPath) as? DailyStatusCell
                else {
                    preconditionFailure("Invalid cell type")
            }
            return dailyStatusCell
        case 2:
            guard let taskListCell = collectionView.dequeueReusableCell(withReuseIdentifier: "TaskListCell", for: indexPath) as? TaskListCell
                else {
                    preconditionFailure("Invalid cell type")
            }
            return taskListCell
            
        case 3:
            guard let scheduleCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ScheduleCell", for: indexPath) as? ScheduleCell
                else {
                    preconditionFailure("Invalid cell type")
            }
            return scheduleCell
            
        default:
            debugPrint("index default = \(indexPath)")
            guard let emptyCell = collectionView.dequeueReusableCell(withReuseIdentifier: "EmptyCell", for: indexPath) as? EmptyCell
                else {
                    preconditionFailure("Invalid cell type")
            }
            return emptyCell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 1 {
            return CGSize(width: collectionView.frame.width, height:60.0)
        }
        else
        {
            return CGSize(width: 0, height: 0)
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var headerView : TaskListHeader?
        if indexPath.section == 1 {
            headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "TaskListHeader", for: indexPath) as? TaskListHeader
            headerView?.titleArray = ["Saturday","Sunday","Monday","Tuesday","Wednesday","Thursday","Friday"]
            headerView?.isHidden = false
        }
        else
        {
            headerView?.isHidden = true
        }
        return headerView!
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
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
