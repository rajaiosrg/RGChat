//
//  Message.swift
//  RGChat
//
//  Created by Raja Earla on 11/07/18.
//  Copyright © 2018 Raja Earla. All rights reserved.
//

import Foundation


enum MessageType : String {
    case None = "none", Text = "text", Image = "image"
    
    static let allValues = [None, Text, Image]
}

class Message  {
    
    var senderDisplayname : String = ""
    var senderId : String = ""
    var text : String = ""
    var messageType : MessageType = .None
    
    
    func initWithMessageData(messageData : [String : String]) {
        
        self.senderDisplayname = messageData["senderName"]!
        self.senderId = messageData["senderId"]!
        self.text = messageData["text"]!
        let msgType = messageData["messageType"]!
        self.messageType = MessageType(rawValue: msgType)!
    }
}
