//
//  TextMessageViewModel.swift
//  RGChat
//
//  Created by Raja Earla on 11/07/18.
//  Copyright © 2018 Raja Earla. All rights reserved.
//

import Foundation

class TextMessageViewModel : ChatViewModelProtocol {
    var message: Message = Message()
    var cellIdentifier : String = ""
    var messageText : String = ""
    var  isInComing: Bool = false
    
    
    func viewModelWithContentModel(messageModel : Message) {
        message = messageModel
        cellIdentifier = "TextMessageTableViewCell"
        messageText = messageModel.text
        let currentSenderId =  UserManager().userNumber()

        isInComing = messageModel.senderId != currentSenderId
    }
    
}
