//
//  TaskListCell.swift
//  MCH
//
//  Created by Akshay Gawade on 21/12/19.
//  Copyright © 2019 Akshay Gawade. All rights reserved.
//

import UIKit
import SwipeCellKit

enum ButtonDisplayMode {
    case titleAndImage, titleOnly, imageOnly
}

enum ButtonStyle {
    case backgroundColor, circular
}

enum ActionDescriptor {
    case read, unread, more, flag, trash, missed
    
    func title(forDisplayMode displayMode: ButtonDisplayMode) -> String? {
        guard displayMode != .imageOnly else { return nil }
        
        switch self {
        case .missed: return "Missed"
        case .read: return "Read"
        case .unread: return "Unread"
        case .more: return "More"
        case .flag: return "Flag"
        case .trash: return "Trash"
        }
    }
    
    func image(forStyle style: ButtonStyle, displayMode: ButtonDisplayMode) -> UIImage? {
        guard displayMode != .titleOnly else { return nil }
        
        let name: String
        switch self {
        case .missed: name = "Read"
        case .read: name = "Read"
        case .unread: name = "Unread"
        case .more: name = "More"
        case .flag: name = "Flag"
        case .trash: name = "Trash"
        }
        
    #if canImport(Combine)
        if #available(iOS 13.0, *) {
            let name: String
            switch self {
            case .missed: name = "envelope.open.fill"
            case .read: name = "envelope.open.fill"
            case .unread: name = "envelope.badge.fill"
            case .more: name = "ellipsis.circle.fill"
            case .flag: name = "flag.fill"
            case .trash: name = "trash.fill"
            }
            
            if style == .backgroundColor {
                let config = UIImage.SymbolConfiguration(pointSize: 23.0, weight: .regular)
                return UIImage(systemName: name, withConfiguration: config)
            } else {
                let config = UIImage.SymbolConfiguration(pointSize: 22.0, weight: .regular)
                let image = UIImage(systemName: name, withConfiguration: config)?.withTintColor(.white, renderingMode: .alwaysTemplate)
                return circularIcon(with: color(forStyle: style), size: CGSize(width: 50, height: 50), icon: image)
            }
        } else {
            return UIImage(named: style == .backgroundColor ? name : name + "-circle")
        }
    #else
        return UIImage(named: style == .backgroundColor ? name : name + "-circle")
    #endif
    }
    
    func color(forStyle style: ButtonStyle) -> UIColor {
    #if canImport(Combine)
        switch self {
        case .read, .unread: return UIColor.systemBlue
        case .more:
            if #available(iOS 13.0, *) {
                if UITraitCollection.current.userInterfaceStyle == .dark {
                    return UIColor.systemGray
                }
                return style == .backgroundColor ? UIColor.systemGray3 : UIColor.systemGray2
            } else {
                return #colorLiteral(red: 0.7803494334, green: 0.7761332393, blue: 0.7967314124, alpha: 1)
            }
        case .flag: return UIColor.systemOrange
        case .trash: return UIColor.systemRed
        case .missed: return UIColor.Appcolor
        }
    #else
        switch self {
        case .read, .unread: return #colorLiteral(red: 0, green: 0.4577052593, blue: 1, alpha: 1)
        case .more: return #colorLiteral(red: 0.7803494334, green: 0.7761332393, blue: 0.7967314124, alpha: 1)
        case .flag: return #colorLiteral(red: 1, green: 0.5803921569, blue: 0, alpha: 1)
        case .trash: return #colorLiteral(red: 1, green: 0.2352941176, blue: 0.1882352941, alpha: 1)
        }
    #endif
    }
    
    func circularIcon(with color: UIColor, size: CGSize, icon: UIImage? = nil) -> UIImage? {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)

        UIBezierPath(ovalIn: rect).addClip()

        color.setFill()
        UIRectFill(rect)

        if let icon = icon {
            let iconRect = CGRect(x: (rect.size.width - icon.size.width) / 2,
                                  y: (rect.size.height - icon.size.height) / 2,
                                  width: icon.size.width,
                                  height: icon.size.height)
            icon.draw(in: iconRect, blendMode: .normal, alpha: 1.0)
        }

        defer { UIGraphicsEndImageContext() }

        return UIGraphicsGetImageFromCurrentImageContext()
    }
}

extension TaskListCell : SwipeTableViewCellDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        
        if orientation == .left {
            
            let missed = SwipeAction(style: .default, title: nil) { action, indexPath in
                //TODO:- swipe action
            }
            
            missed.hidesWhenSelected = true
            missed.accessibilityLabel = "Missed"
            
            let descriptor: ActionDescriptor = .missed
            configure(action: missed, with: descriptor)
            
            return [missed]
        } else {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = orientation == .left ? .selection : .destructive
        options.transitionStyle = defaultOptions.transitionStyle
        
        switch buttonStyle {
        case .backgroundColor:
            options.buttonSpacing = 4
        case .circular:
            options.buttonSpacing = 4
        #if canImport(Combine)
            if #available(iOS 13.0, *) {
                options.backgroundColor = UIColor.systemGray6
            } else {
                options.backgroundColor = #colorLiteral(red: 0.9467939734, green: 0.9468161464, blue: 0.9468042254, alpha: 1)
            }
        #else
            options.backgroundColor = #colorLiteral(red: 0.9467939734, green: 0.9468161464, blue: 0.9468042254, alpha: 1)
        #endif
        }
        
        return options
    }
    
    func configure(action: SwipeAction, with descriptor: ActionDescriptor) {
        action.title = descriptor.title(forDisplayMode: buttonDisplayMode)
        action.image = descriptor.image(forStyle: buttonStyle, displayMode: buttonDisplayMode)
        
        switch buttonStyle {
        case .backgroundColor:
            action.backgroundColor = descriptor.color(forStyle: buttonStyle)
        case .circular:
            action.backgroundColor = .clear
            action.textColor = descriptor.color(forStyle: buttonStyle)
            action.font = .systemFont(ofSize: 13)
            action.transitionDelegate = ScaleTransition.default
        }
    }
}


class TaskListCell: UICollectionViewCell, UITableViewDataSource, UITableViewDelegate {
    var defaultOptions = SwipeOptions()
    var isSwipeRightEnabled = true
    var buttonDisplayMode: ButtonDisplayMode = .titleOnly
    var buttonStyle: ButtonStyle = .backgroundColor

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
        taskCell.delegate = self
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
