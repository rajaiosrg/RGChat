//
//  ChatViewController.swift
//  RGChat
//
//  Created by Raja Earla on 11/07/18.
//  Copyright © 2018 Raja Earla. All rights reserved.
//

import UIKit
import Firebase

class ChatViewController: UIViewController {

    @IBOutlet weak var chatTableView: UITableView!
    @IBOutlet var inputBar: UIView!
    
    @IBOutlet weak var sendButton: UIButton!
    

    @IBOutlet weak var inputTextField: UITextField!
    
    @IBOutlet weak var inputBarBottomConstraint: NSLayoutConstraint!
    
    let barHeight: CGFloat = 50

    
    var chatRef: DatabaseReference?
    var senderId : String!

    private var messages: [Message] = []
    
    var chat: Chat? {
        didSet {
            title = chat?.name
        }
    }
    var senderDisplayName : String!
    
    var chatDataSource : ChatViewDataSource!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.senderId =  UserManager().userNumber()
        configureUI()
        
        refreshDataSource()
        configureChatDataSource()
    }
    
    func refreshDataSource()  {
        self.messages =  CoreDataManager.sharedManager.fetchMessagesForChatId(chatId: (self.chat?.chatId)!)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.inputBar.backgroundColor = UIColor.clear
        NotificationCenter.default.addObserver(self, selector: #selector(ChatViewController.showKeyboard(notification:)), name: Notification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ChatViewController.hideKeyboard(notification:)), name: Notification.Name.UIKeyboardWillHide, object: nil)

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }

    
    func configureUI() {
        self.chatTableView.estimatedRowHeight = self.barHeight
        self.chatTableView.rowHeight = UITableViewAutomaticDimension
        self.chatTableView.contentInset.bottom = self.barHeight
        self.chatTableView.scrollIndicatorInsets.bottom = self.barHeight
        self.chatTableView.allowsSelection = false
        self.inputTextField.isEnabled = true
        self.sendButton.isUserInteractionEnabled = true
    }
    
    
    func configureChatDataSource() {
        let chatData = ChatData(chatRef : chatRef, channelId:self.chat?.chatId, senderId : senderId)
        chatDataSource = ChatViewDataSource(chatData : chatData)
        chatDataSource.dataFromChannelId( completionHandler: {[unowned self]  messagesArray -> () in
            DispatchQueue.main.async {
                guard let message = messagesArray.last else {return}
                self.refreshDataSource()
                self.chatTableView.reloadData()
            }
        })
    }
    
    //MARK: NotificationCenter handlers
    @objc func showKeyboard(notification: Notification) {
        if let frame = notification.userInfo![UIKeyboardFrameEndUserInfoKey] as? NSValue {
            let height = frame.cgRectValue.height
            self.chatTableView.contentInset.bottom = height
            self.chatTableView.scrollIndicatorInsets.bottom = height
            inputBarBottomConstraint?.constant = -height

            if self.messages.count > 0 {
                self.chatTableView.scrollToRow(at: IndexPath.init(row: self.messages.count - 1, section: 0), at: .bottom, animated: true)
            }
        }
    }
    
    @objc func hideKeyboard(notification: Notification) {
        if let frame = notification.userInfo![UIKeyboardFrameEndUserInfoKey] as? NSValue {
            let height = frame.cgRectValue.height
            self.chatTableView.contentInset.bottom = height
            self.chatTableView.scrollIndicatorInsets.bottom = height
            inputBarBottomConstraint?.constant = 0
            
            if self.messages.count > 0 {
                self.chatTableView.scrollToRow(at: IndexPath.init(row: self.messages.count - 1, section: 0), at: .bottom, animated: true)
            }
        }
    }
    
    func scrollToBottomAnimated(animated : Bool) {
        if self.chatTableView.numberOfSections == 0 {
            return
        }
       let lastIndexPath = NSIndexPath(item: self.chatTableView.numberOfRows(inSection: 0) - 1, section: 0)
        scrollToIndexPath(indexPath: lastIndexPath, animated: true)
    }
    
    func scrollToIndexPath(indexPath : NSIndexPath, animated : Bool) {
        var newIndexPath = indexPath
        if self.chatTableView.numberOfSections <= indexPath.section {
            return
        }
        
        let numberOfItems = self.chatTableView.numberOfRows(inSection: newIndexPath.section)
        if numberOfItems == 0 {
            return
        }
    
        
       let tableViewContentHeight = self.chatTableView.contentSize.height
        let isContentTooSmall = (tableViewContentHeight < self.chatTableView.bounds.size.height)
        
        if isContentTooSmall {
            self.chatTableView.scrollRectToVisible(CGRect(x: 0, y: tableViewContentHeight - 1.0, width: 1.0, height: 1.0), animated: true)
            return
        }
        let item = max(min(newIndexPath.item, numberOfItems-1), 0)
        newIndexPath = NSIndexPath(row: item, section: 0)
        
        let cellSize = self.chatTableView.cellForRow(at: newIndexPath as IndexPath)?.frame.size
        let maxHeightForVisibleMessage = self.chatTableView.frame.size.height - self.chatTableView.contentInset.top - self.chatTableView.contentInset.bottom - barHeight
        let scrollPosition : UITableViewScrollPosition = ((cellSize?.height)! > maxHeightForVisibleMessage) ? UITableViewScrollPosition.bottom : UITableViewScrollPosition.top
        self.chatTableView.scrollToRow(at: newIndexPath as IndexPath, at: scrollPosition, animated: animated)
    }
    
    @IBAction func didPressSendButton(_ sender: UIButton) {
       
        guard let messageText = self.inputTextField.text else {
            return
        }
       let messageString = messageText.trimmingCharacters(in: .whitespaces)
        if messageString.count > 0 {
            let sender = Sender(senderId : self.senderId, senderDisplayName : self.senderDisplayName, text : messageString, messageType : MessageType.Text)
            
            chatDataSource.sendMessageToUser(sender: sender) {
                self.scrollToBottomAnimated(animated: true)
            }
        }
        clearTextInPutBar()
        
    }
    
    func clearTextInPutBar() {
        self.inputTextField.text = nil
    }

    func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        
        let sender = Sender(senderId : senderId, senderDisplayName : senderDisplayName, text : text, messageType : MessageType.Text)

        chatDataSource.sendMessageToUser(sender: sender) {
            self.scrollToBottomAnimated(animated: true)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension ChatViewController : UITableViewDataSource {
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let message = messages[indexPath.item]
        let viewModel : ChatViewModelProtocol = ChatViewModelFactory().viewModelForMessage(message)!
        return ChatCellHelper().calculateCellHeight(viewModel: viewModel)
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.messages.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let message = messages[indexPath.item]
        let viewModel : ChatViewModelProtocol = ChatViewModelFactory().viewModelForMessage(message)!
        
        let cell = ChatCellFactory().cellForViewModel(viewModel: viewModel)
        cell?.bindWithViewModel(viewModel: viewModel)
        return cell!
    }
    

}


