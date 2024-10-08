//
//  ChatViewController.swift
//  MCH
//
//  Created by Akshay Gawade on 25/11/19.
//  Copyright © 2019 Akshay Gawade. All rights reserved.
//

import UIKit
import MessageKit
import InputBarAccessoryView


class ChatViewController: MessagesViewController, MessagesDataSource {
    enum ViewType {
        case DatePicker
        case YesNo
    }
    var datePicker: UIDatePicker?
    var yesNoPopup : YesNoView?
    var currentQuestion : Datum?
    var questions : Question?
    var changeMessageCollectionInset = false
    var viewType : ViewType?
    let storyboardIds = Constants.StoryboardId.self
    let botUser = ChatUser(senderId: "000000", displayName: "Anaha", lastName: "")
    var currentUser = ChatUser(senderId: "000001", displayName: "Guest", lastName: "")
    var userDictionary: [String: Any] = [:]
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    /// The `BasicAudioController` controll the AVAudioPlayer state (play, pause, stop) and udpate audio cell UI accordingly.
    open lazy var audioController = BasicAudioController(messageCollectionView: messagesCollectionView)
    
    var messageList: [ChatMessage] = []
    
    let refreshControl = UIRefreshControl()
    
    let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
    
    //MARK:- lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        configureMessageCollectionView()
        configureMessageInputBar()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidHide), name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    
    @objc func keyboardDidHide(notification: Notification?) {
        debugPrint("keyboard","keyboardDidHide")
        //set collectionnview inset with respective presenting userinput
        if changeMessageCollectionInset{
            switch self.viewType {
            case .DatePicker:
                self.changeMessageCollectionInset = false
                let deadlineTime = DispatchTime.now() + .milliseconds(20)
                let collectionViewInset = self.messagesCollectionView.contentInset
                let insetForDatePicker = (collectionViewInset.bottom + (self.datePicker?.frame.height)!)
                let contenOffset = CGPoint.init(x: 0, y: (self.messagesCollectionView.contentOffset.y + insetForDatePicker))
                if self.messagesCollectionView.contentInset.bottom != insetForDatePicker {
                    DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
                        UIView.animate(withDuration: 0.2) {
                            self.messagesCollectionView.contentInset.bottom = insetForDatePicker
                            self.messagesCollectionView.contentOffset = contenOffset
                            self.datePicker?.frame.origin = CGPoint.init(x: 0, y: (self.view.frame.height - (self.datePicker?.frame.height)!))
                        }
                    }
                }
                debugPrint(self.messagesCollectionView.contentInset)
            case .YesNo:
                self.changeMessageCollectionInset = false
                let deadlineTime = DispatchTime.now() + .milliseconds(20)
                let collectionViewInset = self.messagesCollectionView.contentInset
                let insetForYesNoView = (collectionViewInset.bottom + (self.yesNoPopup?.frame.height)!)
                let contenOffset = CGPoint.init(x: 0, y: (self.messagesCollectionView.contentOffset.y + insetForYesNoView))
                if self.messagesCollectionView.contentInset.bottom != insetForYesNoView {
                    DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
                        UIView.animate(withDuration: 0.2) {
                            self.messagesCollectionView.contentInset.bottom = insetForYesNoView
                            self.messagesCollectionView.contentOffset = contenOffset
                            self.datePicker?.frame.origin = CGPoint.init(x: 0, y: (self.view.frame.height - (self.datePicker?.frame.height)!))
                        }
                    }
                }
                debugPrint(self.messagesCollectionView.contentInset)
            default:
                self.messagesCollectionView.scrollToBottom(animated: true)
                UIView.animate(withDuration: 0.2) {
                    self.messagesCollectionView.contentInset.bottom = self.messageInputBar.frame.height
                }
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
    }
    
    //MARK:- configure chat
    func getuniqueID() -> String{
        return UUID().uuidString
    }
    
    func getDate() -> Date {
        return Date.init()
    }
    
    func loadFirstMessages() {
        var messages: [ChatMessage] = []
        self.messageInputBar.isHidden = false
        if let messageText = currentQuestion?.questionText {
            let message = ChatMessage(text: messageText, user: botUser, messageId: getuniqueID(), date: getDate())
            messages.append(message)
        }
        self.messageList = messages
        self.messagesCollectionView.reloadData()
        self.messagesCollectionView.scrollToBottom()
    }
    
    func configureMessageCollectionView() {
        
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messageCellDelegate = self
        
        scrollsToBottomOnKeyboardBeginsEditing = true // default false
        maintainPositionOnKeyboardFrameChanged = true // default false
        
        messagesCollectionView.addSubview(refreshControl)
        //        refreshControl.addTarget(self, action: #selector(loadMoreMessages), for: .valueChanged)
    }
    
    func configureMessageInputBar() {
        messageInputBar.inputTextView.tintColor = UIColor.Appcolor
        messageInputBar.sendButton.setTitleColor(UIColor.Appcolor, for: .normal)
        messageInputBar.sendButton.setTitleColor(
            UIColor.Appcolor.withAlphaComponent(0.3),
            for: .highlighted
        )
    }
    
    //MARK:- Questions type view methods
    func insertQuestion() {
        if var messageText = self.currentQuestion?.questionText {
            messageText = messageText.replacingOccurrences(of: "{fname}", with: currentUser.displayName).replacingOccurrences(of: "{lname}", with: currentUser.lastName).replacingOccurrences(of: "{partner_fname}", with: (userDictionary["partnerFname"] as? String ?? "")).replacingOccurrences(of: "{partner_fname}", with: (userDictionary["partnerFname"] as? String ?? ""))
            let message = ChatMessage(text: messageText, user: botUser, messageId: getuniqueID(), date: getDate())
            insertMessage(message)
        }
    }
    
    func setInputMethod() {
        switch  self.currentQuestion?.family ?? ""{
        case "yesNo" :
            insertQuestion()
            self.setYesNoPopUp()
            
        case "userInput" :
            self.messageInputBar.isHidden = false
            insertQuestion()
        case "datePicker":
            insertQuestion()
            self.setDatePicker()
        default:
            self.messageInputBar.isHidden = false
        }
    }
    
    func getQuestion(onIndex index: Int) ->  Datum?{
        var selectedDatum : Datum?
        for question in questions?.data ?? [] {
            if question.questionId == index
            {
                selectedDatum = question
                break
            }
        }
        return selectedDatum
    }
    
    //MARK:- set pickers
    func setDatePicker() {
        // Create a DatePicker
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .date
        // Set some of UIDatePicker properties
        datePicker?.timeZone = NSTimeZone.local
        datePicker?.backgroundColor = UIColor.white
        datePicker?.frame = CGRect.init(x: 0, y: 2000, width: self.view.frame.width, height: (datePicker?.frame.height)!)
        // Add an event to call onDidChangeDate function when value is changed.
        datePicker?.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        // Add DataPicker to the view
        self.view.addSubview(datePicker!)
        self.datePicker?.superview?.bringSubviewToFront(self.datePicker!)
        if  !self.changeMessageCollectionInset {
            self.viewType = .DatePicker
            self.changeMessageCollectionInset = true
            self.messageInputBar.inputTextView.resignFirstResponder()
            self.messageInputBar.isHidden = true
        }
        if  !self.changeMessageCollectionInset {
            self.keyboardDidHide(notification: nil)
        }
    }
    
    func setSearchPopup(type : searchType) {
        let storyboard = UIStoryboard(name:Constants.storyboardName , bundle: nil)
        guard let searchPopupController = storyboard.instantiateViewController(withIdentifier: self.storyboardIds.searchPopUp.rawValue) as? SearchPopupScreen else { return }
        searchPopupController.type = type
        searchPopupController.completionHandler = {(selectedOption) in
            debugPrint(selectedOption)
            self.messageInputBar.isHidden = false
        }
        self.navigationController?.present(searchPopupController, animated: true, completion: {
        })
    }
    
    func setYesNoPopUp() {
        
        let height = (self.view.frame.width  * 0.2)
        let safeGuide = self.view.safeAreaLayoutGuide
        let y = (self.view.frame.height - (height + safeGuide.layoutFrame.minY))
        yesNoPopup = YesNoView.init(frame: CGRect.init(x: 0, y: y, width: self.view.frame.width, height: height))
        self.view.addSubview(yesNoPopup!)
        //MARK:- yesno option click
        //if user chooses yes option
        yesNoPopup!.yesButtonAction = {
            self.yesNoPopup!.removeFromSuperview()
            if self.currentQuestion?.showList == 1 {
                self.messageInputBar.isHidden = true
                switch self.currentQuestion?.listType {
                case "surgicalHistory":
                    self.setSearchPopup(type: .surgery)
                case "familyMedicalHistory":
                    self.setSearchPopup(type: .disease)
                case "allergies":
                    self.setSearchPopup(type: .disease)
                case "medication":
                    self.setSearchPopup(type: .medicine)
                default:
                    break
                }
            }
            else
            {
                self.messageInputBar.isHidden = false
            }
        }
        //if user chooses no option
        yesNoPopup!.noButtonAction = {
            self.yesNoPopup!.removeFromSuperview()
            self.messageInputBar.isHidden = false
        }
        
        if  !self.changeMessageCollectionInset {
            self.viewType = .YesNo
            self.changeMessageCollectionInset = true
            self.messageInputBar.inputTextView.resignFirstResponder()
            self.messageInputBar.isHidden = true
        }
        if  !self.changeMessageCollectionInset {
            self.keyboardDidHide(notification: nil)
        }
    }
    
    //MARK:- datepicker value selected
    @objc func datePickerValueChanged(_ sender: UIDatePicker){
        // Create date formatter
        let dateFormatter: DateFormatter = DateFormatter()
        
        // Set date format
        dateFormatter.dateFormat = "MM/dd/yyyy"
        
        // Apply date format
        let selectedDate: String = dateFormatter.string(from: sender.date)
        
        print("Selected value \(selectedDate)")
        self.datePicker?.removeFromSuperview()
        self.datePicker = nil
        self.messageInputBar.isHidden = false
        //insert selected date in message
        let message = ChatMessage(text: selectedDate, user: currentUser, messageId: getuniqueID(), date: getDate())
        insertMessage(message)
        //add selected date to answer dictionary
        self.userDictionary[self.currentQuestion!.key ?? "unknown"] =  selectedDate
        debugPrint("dict =", self.userDictionary)
        //set collectionviewinset to normal
        UIView.animate(withDuration: 0.2) {
            self.messagesCollectionView.contentInset.bottom = self.messageInputBar.frame.height
        }
        //get next question
        if let nextIndex = self.currentQuestion?.nextQuestion?.defaultField
        {
            self.currentQuestion =  self.getQuestion(onIndex: nextIndex)
        }
        self.setInputMethod()
    }
    
    
    
    // MARK: - Helpers
    
    func insertMessage(_ message: ChatMessage) {
        messageList.append(message)
        // Reload last section to update header/footer labels and insert a new one
        messagesCollectionView.performBatchUpdates({
            messagesCollectionView.insertSections([messageList.count - 1])
            if messageList.count >= 2 {
                messagesCollectionView.reloadSections([messageList.count - 2])
            }
        }, completion: { [weak self] _ in
            if self?.isLastSectionVisible() == true {
                self?.messagesCollectionView.scrollToBottom(animated: true)
            }
        })
    }
    
    func isLastSectionVisible() -> Bool {
        
        guard !messageList.isEmpty else { return false }
        
        let lastIndexPath = IndexPath(item: 0, section: messageList.count - 1)
        
        return messagesCollectionView.indexPathsForVisibleItems.contains(lastIndexPath)
    }
    
    // MARK: - MessagesDataSource
    
    func currentSender() -> SenderType {
        return currentUser
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messageList.count
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messageList[indexPath.section]
    }
    
    func cellTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        if indexPath.section % 3 == 0 {
            return NSAttributedString(string: MessageKitDateFormatter.shared.string(from: message.sentDate), attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 10), NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        }
        return nil
    }
    
    func cellBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        
        return NSAttributedString(string: "Read", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 10), NSAttributedString.Key.foregroundColor: UIColor.darkGray])
    }
    
    func messageTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        let name = message.sender.displayName
        return NSAttributedString(string: name, attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .caption1)])
    }
    
    func messageBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        
        let dateString = formatter.string(from: message.sentDate)
        return NSAttributedString(string: dateString, attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .caption2)])
    }
    
}

