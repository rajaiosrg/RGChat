//
//  ChatViewModelProtocol.swift
//  RGChat
//
//  Created by Raja Earla on 11/07/18.
//  Copyright © 2018 Raja Earla. All rights reserved.
//

import Foundation

protocol ChatViewModelProtocol {
 
    var message : Message {get set}
    var cellIdentifier : String {get set}
    var messageText : String {get set}
    var isInComing : Bool {get set}

}
