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
    
    var activityIndicator : UIActivityIndicatorView!
    var activityIndicatorSize : CGFloat = 40
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Chats"
        
        tableView.delegate = self
        tableView.dataSource = self

        setRightNavigationButton()

        activityIndicator = UIActivityIndicatorView.init(activityIndicatorStyle: .gray)
        activityIndicator.frame = CGRect(x: self.view.frame.midX - activityIndicatorSize/2, y: self.view.frame.midY - activityIndicatorSize , width: 40, height: 40)
        tableView.addSubview(activityIndicator)
        
        observeChats()
        
        refreshDataSource()
        
    }
    
    func  refreshDataSource() {
        chats = CoreDataManager.sharedManager.fetchChats()
        self.tableView.reloadData()
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

        chatRefHandle = chatRef.observe(.childAdded, with: { [unowned self] (snapshot) -> Void in
            let chatData = snapshot.value as! Dictionary<String, AnyObject>
            let id = snapshot.key
            let name = chatData["name"] as! String?
            let number = chatData["number"] as! String?
            let chatDataDict : [String : Any] = ["name":name ?? "","number":number ?? "","chatId":id]
        
        CoreDataManager.sharedManager.insertChatWithProperties(propertyDict: chatDataDict){
               [unowned self] chat in
            self.refreshDataSource()
        }
            self.activityIndicator.stopAnimating()
        })
    }
    
    func showChatViewController (chat : Chat) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let chatViewController = storyboard.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
        chatViewController.senderDisplayName = senderDisplayName
        chatViewController.chat = chat
        chatViewController.chatRef = chatRef.child(chat.chatId!)

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


