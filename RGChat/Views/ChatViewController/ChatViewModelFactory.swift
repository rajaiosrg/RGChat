//
//  ChatViewModelFactory.swift
//  RGChat
//
//  Created by Raja Earla on 11/07/18.
//  Copyright © 2018 Raja Earla. All rights reserved.
//

import Foundation

class ChatViewModelFactory {
    
    func viewModelForMessage(_ message : Message) -> ChatViewModelProtocol? {

        if message.messageType == MessageType.Text.rawValue {
            let viewModel = TextMessageViewModel()
            viewModel.viewModelWithContentModel(messageModel : message)
            return viewModel
        } else {
            // for any other message types like Media/ location types
            return nil
        }
    }
}
