//
//  SerachPopUp.swift
//  MCH
//
//  Created by Akshay Gawade on 14/12/19.
//  Copyright © 2019 Akshay Gawade. All rights reserved.
//

import UIKit
import Alamofire

struct ElementOption {
    var id : String?
    var name : String?
    var isSelected = false
}

public enum searchType {
    case surgery
    case disease
    case medicine
}


class SearchPopUp: UIView, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate {
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
        @IBOutlet weak var loader: UIActivityIndicatorView!
        @IBOutlet weak var loaderCover: UIView!
    
    var prevSearchText  = ""
    var type : searchType?
    let constant = Constants.SearchApi.self
    var request : DataRequest?
    var prevFrame = CGRect.init(x: 0, y: 0, width: 0, height: 0)
    var elementArray = [ElementOption]()
    var cellIdentifier = "optionsCell"
    var cancelClicked : (([String])->())?
    var selectedOptionArray : [String]?
    var allSelectedOptionArray : [String]?
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
        self.selectedOptionScrollView.delegate = self
        self.selectedOptionScrollView.indicatorStyle = .black
        //        optionTableView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
    }
    
    //    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
    //        if keyPath == "contentSize" && ((object as? UITableView) != nil) {
    //
    //        }
    //    }
    
    //MARK:- UISearchBarDelegate methods
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
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
    
    func searchDisease(searchText : String) {
        let url: String = constant.disease.rawValue + searchText
        self.request = NetworkLayer.shared.getRequestWith(nil, url) { (json, error, request) in
            DispatchQueue.main.async {
                if (error != nil) {
                    debugPrint(error!.localizedDescription)
                }
                else
                {
                    guard let jsonResponse = json else {
                        return
                    }
                    let requestSearchString = request?.request?.url?.absoluteString.components(separatedBy: "terms=")
                    debugPrint("search response = \(requestSearchString)")
                    if requestSearchString != nil && (requestSearchString?.count ?? 0) > 1 && self.searchString == (requestSearchString?[1] ?? "" ) {
                        self.elementArray.removeAll()
                        for i in 0 ..< jsonResponse.arrayValue[3].count {
                            if let name = jsonResponse.arrayValue[3].arrayValue[i].arrayValue[1].string{
                                let id = jsonResponse.arrayValue[3].arrayValue[i].arrayValue[0].string ?? "\(i)"
                                let elementOption = ElementOption.init(id:id , name: name)
                                self.elementArray.append(elementOption)
                                self.selectedOptionArray = [String]()
                            }
                        }
                        self.optionTableView.reloadData()
                    }
                }
            }
        }
    }
    
    func searchSurgery(searchText : String) {
        let url: String = constant.surgery.rawValue.replacingOccurrences(of: "surgery", with: searchText)
        self.request = NetworkLayer.shared.getRequestWith(nil, url) { (json, error, request) in
            DispatchQueue.main.async {
                if (error != nil) {
                    debugPrint(error!.localizedDescription)
                }
                else
                {
                    guard let jsonResponse = json else {
                        return
                    }
                    let requestSearchString = request?.request?.url?.absoluteString.components(separatedBy: "term=")[1].components(separatedBy: "&")[0]
                    debugPrint("search response = \(requestSearchString)")
                    if requestSearchString != nil && self.searchString == requestSearchString {
                        self.elementArray.removeAll()
                        for item in jsonResponse["items"].arrayValue {
                            let name = item["concept"]["fsn"]["term"].string
                            let id = item["concept"]["id"].string
                            let elementOption = ElementOption.init(id:id , name: name)
                            self.elementArray.append(elementOption)
                            self.selectedOptionArray = [String]()
                        }
                        self.optionTableView.reloadData()
                    }
                }
            }
        }
    }
    
    func getAutoComplete(searchText : String)  {
        if searchText != "" {
            switch type {
            case .surgery:
                self.request?.cancel()
                print("search response = \(prevSearchText) - \(searchText)")
                if self.prevSearchText != searchText {
                    self.searchSurgery(searchText: searchText)
                    self.prevSearchText = searchText
                }
            case .disease:
                self.request?.cancel()
                print("search response = \(prevSearchText) - \(searchText)")
                if self.prevSearchText != searchText {
                    searchDisease(searchText: searchText)
                    self.prevSearchText = searchText
                }
            case .medicine:
                searchDisease(searchText: searchText)
            case .none:
                break
            }
        }
        else
        {
            DispatchQueue.main.async {
                self.request?.cancel()
                self.elementArray.removeAll()
                self.optionTableView.reloadData()
                self.setSelectedElementOnScrollView()
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
            if (allSelectedOptionArray?.contains(name) ?? false)
            {
                elementArray[indexPath.row].isSelected = true
            }
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
        if maxY < (self.frame.height * 0.15){
            selectedOptionScrollViewHeight.constant = maxY
        }
        else
        {
            selectedOptionScrollView.flashScrollIndicators()
            DispatchQueue.main.async {
                self.selectedOptionScrollView.setContentOffset(CGPoint.init(x: 0.0, y: (maxY - (self.frame.height * 0.11)) ), animated:true)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.endEditing(true)
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
        self.cancelClicked?(allSelectedOptionArray ?? [])
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        self.cancelClicked?(allSelectedOptionArray ?? [])
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.endEditing(true)
    }
}
