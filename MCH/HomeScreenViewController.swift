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
    
    @IBOutlet weak var homeCollectionView: UICollectionView!
    @IBOutlet weak var homeCollectionViewTop: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        mchNavigationBar.loadUI(type: .Home, title: "Good Morning", subtitle: "Linda")
        homeCollectionView.register(UINib.init(nibName: "DailyStatusCell", bundle: .main), forCellWithReuseIdentifier: "DailyStatusCell")
        homeCollectionView.register(UINib.init(nibName: "ScheduleCell", bundle: .main), forCellWithReuseIdentifier: "ScheduleCell")
        homeCollectionView.register(UINib.init(nibName: "TaskListHeader", bundle: .main), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "TaskListHeader")
        homeCollectionView.dragInteractionEnabled = true
        homeCollectionView.dataSource = self
        homeCollectionView.delegate = self
        homeCollectionView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
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
    }
    
    override func viewDidLayoutSubviews() {
        print(self.mchNavigationBar.frame.size.height)
        homeCollectionViewTop.constant = (self.mchNavigationBar.frame.size.height) + 10
    }
    
    //horizontal space between cell
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    //vertical space between cell
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        switch indexPath.section {
        case 0:
            let cellSize = CGSize.init(width: (self.view.frame.width), height: (self.view.frame.width * 0.23))
            return cellSize
            
        case 1:
            let cellSize = CGSize.init(width: (self.view.frame.width), height: (self.view.frame.width * 0.44))
            return cellSize
            
        default:
            return CGSize.init(width: 0, height: 0)
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        switch indexPath.section {
        case 0:
            guard let dailyStatusCell = collectionView.dequeueReusableCell(withReuseIdentifier: "DailyStatusCell", for: indexPath) as? DailyStatusCell
                else {
                    preconditionFailure("Invalid cell type")
            }
            return dailyStatusCell
        case 1:
            guard let scheduleCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ScheduleCell", for: indexPath) as? ScheduleCell
                else {
                    preconditionFailure("Invalid cell type")
            }
            return scheduleCell
            
        default:
            return UICollectionViewCell.init()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 1 {
            return CGSize(width: collectionView.frame.width, height:50.0)
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
