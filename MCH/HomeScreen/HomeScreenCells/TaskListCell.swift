//
//  TaskListCell.swift
//  MCH
//
//  Created by Akshay Gawade on 21/12/19.
//  Copyright © 2019 Akshay Gawade. All rights reserved.
//

import UIKit

class TaskListCell: UICollectionViewCell, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var taskListTableView: UITableView!
    @IBOutlet weak var taskListTableHeight: NSLayoutConstraint!
    
    var cellIdentifier = "TaskCell"
    var maxContentHeight : CGFloat = 0
    var footterHeight : CGFloat = UIView.fontHeight(height: 30)
    var headerHeight : CGFloat = UIView.fontHeight(height: 40)
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: self.frame.width, height: headerHeight))
        let titleLabel = UILabel.init(frame: CGRect.init(x: 20, y: 0, width: (headerView.frame.size.width - 40), height: headerView.frame.size.height))
        titleLabel.text = "Daily Task"
        titleLabel.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        headerView.backgroundColor = .white
        headerView.addSubview(titleLabel)
        if section == 0{
            headerView.roundCorners(corners: .topLeft, radius: 10.0)
        }
        return headerView
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return headerHeight
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 1{
            return footterHeight
        }
        else
        {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 1{
            let footerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: self.frame.width, height: footterHeight))
            footerView.backgroundColor = .white
            footerView.roundCorners(corners: .bottomLeft, radius: 10.0)
            return footerView
        }
        else{
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let taskCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? TaskCell
            else {
                preconditionFailure("Invalid cell type")
        }
        return taskCell
    }
    
    override func layoutSubviews() {
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let nibCell = UINib.init(nibName: cellIdentifier, bundle: .main)
        self.taskListTableView.register(nibCell, forCellReuseIdentifier: cellIdentifier)
        self.taskListTableView.dataSource = self
        self.taskListTableView.delegate = self
        self.backgroundColor = .clear
        self.taskListTableView.backgroundColor = .clear
        taskListTableHeight.constant =  2000
    }
    
    override func draw(_ rect: CGRect) {
        debugPrint("content = \(self.taskListTableView.contentSize.height)")
        taskListTableHeight.constant =  self.taskListTableView.contentSize.height
        taskListTableView.layoutIfNeeded()

    }
    
}
