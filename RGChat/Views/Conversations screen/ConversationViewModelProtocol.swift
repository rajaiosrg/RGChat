//
//  ConversationViewModeProtocol.swift
//  RGChat
//
//  Created by Raja Earla on 11/07/18.
//  Copyright © 2018 Raja Earla. All rights reserved.
//

import Foundation

protocol ConversationViewModelProtocol {
    
    var oneToOneChat : Chat! {get set}
    var cellIdentifier : String!  {get set}
    
}
