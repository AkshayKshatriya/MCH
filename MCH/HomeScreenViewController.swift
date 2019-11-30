//
//  HomeScreenViewController.swift
//  MCH
//
//  Created by Akshay Gawade on 19/11/19.
//  Copyright © 2019 Akshay Gawade. All rights reserved.
//

import UIKit
class HomeScreenViewController: ViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var homeCollectionView: UICollectionView!
    @IBOutlet weak var homeCollectionViewTop: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        mchNavigationBar.loadUI(type: .Home, title: "Good Morning", subtitle: "Linda")
        homeCollectionView.register(UINib.init(nibName: "DailyStatusCell", bundle: .main), forCellWithReuseIdentifier: "DailyStatusCell")
        homeCollectionView.dragInteractionEnabled = true
        homeCollectionView.dataSource = self
        homeCollectionView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }

    override func viewDidLayoutSubviews() {
        print(self.mchNavigationBar.frame.size.height)
        homeCollectionViewTop.constant = (self.mchNavigationBar.frame.size.height)
    }
     
     //horizontal space between cell
     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
         return 1
     }
     
     //vertical space between cell
     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
         return 3
     }
     
     
     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
     {
         let cellSize = CGSize.init(width: (self.view.frame.width), height: (self.view.frame.width * 0.23))
         return cellSize
     }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
     
     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
     {
         return 1
     }
     
     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
     {
         guard let dailyStatusCell = collectionView.dequeueReusableCell(withReuseIdentifier: "DailyStatusCell", for: indexPath) as? DailyStatusCell
        else {
             preconditionFailure("Invalid cell type")
         }
         return dailyStatusCell
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
