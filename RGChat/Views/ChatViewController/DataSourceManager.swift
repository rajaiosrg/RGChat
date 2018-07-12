//
//  DataSourceManager.swift
//  RGChat
//
//  Created by Raja Earla on 11/07/18.
//  Copyright © 2018 Raja Earla. All rights reserved.
//

import Foundation
import Firebase

class DataSourceManager {
    
    public typealias MessageFetchClosure = (_ messages : [Message]) -> Void

    var chatRef: DatabaseReference?
    private lazy var messageRef: DatabaseReference = self.chatRef!.child("messages")
    fileprivate lazy var storageRef: StorageReference = Storage.storage().reference(forURL: "gs://rgchat-f908f.appspot.com")
    
    private var newMessageRefHandle: DatabaseHandle?
    private var updatedMessageRefHandle: DatabaseHandle?

    var channelId : String!
    var senderId : String!
    private var messages: [Message] = []
    var messageCompletionhandler : MessageFetchClosure?
    
    init(chatData : ChatData) {
        self.channelId = chatData.channelId
        self.senderId = chatData.senderId
        self.chatRef = chatData.chatRef
    }
    
    func dataFromChannelId(completionHandler: @escaping MessageFetchClosure) {
        messageCompletionhandler = completionHandler
        observeMessages()
    }

    func dataFromChannelId(chId : String, senderId : String) {
        channelId = chId
        observeMessages()
    }
    
    private func observeMessages() {
        messageRef = chatRef!.child("messages")
        let messageQuery = messageRef.queryLimited(toLast:25)
        
        newMessageRefHandle = messageQuery.observe(.childAdded, with: { (snapshot) -> Void in
            let messageData = snapshot.value as! Dictionary<String, String>
            
            if (!messageData.isEmpty) {
                let messageObj = Message()
                messageObj.initWithMessageData(messageData: messageData)
                self.messages.append(messageObj)
                
                self.messageCompletionhandler!(self.messages)
            } else {
                print("Error! Could not decode message data")
            }
        })
    }
    
    func sendMessage (sender : Sender, completionhandler : @escaping () -> Void) {
        
        let itemRef = messageRef.childByAutoId()
        let messageItem = [
            "senderId": sender.senderId,
            "senderName": sender.senderDisplayName,
            "text": sender.text,
            "messageType" : sender.messageType.rawValue
            ] as [String : Any]
        itemRef.setValue(messageItem)
        completionhandler()
    }


    
}
