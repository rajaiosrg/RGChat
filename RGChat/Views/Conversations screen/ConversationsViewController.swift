//
//  ConversationsViewController.swift
//  RGChat
//
//  Created by Raja Earla on 11/07/18.
//  Copyright © 2018 Raja Earla. All rights reserved.
//

import UIKit
import Firebase

class ConversationsViewController: UIViewController {
    
    var senderDisplayName: String?
    var senderId: String?

    let rowHeight : CGFloat = 50    
    @IBOutlet weak var tableView: UITableView!
    
    private var chatRefHandle: DatabaseHandle?
    private var chats: [Chat] = []
    private lazy var chatRef: DatabaseReference = Database.database().reference().child("chats")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Chats"
        
        setRightNavigationButton()
        observeChats()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func setRightNavigationButton()  {
        let rightButton = UIButton(type: .custom);
        rightButton.setTitle("Add", for: .normal)
        rightButton.setTitleColor(UIColor.red, for: .normal)
        rightButton.addTarget(self, action: #selector(handleRightButtonAction), for: .touchUpInside)
        
        let rightBarButtonItem = UIBarButtonItem(customView: rightButton)
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
        
        
        self.navigationController?.navigationBar.backItem?.hidesBackButton = true
        self.navigationItem.leftBarButtonItems = []
        self.navigationItem.hidesBackButton = true

    }
    
    @objc func handleRightButtonAction () {
        
        let alertController = UIAlertController(title: "Start new Channel", message: "", preferredStyle: UIAlertControllerStyle.alert)
        
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Enter Channel Name"
        }
        
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Enter Channel id"
        }
        
        let saveAction = UIAlertAction(title: "Create", style: UIAlertActionStyle.default, handler: { alert -> Void in
            let firstTextField = alertController.textFields![0] as UITextField
            let secondTextField = alertController.textFields![1] as UITextField
            
            guard let name = firstTextField.text else {
                return
            }
            guard let number = secondTextField.text else {
                return
            }
            
            let isExists = self.checkUserExists(number: number)
            if (!isExists) {
                if name.count > 0 && number.count > 0 {
                    self.createChat(nameString: name, number: number)
                }
            }
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.destructive, handler: {
            (action : UIAlertAction!) -> Void in
            
        })
        
        alertController.addAction(cancelAction)
        alertController.addAction(saveAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    func checkUserExists(number: String) -> Bool {
        var isExists : Bool = false
        let fileredChats = self.chats.filter { $0.number == number}
        isExists = fileredChats.count > 0
        return isExists
    }
    
    func createChat(nameString: String, number : String) {
        let newChatRef = chatRef.childByAutoId()
        let chatItem = [
            "name": nameString ,
            "number" : number
            ] as [String : Any]
        newChatRef.setValue(chatItem)
    }
    
    private func observeChats() {
        chatRefHandle = chatRef.observe(.childAdded, with: { (snapshot) -> Void in
            let chatData = snapshot.value as! Dictionary<String, AnyObject>
            let id = snapshot.key
            guard let number = chatData["number"] as! String? else {
                print("number shuould not be empty")
                return
            }
            if let name = chatData["name"] as! String?, name.count > 0 {
                self.chats.append(OneToOneChat(chatId : id, name : name, number : number))
                self.tableView.reloadData()
            } else {
                print("Error! Could not decode channel data")
            }
        })
    }
    
    func showChatViewController (chat : Chat) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let chatViewController = storyboard.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
        chatViewController.senderDisplayName = senderDisplayName
        chatViewController.chat = chat
        chatViewController.chatRef = chatRef.child(chat.chatId)

        self.navigationController?.pushViewController(chatViewController, animated: true)
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        if let refHandle = chatRefHandle {
            chatRef.removeObserver(withHandle: refHandle)
        }
    }
}

extension ConversationsViewController : UITableViewDataSource {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.chats.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let chat = self.chats[indexPath.row]
        let viewModel : ConversationViewModelProtocol = ConversationViewModelFactory().viewModelForChat(chat)!
        
        let tableViewCell = ConversationsCell(style: UITableViewCellStyle.default, reuseIdentifier: viewModel.cellIdentifier)
        tableViewCell.nameLabel.text = chat.name
        return tableViewCell
    }}

extension ConversationsViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let chat = self.chats[indexPath.row]
        showChatViewController(chat: chat)
    }
}

