//
//  SignupMessageControllerViewController.swift
//  MCH
//
//  Created by Akshay Gawade on 25/11/19.
//  Copyright © 2019 Akshay Gawade. All rights reserved.
//

import UIKit
import MessageKit
import InputBarAccessoryView

class SignupMessageController: ChatViewController {
    var datePicker: UIDatePicker?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        messageInputBar.delegate = self
    }
    
    override func configureMessageCollectionView() {
        super.configureMessageCollectionView()
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        //        messagesCollectionView.backgroundColor = .clear
        //        self.view.backgroundColor = .Appcolor
    }
    
    //MARK:- set pickers
    func setDatePicker() {
        // Create a DatePicker
        datePicker = UIDatePicker()
        
        // Set some of UIDatePicker properties
        datePicker?.timeZone = NSTimeZone.local
        datePicker?.backgroundColor = UIColor.white
        
        // Add an event to call onDidChangeDate function when value is changed.
        datePicker?.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        
        // Add DataPicker to the view
        self.view.addSubview(datePicker!)
        datePicker?.translatesAutoresizingMaskIntoConstraints = false
        let leadingConstraint = NSLayoutConstraint(item: datePicker!, attribute: NSLayoutConstraint.Attribute.leading, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.leading, multiplier: 1, constant: 0)
        //        let bottomConstraint = NSLayoutConstraint(item: datePicker, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1, constant: 0)
        let triailingConstraint = NSLayoutConstraint(item: datePicker!, attribute: NSLayoutConstraint.Attribute.trailing, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.trailing, multiplier: 1, constant: 0)
        NSLayoutConstraint.activate([leadingConstraint, triailingConstraint])
        
        let safeGuide = self.view.safeAreaLayoutGuide
        datePicker?.bottomAnchor.constraint(equalTo: safeGuide.bottomAnchor).isActive = true
        
    }
    
    func setDiseasePopup() {
        let searchBarPopUp = SearchPopUp.init(frame: CGRect.init(x: 0, y: self.view.frame.height - (self.view.frame.height * 0.7), width: self.view.frame.width, height: (self.view.frame.height * 0.7)))
        let blurView = UIView.init(frame: self.view.frame)
        searchBarPopUp.cancelClicked = {
            searchBarPopUp.removeFromSuperview()
            blurView.removeFromSuperview()
            self.messageInputBar.isHidden = false
        }
        blurView.backgroundColor = .Blur
        self.view.addSubview(blurView)
        self.view.addSubview(searchBarPopUp)
    }
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker){
        
        // Create date formatter
        let dateFormatter: DateFormatter = DateFormatter()
        
        // Set date format
        dateFormatter.dateFormat = "MM/dd/yyyy hh:mm a"
        
        // Apply date format
        let selectedDate: String = dateFormatter.string(from: sender.date)
        
        print("Selected value \(selectedDate)")
        self.datePicker?.removeFromSuperview()
        self.messageInputBar.isHidden = false
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

// MARK: - MessagesDisplayDelegate

extension SignupMessageController: MessagesDisplayDelegate {
    
    // MARK: - Text Messages
    
    func textColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? UIColor.Appcolor : .white
    }
    
    func detectorAttributes(for detector: DetectorType, and message: MessageType, at indexPath: IndexPath) -> [NSAttributedString.Key: Any] {
        switch detector {
        case .hashtag, .mention: return [.foregroundColor: UIColor.blue]
        default: return MessageLabel.defaultAttributes
        }
    }
    
    func enabledDetectors(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> [DetectorType] {
        return [.url, .address, .phoneNumber, .date, .transitInformation, .mention, .hashtag]
    }
    
    // MARK: - All Messages
    
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? UIColor.white : UIColor.Appcolor
    }
    
    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        
        let tail: MessageStyle.TailCorner = isFromCurrentSender(message: message) ? .bottomRight : .bottomLeft
        return .bubbleTail(tail, .pointedEdge)
    }
    
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        //        let avatar = SampleData.shared.getAvatarFor(sender: message.sender)
        if message.sender.senderId == "000000" {
            let avatar = Avatar.init(image: nil , initials: "A")
            avatarView.set(avatar: avatar)
            avatarView.backgroundColor = UIColor.Appcolor
        }
        else {
            let currentUserIntials = currentUser.displayName.uppercased().map { String($0) }[0]
            let avatar = Avatar.init(image: nil , initials: "\(currentUserIntials)")
            avatarView.set(avatar: avatar)
            avatarView.backgroundColor = UIColor.Appcolor
        }
    }
}

// MARK: - MessagesLayoutDelegate
extension SignupMessageController: MessagesLayoutDelegate {
    
    func cellTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        //        return 18
        return 0
    }
    
    func cellBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        //        return 17
        return 0
    }
    
    func messageTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        //        return 20
        return 0
    }
    
    func messageBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        //        return 16
        return 0
    }
    
}


// MARK: - MessageInputBarDelegate

extension SignupMessageController : InputBarAccessoryViewDelegate {
    
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        
        // Here we can parse for which substrings were autocompleted
        let attributedText = messageInputBar.inputTextView.attributedText!
        let range = NSRange(location: 0, length: attributedText.length)
        attributedText.enumerateAttribute(.autocompleted, in: range, options: []) { (_, range, _) in
            
            let substring = attributedText.attributedSubstring(from: range)
            let context = substring.attribute(.autocompletedContext, at: 0, effectiveRange: nil)
            print("Autocompleted: `", substring, "` with context: ", context ?? [])
        }
        
        let components = inputBar.inputTextView.components
        messageInputBar.inputTextView.text = String()
        messageInputBar.invalidatePlugins()
        
        // Send button activity animation
        messageInputBar.sendButton.startAnimating()
        messageInputBar.inputTextView.placeholder = "Sending..."
        DispatchQueue.global(qos: .default).async {
            // fake send request task
            sleep(1)
            DispatchQueue.main.async { [weak self] in
                self?.messageInputBar.sendButton.stopAnimating()
                self?.messageInputBar.inputTextView.placeholder = "Aa"
                self?.insertMessages(components)
                self?.messageInputBar.isHidden = true
                //                self?.setDatePicker()
                self?.setDiseasePopup()
                self?.messagesCollectionView.scrollToBottom(animated: true)
            }
        }
    }
    
    private func insertMessages(_ data: [Any]) {
        for component in data {
            if currentUser.displayName == "Guest" {
                currentUser.displayName = component as? String ?? ""
            }
            let user = currentUser
            if let str = component as? String {
                let message = ChatMessage(text: str, user: user, messageId: UUID().uuidString, date: Date())
                insertMessage(message)
            } else if let img = component as? UIImage {
                let message = ChatMessage(image: img, user: user, messageId: UUID().uuidString, date: Date())
                insertMessage(message)
            }
        }
    }
}

