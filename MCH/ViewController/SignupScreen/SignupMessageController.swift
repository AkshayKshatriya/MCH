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
import SwiftyJSON

class SignupMessageController: ChatViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        messageInputBar.delegate = self
        
        if let path = Bundle.main.path(forResource: "questions", ofType: "json") {
            do {
                let jsonData = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
                do
                {
                    let json = try JSON(data: jsonData)
                    self.questions = Question.init(fromJson: json)
                    debugPrint(questions)
                    self.currentQuestion = getQuestion(onIndex: 1)
                }
                catch let error {
                    debugPrint(error)
                }
            } catch {
                print(error)
            }
        }
        loadFirstMessages()
    }
    
    override func configureMessageCollectionView() {
        super.configureMessageCollectionView()
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        //        messagesCollectionView.backgroundColor = .clear
        //        self.view.backgroundColor = .Appcolor
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        guard let searchPopupScreen = segue.destination as? SearchPopupScreen else {return}
        
    }
    
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
                self?.messagesCollectionView.scrollToBottom(animated: true)
                //TODO:- set next question
                debugPrint(components)
                self!.userDictionary[self?.currentQuestion!.key ?? "unknown"] =  components[0] as? String ?? ""
                debugPrint("dict =", self!.userDictionary)
                self?.setInputMethod()
            }
        }
    }
    
    private func insertMessages(_ data: [Any]) {
        for component in data {
            if currentUser.displayName == "Guest" {
                currentUser.displayName = component as? String ?? ""
            }
            if currentQuestion?.questionText.contains("may I know your surname?") ?? false
            {
                currentUser.lastName = component as? String ?? ""
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

