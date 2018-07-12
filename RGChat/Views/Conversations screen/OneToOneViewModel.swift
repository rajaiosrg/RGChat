//
//  OneToOneViewModel.swift
//  RGChat
//
//  Created by Raja Earla on 11/07/18.
//  Copyright © 2018 Raja Earla. All rights reserved.
//

import Foundation

class OneToOneViewModel : ConversationViewModelProtocol {
    var oneToOneChat: Chat!
    var cellIdentifier: String!
    
    func viewModelWithContentModel(chat : Chat) {
        oneToOneChat = chat
        cellIdentifier = "OneToOneTableViewCell"
    }
}