// MARK: - MessageCellDelegate

extension ChatViewController: MessageCellDelegate {
    
    func didTapAvatar(in cell: MessageCollectionViewCell) {
        print("Avatar tapped")
    }
    
    func didTapMessage(in cell: MessageCollectionViewCell) {
        print("Message tapped")
    }
    
    func didTapCellTopLabel(in cell: MessageCollectionViewCell) {
        print("Top cell label tapped")
    }
    
    func didTapCellBottomLabel(in cell: MessageCollectionViewCell) {
        print("Bottom cell label tapped")
    }
    
    func didTapMessageTopLabel(in cell: MessageCollectionViewCell) {
        print("Top message label tapped")
    }
    
    func didTapMessageBottomLabel(in cell: MessageCollectionViewCell) {
        print("Bottom label tapped")
    }
    
    func didTapPlayButton(in cell: AudioMessageCell) {
        guard let indexPath = messagesCollectionView.indexPath(for: cell),
            let message = messagesCollectionView.messagesDataSource?.messageForItem(at: indexPath, in: messagesCollectionView) else {
                print("Failed to identify message when audio cell receive tap gesture")
                return
        }
        guard audioController.state != .stopped else {
            // There is no audio sound playing - prepare to start playing for given audio message
            audioController.playSound(for: message, in: cell)
            return
        }
        if audioController.playingMessage?.messageId == message.messageId {
            // tap occur in the current cell that is playing audio sound
            if audioController.state == .playing {
                audioController.pauseSound(for: message, in: cell)
            } else {
                audioController.resumeSound()
            }
        } else {
            // tap occur in a difference cell that the one is currently playing sound. First stop currently playing and start the sound for given message
            audioController.stopAnyOngoingPlaying()
            audioController.playSound(for: message, in: cell)
        }
    }
    
