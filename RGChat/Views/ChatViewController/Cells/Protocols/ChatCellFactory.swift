//
//  ChatCellFactory.swift
//  RGChat
//
//  Created by Raja Earla on 12/07/18.
//  Copyright © 2018 Raja Earla. All rights reserved.
//

import Foundation
import UIKit

class ChatCellFactory {
    
    func cellForViewModel(viewModel : ChatViewModelProtocol) -> ChatTableViewCell? {
        
        if viewModel.cellIdentifier == String(describing: TextMessageTableViewCell.self) {
            let cell = TextMessageTableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: viewModel.cellIdentifier)
            return cell
        } else {
            // for any other message types like Media/ location types
            return nil
        }
    }

}
