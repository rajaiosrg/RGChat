//
//  ConversationViewModelFactory.swift.swift
//  RGChat
//
//  Created by Raja Earla on 11/07/18.
//  Copyright © 2018 Raja Earla. All rights reserved.
//

import Foundation

class ConversationViewModelFactory {
    
    func viewModelForChat(_ chat : Chat) -> ConversationViewModelProtocol? {
            let viewModel = OneToOneViewModel()
            viewModel.viewModelWithContentModel(chat: chat)
            return viewModel
    }
}