    func didStartAudio(in cell: AudioMessageCell) {
        print("Did start playing audio sound")
    }
    
    func didPauseAudio(in cell: AudioMessageCell) {
        print("Did pause audio sound")
    }
    
    func didStopAudio(in cell: AudioMessageCell) {
        print("Did stop audio sound")
    }
    
    func didTapAccessoryView(in cell: MessageCollectionViewCell) {
        print("Accessory view tapped")
    }
    
}

// MARK: - MessageLabelDelegate

extension ChatViewController: MessageLabelDelegate {
    
    func didSelectAddress(_ addressComponents: [String: String]) {
        print("Address Selected: \(addressComponents)")
    }
    
    func didSelectDate(_ date: Date) {
        print("Date Selected: \(date)")
    }
    
    func didSelectPhoneNumber(_ phoneNumber: String) {
        print("Phone Number Selected: \(phoneNumber)")
    }
    
    func didSelectURL(_ url: URL) {
        print("URL Selected: \(url)")
    }
    
    func didSelectTransitInformation(_ transitInformation: [String: String]) {
        print("TransitInformation Selected: \(transitInformation)")
    }
    
    func didSelectHashtag(_ hashtag: String) {
        print("Hashtag selected: \(hashtag)")
    }
    
    func didSelectMention(_ mention: String) {
        print("Mention selected: \(mention)")
    }
    
    func didSelectCustom(_ pattern: String, match: String?) {
        print("Custom data detector patter selected: \(pattern)")
    }
    
}

