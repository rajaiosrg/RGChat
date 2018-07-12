//
//  Sender.swift
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

struct Sender {
    var senderId : String
    var senderDisplayName : String
    var text : String
    var messageType : MessageType
}
