//
//  ChatViewDataSource.swift
//  RGChat
//
//  Created by Raja Earla on 11/07/18.
//  Copyright © 2018 Raja Earla. All rights reserved.
//

import Foundation
//import JSQMessagesViewController

class ChatViewDataSource {
    
    var dataSourceManager : DataSourceManager!
    var channelId : String
    var senderId : String
    var chatData : ChatData
    
    init(chatData : ChatData) {
        self.channelId = chatData.channelId
        self.senderId = chatData.senderId
        self.chatData = chatData
    }

    func dataFromChannelId(completionHandler: @escaping (_ messages : [Message]) -> Void) {
        dataSourceManager = DataSourceManager(chatData : chatData)
        dataSourceManager.dataFromChannelId { messages in
            completionHandler(messages)
        }
    }
    
    func sendMessageToUser(sender : Sender,  completionhandler : @escaping () -> Void) {
        dataSourceManager.sendMessage(sender: sender) { () -> Void in
            completionhandler()
        }
    }
}
