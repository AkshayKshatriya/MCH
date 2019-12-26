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
    var isSelected = false
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
    var allSelectedOptionArray : [String]?
    var request : DataRequest?
    var searchString = ""
    var gotResponse = false {
        didSet(value){
            if value
            {
                optionTableView.isUserInteractionEnabled = true
            }
            else
            {
                optionTableView.isUserInteractionEnabled = false
            }
        }
    }
    
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
        self.searchBar.becomeFirstResponder()
        self.allSelectedOptionArray = [String]()
    }
    
    //MARK:- UISearchBarDelegate methods
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
//        for selectedOption in self.selectedOptionArray ?? [] {
//            self.allSelectedOptionArray?.append(selectedOption)
//        }
        self.elementArray.removeAll()
        self.optionTableView.reloadData()
        setSelectedElementOnScrollView()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        if let searchText = searchBar.text, searchText != "" {
            searchString = searchText
            getAutoComplete(searchText: searchText)
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        debugPrint(searchText)
        searchString = searchText
        getAutoComplete(searchText: searchText)
    }
    
    func getAutoComplete(searchText : String)  {
        if searchText != "" {
            //            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            let diseaseUrl: String = "https://clinicaltables.nlm.nih.gov/api/icd10cm/v3/search?sf=code,name&terms=\(searchText)"
            guard let url = URL.init(string: diseaseUrl) else { return }
            //                self.gotResponse = false
            self.request = Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil ).responseJSON
                { response in
                    debugPrint(response.result)
                    let requestSearchString = self.request?.request?.url?.absoluteString.components(separatedBy: "terms=")
                    
                    if requestSearchString != nil && (requestSearchString?.count ?? 0) > 1 && self.searchString == (requestSearchString?[1] ?? "" ) {
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
                        //                            self.gotResponse = true
                        case .failure(_):
                            debugPrint(response)
                            //                            self.gotResponse = true
                        }
                    }
            }
            //            }
        }
        else
        {
            self.elementArray.removeAll()
            self.optionTableView.reloadData()
            setSelectedElementOnScrollView()
        }
    }
    
    //MARK:- tableview datasource methods
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard  let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? optionsCell else {
            return UITableViewCell.init()
        }
        if let name = elementArray[indexPath.row].name  {
            cell.optionLabel.text = name
            if elementArray[indexPath.row].isSelected {
                cell.checkBoxValue = true
            }
            else
            {
                cell.checkBoxValue = false
            }
        }
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return elementArray.count
    }
    func removerFromArray(array: inout [String], element : String?) {
        array.removeAll(where: { (value) -> Bool in
            if value == element{
                return true
            }
            else
            {
                return false
            }
        })
    }
    
    func addRemoveSelectedElement(cell : optionsCell, indexPath: IndexPath)  {
        if cell.checkBoxValue {
            cell.checkBoxValue = false
            elementArray[indexPath.row].isSelected = false
            if  indexPath.row < elementArray.count {
                var element = elementArray[indexPath.row]
                element.isSelected = false
                removerFromArray(array: &selectedOptionArray!, element: element.name)
                removerFromArray(array: &allSelectedOptionArray!, element: element.name)
                debugPrint(selectedOptionArray ?? [])
            }
        }
        else
        {
            cell.checkBoxValue = true
            elementArray[indexPath.row].isSelected = true
            guard let element = elementArray[indexPath.row].name else {
                return
            }
            selectedOptionArray?.append(element)
            allSelectedOptionArray?.append(element)
            debugPrint(selectedOptionArray ?? [])
        }
        setSelectedElementOnScrollView()
    }
    
    @objc func removeElemnetFromScrollview(_ sender: UITapGestureRecognizer? = nil) {
        if let selectedLabel = sender?.view as? UILabel{
            let selectedElement = selectedLabel.text?.replacingOccurrences(of: "   x", with: "")
            self.removerFromArray(array: &selectedOptionArray!, element: selectedElement)
            self.removerFromArray(array: &allSelectedOptionArray!, element: selectedElement)
            for i in 0..<elementArray.count {
                if (selectedOptionArray?.contains(elementArray[i].name ?? "") ?? false) {
                    elementArray[i].isSelected = true
                }
                else
                {
                    elementArray[i].isSelected = false
                }
            }
            
            self.optionTableView.reloadData()
            setSelectedElementOnScrollView()
        }
    }
    
    
    func setSelectedElementOnScrollView() {
        prevFrame = CGRect.init(x: 0, y: 0, width: 0, height: 0)
        let scrollviewWidth = self.selectedOptionScrollView.frame.width
        for subview in self.scrollViewContentView.subviews {
            if let label = (subview as? UILabel){
                label.removeFromSuperview()
            }
        }
        
        var maxY : CGFloat = 0.0
        //        selectedOptionArray?.reverse()
        for selectedOption in allSelectedOptionArray ?? [] {
            let selectedElementLabel = UILabel.init()
            let str: AttrString = """
            \(selectedOption, .color(.white), .font(.systemFont(ofSize: 13, weight: .light)))   \("x",.color(UIColor.white), .font(UIFont.systemFont(ofSize: UIView.fontHeight(height: 13), weight: .medium)))
            """
            selectedElementLabel.font = UIFont.systemFont(ofSize: 13.0, weight: .light)
            selectedElementLabel.attributedText = str.attributedString
            selectedElementLabel.textColor = .white
            selectedElementLabel.backgroundColor = .Appcolor
            selectedElementLabel.textAlignment = .center
            selectedElementLabel.numberOfLines = 0
            selectedElementLabel.layer.cornerRadius = 5
            selectedElementLabel.clipsToBounds = true
            selectedElementLabel.isUserInteractionEnabled = true
            let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(self.removeElemnetFromScrollview(_:)))
            selectedElementLabel.addGestureRecognizer(tapGesture)
            let maximumLabelSize: CGSize = CGSize(width: (scrollviewWidth - 40), height: 9999)
            let expectedLabelSize: CGSize = selectedElementLabel.sizeThatFits(maximumLabelSize)
            // create a frame that is filled with the UILabel frame data
            var newFrame: CGRect = selectedElementLabel.frame
            // resizing the frame to calculated size
            newFrame.size = CGSize.init(width: (expectedLabelSize.width + 20), height: (expectedLabelSize.height + 15))
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
            maxY = (selectedElementLabel.frame.maxY + 10)
            scrollViewContentView.addSubview(selectedElementLabel)
        }
        contentViewHeight.constant = maxY
        if maxY < (self.frame.height * 0.3){
            selectedOptionScrollViewHeight.constant = maxY
        }
        else
        {
            selectedOptionScrollView.flashScrollIndicators()
        }
        //        selectedOptionArray?.reverse()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        request?.cancel()
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
