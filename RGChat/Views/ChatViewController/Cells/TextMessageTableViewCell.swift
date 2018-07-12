//
//  TextMessageTableViewCell.swift
//  RGChat
//
//  Created by Raja Earla on 11/07/18.
//  Copyright © 2018 Raja Earla. All rights reserved.
//

import UIKit

class TextMessageTableViewCell: ChatTableViewCell {

    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override func bindWithViewModel(viewModel: ChatViewModelProtocol) {
        self.isIncomingMessage = viewModel.isInComing
        self.messageLabel.sizeToFit()
        self.messageLabel.text = viewModel.messageText
        self.messageLabel?.textColor = viewModel.isInComing ? UIColor.white : UIColor.black
        self.messageLabel.textAlignment = viewModel.isInComing ? .left : .right
        self.bubbleView?.backgroundColor = viewModel.isInComing ? UIColor.lightGray : UIColor.blue.withAlphaComponent(0.6)
        updateFrames(viewModel : viewModel)
    }
    
    func updateFrames(viewModel : ChatViewModelProtocol) {
        renderLayout()
    }
    
   
}
