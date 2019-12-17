//
//  SerachPopUp.swift
//  MCH
//
//  Created by Akshay Gawade on 14/12/19.
//  Copyright © 2019 Akshay Gawade. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

struct ElementOption {
    var id : String?
    var name : String?
}

class SearchPopUp: UIView, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var selectedOptionScrollView: UIScrollView!
    @IBOutlet weak var contentViewHeight: NSLayoutConstraint!
    @IBOutlet weak var selectedOptionScrollViewHeight: NSLayoutConstraint!
    @IBOutlet weak var optionTableView: UITableView!
    @IBOutlet weak var doneButton: MCHButton!
    @IBOutlet weak var cancelButton: MCHButton!
    @IBOutlet weak var scrollViewContentView: UIView!
    
    var prevFrame = CGRect.init(x: 0, y: 0, width: 0, height: 0)
    var elementArray = [ElementOption]()
    var cellIdentifier = "optionsCell"
    var cancelClicked : (()->())?
    var selectedOptionArray : [String]?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
        initSubviews()
    }
    
    override func draw(_ rect: CGRect) {
        contentView.roundCorners(corners: [.topLeft, .topRight], radius: 20)
    }
    
    private func initSubviews(){
        Bundle.main.loadNibNamed("SearchPopUp", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        doneButton.type = .Selected
        doneButton.setTitle("DONE", for: .normal)
        cancelButton.type = .Plain
        cancelButton.setTitle("CANCEL", for: .normal)
        optionTableView.register(UINib.init(nibName: "optionsCell", bundle: .main), forCellReuseIdentifier: cellIdentifier)
        self.searchBar.delegate = self
        self.optionTableView.dataSource = self
        self.optionTableView.delegate = self
        self.optionTableView.separatorStyle = .none
    }
    
    //MARK:- UISearchBarDelegate methods
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        return true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.elementArray.removeAll()
        self.optionTableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        debugPrint(searchText)
        if searchText != "" {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                let diseaseUrl: String = "https://clinicaltables.nlm.nih.gov/api/icd10cm/v3/search?sf=code,name&terms=\(searchText)"
                guard let url = URL.init(string: diseaseUrl) else { return }
                
                _ = Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil ).responseJSON
                    { response in
                        debugPrint(response.result)
                        switch response.result{
                        case .success:
                            do
                            {
                                self.elementArray.removeAll()
                                let json = try JSON(data: response.data!)
                                for i in 0 ..< json.arrayValue[3].count {
                                    if let name = json.arrayValue[3].arrayValue[i].arrayValue[1].string{
                                        let id = json.arrayValue[3].arrayValue[i].arrayValue[0].string ?? "\(i)"
                                        let elementOption = ElementOption.init(id:id , name: name)
                                        self.elementArray.append(elementOption)
                                        self.selectedOptionArray = [String]()
                                    }
                                }
                            }
                            catch let error {
                                //////////////////////////////json error///////////////////////////////
                                print(error)
                                //////////////////////////////////////////////////////////////////////
                            }
                            debugPrint(self.elementArray)
                            self.optionTableView.reloadData()
                        case .failure(_):
                            debugPrint(response)
                        }
                }
            }
        }
    }
    
    //MARK:- tableview datasource methods
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard  let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? optionsCell else {
            return UITableViewCell.init()
        }
        if let name = elementArray[indexPath.row].name  {
            cell.optionLabel.text = name
        }
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return elementArray.count
    }
    
    func addRemoveSelectedElement(cell : optionsCell, indexPath: IndexPath)  {
        if cell.checkBoxValue {
            cell.checkBoxValue = false
            guard let element = elementArray[indexPath.row].name else {
                return
            }
            selectedOptionArray?.removeAll(where: { (value) -> Bool in
                if value == element{
                    return true
                }
                else
                {
                    return false
                }
            })
            debugPrint(selectedOptionArray ?? [])
        }
        else
        {
            cell.checkBoxValue = true
            guard let element = elementArray[indexPath.row].name else {
                return
            }
            selectedOptionArray?.append(element)
            debugPrint(selectedOptionArray ?? [])
        }
        prevFrame = CGRect.init(x: 0, y: 0, width: 0, height: 0)
        setSelectedElementOnScrollView()
    }
    
    func setSelectedElementOnScrollView() {
        let scrollviewWidth = self.selectedOptionScrollView.frame.width
        for subview in self.scrollViewContentView.subviews {
            if let label = (subview as? UILabel){
                label.removeFromSuperview()
            }
        }

        for selectedOption in selectedOptionArray ?? [] {
            let selectedElementLabel = UILabel.init()
            selectedElementLabel.text = selectedOption
            selectedElementLabel.textColor = .black
            selectedElementLabel.numberOfLines = 0
            let maximumLabelSize: CGSize = CGSize(width: (scrollviewWidth - 40), height: 9999)
            let expectedLabelSize: CGSize = selectedElementLabel.sizeThatFits(maximumLabelSize)
            // create a frame that is filled with the UILabel frame data
            var newFrame: CGRect = selectedElementLabel.frame
            // resizing the frame to calculated size
            newFrame.size = expectedLabelSize
            // put calculated frame into UILabel frame
            if (scrollviewWidth - prevFrame.maxX) > (newFrame.width + 20) {
                newFrame.origin = CGPoint.init(x: (prevFrame.maxX + 10), y: prevFrame.minY)
            }
            else
            {
                newFrame.origin = CGPoint.init(x: (newFrame.origin.x + 10), y: (prevFrame.maxY + 10))
            }
            prevFrame = newFrame
            selectedElementLabel.frame = newFrame
            selectedElementLabel.backgroundColor = .red
            scrollViewContentView.addSubview(selectedElementLabel)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = ( tableView.cellForRow(at: indexPath) as? optionsCell ) {
            self.addRemoveSelectedElement(cell: cell, indexPath: indexPath)
        }
    }
    
    deinit {
        self.searchBar.delegate = nil
        self.optionTableView.dataSource = nil
        self.optionTableView.delegate = nil
        self.elementArray.removeAll()
    }
    
    @IBAction func doneAction(_ sender: Any) {
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        self.cancelClicked?()
    }
    
    
}
